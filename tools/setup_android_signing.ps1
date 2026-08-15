[CmdletBinding()]
param(
    [Parameter()]
    [string]$ProjectDirectory,

    [Parameter()]
    [string]$ManifestPath,

    [Parameter()]
    [switch]$ValidateProjectOnly,

    [Parameter()]
    [string]$Alias = 'anydoes',

    [Parameter()]
    [string]$CommonName = 'Anydoes',

    [Parameter()]
    [string]$Organization = 'Anydoes',

    [Parameter()]
    [string]$City = 'Ligao',

    [Parameter()]
    [string]$State = 'Albay',

    [Parameter()]
    [ValidatePattern('^[A-Za-z]{2}$')]
    [string]$CountryCode = 'PH',

    [Parameter()]
    [ValidateRange(365, 36500)]
    [int]$ValidityDays = 10000,

    [Parameter()]
    [switch]$GeneratePassword
)

$ErrorActionPreference = 'Stop'
$androidDirectory = $null
$keystorePath = $null
$propertiesPath = $null
$createdKeystore = $false
$createdProperties = $false

function Test-AnydoesProjectRoot {
    param([Parameter(Mandatory)] [string]$Candidate)

    return (
        (Test-Path -LiteralPath (Join-Path $Candidate 'pubspec.yaml') -PathType Leaf) -and
        (Test-Path -LiteralPath (Join-Path $Candidate 'android/app/build.gradle.kts') -PathType Leaf)
    )
}

function Find-AnydoesProjectRoot {
    param([Parameter(Mandatory)] [string]$StartPath)

    if (-not (Test-Path -LiteralPath $StartPath)) { return $null }
    $item = Get-Item -LiteralPath $StartPath
    if (-not $item.PSIsContainer) { $item = $item.Directory }
    while ($null -ne $item) {
        if (Test-AnydoesProjectRoot -Candidate $item.FullName) {
            return $item.FullName
        }
        $item = $item.Parent
    }
    return $null
}

function Resolve-AnydoesProjectContext {
    param(
        [Parameter()] [string]$RequestedProjectDirectory,
        [Parameter()] [string]$RequestedManifestPath
    )

    $resolvedProjectDirectory = $null
    if (-not [string]::IsNullOrWhiteSpace($RequestedProjectDirectory)) {
        $resolvedProjectDirectory = [IO.Path]::GetFullPath($RequestedProjectDirectory)
        if (-not (Test-Path -LiteralPath $resolvedProjectDirectory -PathType Container)) {
            throw "Project directory was not found: $resolvedProjectDirectory"
        }
        if (-not (Test-AnydoesProjectRoot -Candidate $resolvedProjectDirectory)) {
            throw "The directory is not an Android Flutter project: $resolvedProjectDirectory"
        }
    }
    else {
        foreach ($startPath in @($PSScriptRoot, (Get-Location).Path)) {
            $resolvedProjectDirectory = Find-AnydoesProjectRoot -StartPath $startPath
            if ($resolvedProjectDirectory) { break }
        }
    }

    if (-not $resolvedProjectDirectory -and -not [string]::IsNullOrWhiteSpace($RequestedManifestPath)) {
        $manifestStart = [IO.Path]::GetFullPath($RequestedManifestPath)
        $resolvedProjectDirectory = Find-AnydoesProjectRoot -StartPath $manifestStart
    }
    if (-not $resolvedProjectDirectory) {
        throw 'Could not locate the Anydoes Flutter project. Run from inside the project or pass -ProjectDirectory.'
    }

    if (-not [string]::IsNullOrWhiteSpace($RequestedManifestPath)) {
        $resolvedManifestPath = if ([IO.Path]::IsPathRooted($RequestedManifestPath)) {
            [IO.Path]::GetFullPath($RequestedManifestPath)
        }
        else {
            [IO.Path]::GetFullPath((Join-Path $resolvedProjectDirectory $RequestedManifestPath))
        }
    }
    else {
        $resolvedManifestPath = Join-Path $resolvedProjectDirectory 'android/app/src/main/AndroidManifest.xml'
        if (-not (Test-Path -LiteralPath $resolvedManifestPath -PathType Leaf)) {
            $androidDirectory = Join-Path $resolvedProjectDirectory 'android'
            $matches = @(
                Get-ChildItem -LiteralPath $androidDirectory -Filter 'AndroidManifest.xml' -File -Recurse |
                    Where-Object { $_.FullName -notmatch '[\\/](build|\.gradle)[\\/]' }
            )
            $mainMatches = @(
                $matches | Where-Object { $_.FullName -match '[\\/]src[\\/]main[\\/]AndroidManifest\.xml$' }
            )
            if ($mainMatches.Count -eq 1) {
                $resolvedManifestPath = $mainMatches[0].FullName
            }
            elseif ($matches.Count -eq 1) {
                $resolvedManifestPath = $matches[0].FullName
            }
            elseif ($matches.Count -gt 1) {
                throw "Multiple Android manifests were found. Pass -ManifestPath to select the required one.`n$($matches.FullName -join [Environment]::NewLine)"
            }
        }
    }

    if (-not (Test-Path -LiteralPath $resolvedManifestPath -PathType Leaf)) {
        throw "Android manifest was not found: $resolvedManifestPath"
    }

    return [pscustomobject]@{
        ProjectDirectory = [IO.Path]::GetFullPath($resolvedProjectDirectory)
        ManifestPath = [IO.Path]::GetFullPath($resolvedManifestPath)
    }
}

function ConvertFrom-PrivateSecureString {
    param([Parameter(Mandatory)] [Security.SecureString]$Value)

    $pointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($Value)
    try {
        return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($pointer)
    }
    finally {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($pointer)
    }
}

function New-RandomPassword {
    $bytes = New-Object byte[] 32
    $generator = [Security.Cryptography.RandomNumberGenerator]::Create()
    try {
        $generator.GetBytes($bytes)
    }
    finally {
        $generator.Dispose()
    }
    return ([Convert]::ToBase64String($bytes)).TrimEnd('=').Replace('+', '-').Replace('/', '_')
}

function Find-Keytool {
    $command = Get-Command keytool -ErrorAction SilentlyContinue
    if ($command) { return $command.Source }
    if (-not [string]::IsNullOrWhiteSpace($env:JAVA_HOME)) {
        $javaHomeKeytool = Join-Path $env:JAVA_HOME 'bin\keytool.exe'
        if (Test-Path -LiteralPath $javaHomeKeytool) { return $javaHomeKeytool }
    }
    $androidStudioKeytool = 'C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe'
    if (Test-Path -LiteralPath $androidStudioKeytool) { return $androidStudioKeytool }
    throw 'keytool was not found. Install Android Studio or a Java Development Kit and retry.'
}

try {
    $projectContext = Resolve-AnydoesProjectContext `
        -RequestedProjectDirectory $ProjectDirectory `
        -RequestedManifestPath $ManifestPath
    $ProjectDirectory = $projectContext.ProjectDirectory
    $ManifestPath = $projectContext.ManifestPath
    $androidDirectory = Join-Path $ProjectDirectory 'android'
    $keystorePath = Join-Path $androidDirectory 'app\anydoes-release.jks'
    $propertiesPath = Join-Path $androidDirectory 'key.properties'

    if ($ValidateProjectOnly) {
        Write-Host "Project:  $ProjectDirectory"
        Write-Host "Manifest: $ManifestPath"
        exit 0
    }

    if (-not (Test-Path -LiteralPath $androidDirectory -PathType Container)) {
        throw "Android project directory was not found: $androidDirectory"
    }
    if (Test-Path -LiteralPath $keystorePath) {
        throw "Refusing to overwrite the existing keystore: $keystorePath"
    }
    if (Test-Path -LiteralPath $propertiesPath) {
        throw "Refusing to overwrite the existing signing configuration: $propertiesPath"
    }

    $password = if ($GeneratePassword) {
        New-RandomPassword
    }
    else {
        $first = ConvertFrom-PrivateSecureString (Read-Host 'New keystore password' -AsSecureString)
        $second = ConvertFrom-PrivateSecureString (Read-Host 'Confirm keystore password' -AsSecureString)
        if ([string]::IsNullOrWhiteSpace($first) -or $first.Length -lt 12) {
            throw 'The keystore password must contain at least 12 characters.'
        }
        if ($first -cne $second) {
            throw 'The passwords did not match.'
        }
        $first
    }

    $keytoolPath = Find-Keytool
    $distinguishedName = "CN=$CommonName, OU=Anydoes, O=$Organization, L=$City, ST=$State, C=$($CountryCode.ToUpperInvariant())"
    $env:ANYDOES_KEYSTORE_PASSWORD = $password

    Write-Host 'Creating the Anydoes Android upload keystore...' -ForegroundColor Cyan
    & $keytoolPath `
        -genkeypair `
        -v `
        -keystore $keystorePath `
        -storetype PKCS12 `
        '-storepass:env' ANYDOES_KEYSTORE_PASSWORD `
        '-keypass:env' ANYDOES_KEYSTORE_PASSWORD `
        -alias $Alias `
        -keyalg RSA `
        -keysize 2048 `
        -validity $ValidityDays `
        -dname $distinguishedName
    if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $keystorePath)) {
        throw "keytool failed to create the keystore (exit code $LASTEXITCODE)."
    }
    $createdKeystore = $true

    $properties = @(
        "storePassword=$password"
        "keyPassword=$password"
        "keyAlias=$Alias"
        'storeFile=anydoes-release.jks'
        ''
    ) -join [Environment]::NewLine
    [IO.File]::WriteAllText($propertiesPath, $properties, [Text.UTF8Encoding]::new($false))
    $createdProperties = $true

    & $keytoolPath `
        -list `
        -keystore $keystorePath `
        '-storepass:env' ANYDOES_KEYSTORE_PASSWORD `
        -alias $Alias | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "The created keystore could not be verified (exit code $LASTEXITCODE)."
    }

    Write-Host 'Android release signing configured successfully.' -ForegroundColor Green
    Write-Host "Keystore:  $keystorePath"
    Write-Host "Properties: $propertiesPath"
    Write-Host 'Back up both files together in a secure password manager or encrypted archive.' -ForegroundColor Yellow
    Write-Host 'Neither file should ever be committed to Git.' -ForegroundColor Yellow
}
catch {
    if ($createdProperties -and (Test-Path -LiteralPath $propertiesPath)) {
        Remove-Item -LiteralPath $propertiesPath -Force -ErrorAction SilentlyContinue
    }
    if ($createdKeystore -and (Test-Path -LiteralPath $keystorePath)) {
        Remove-Item -LiteralPath $keystorePath -Force -ErrorAction SilentlyContinue
    }
    Write-Error $_
    exit 1
}
finally {
    Remove-Item Env:ANYDOES_KEYSTORE_PASSWORD -ErrorAction SilentlyContinue
    $password = $null
}
