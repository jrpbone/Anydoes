import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final projectDirectory = Directory.current;
  final scriptDirectory = Directory('${projectDirectory.path}\\tools');
  final powershell = File(
    '${Platform.environment['SystemRoot']}\\System32\\WindowsPowerShell\\v1.0\\powershell.exe',
  );

  Future<ProcessResult> runScript(
    File script,
    List<String> arguments, {
    Map<String, String>? environment,
  }) {
    return Process.run(powershell.path, <String>[
      '-NoProfile',
      '-NonInteractive',
      '-ExecutionPolicy',
      'Bypass',
      '-File',
      script.path,
      ...arguments,
    ], environment: environment);
  }

  String outputOf(ProcessResult result) =>
      '${result.stdout}\n${result.stderr}'.toLowerCase();

  Map<String, String> withoutFlutterOnPath() {
    final environment = Map<String, String>.from(Platform.environment);
    environment['PATH'] = '';
    environment['Path'] = '';
    return environment;
  }

  Future<File> createProjectManifest(Directory root) async {
    await File(
      '${root.path}\\pubspec.yaml',
    ).writeAsString('name: anydoes_fixture\nversion: 1.0.0+1\n');
    await File(
      '${root.path}\\android\\app\\build.gradle.kts',
    ).create(recursive: true);
    final manifest = File(
      '${root.path}\\android\\app\\src\\main\\AndroidManifest.xml',
    );
    await manifest.create(recursive: true);
    await manifest.writeAsString(
      '<manifest><application android:label="Anydoes" /></manifest>',
    );
    return manifest;
  }

  test('build script reports a missing Flutter installation', () async {
    final result = await runScript(
      File('${scriptDirectory.path}\\build_anydoes.ps1'),
      const <String>['-NonInteractive'],
      environment: withoutFlutterOnPath(),
    );

    expect(result.exitCode, isNot(0));
    expect(outputOf(result), contains('flutter was not found on path'));
  });

  test('run script reports a missing Flutter installation', () async {
    final result = await runScript(
      File('${scriptDirectory.path}\\run_anydoes.ps1'),
      const <String>['-SkipPubGet'],
      environment: withoutFlutterOnPath(),
    );

    expect(result.exitCode, isNot(0));
    expect(outputOf(result), contains('flutter was not found on path'));
  });

  test('signing setup refuses to overwrite an existing keystore', () async {
    final fixture = await Directory.systemTemp.createTemp(
      'anydoes-signing-test-',
    );
    addTearDown(() => fixture.delete(recursive: true));

    final script = File('${fixture.path}\\setup_android_signing.ps1');
    await File(
      '${scriptDirectory.path}\\setup_android_signing.ps1',
    ).copy(script.path);
    await createProjectManifest(fixture);
    final keystore = File('${fixture.path}\\android\\app\\anydoes-release.jks');
    await keystore.parent.create(recursive: true);
    await keystore.writeAsString('existing-keystore');

    final result = await runScript(script, <String>[
      '-ProjectDirectory',
      fixture.path,
      '-GeneratePassword',
    ]);

    expect(result.exitCode, isNot(0));
    expect(outputOf(result), contains('refusing to overwrite'));
    expect(await keystore.readAsString(), 'existing-keystore');
    expect(
      File('${fixture.path}\\android\\key.properties').existsSync(),
      isFalse,
    );
  });

  test('scripts discover the Flutter root above their own directory', () async {
    final expectedManifest = File(
      '${projectDirectory.path}\\android\\app\\src\\main\\AndroidManifest.xml',
    ).absolute.path.toLowerCase();

    for (final name in <String>[
      'build_anydoes.ps1',
      'run_anydoes.ps1',
      'setup_android_signing.ps1',
    ]) {
      final result = await runScript(
        File('${scriptDirectory.path}\\$name'),
        const <String>['-ValidateProjectOnly'],
      );

      expect(result.exitCode, 0, reason: '$name: ${outputOf(result)}');
      expect(outputOf(result), contains(expectedManifest), reason: name);
    }
  });

  test(
    'scripts honor explicit project and manifest paths from elsewhere',
    () async {
      final externalDirectory = await Directory.systemTemp.createTemp(
        'anydoes-external-scripts-',
      );
      addTearDown(() => externalDirectory.delete(recursive: true));
      final projectFixture = Directory(
        '${externalDirectory.path}\\relocated-project',
      );
      await File(
        '${projectFixture.path}\\pubspec.yaml',
      ).create(recursive: true);
      await File(
        '${projectFixture.path}\\android\\app\\build.gradle.kts',
      ).create(recursive: true);
      final explicitManifest = File(
        '${projectFixture.path}\\configuration\\required\\AndroidManifest.xml',
      ).absolute;
      await explicitManifest.create(recursive: true);
      await explicitManifest.writeAsString('<manifest />');
      final externalScriptDirectory = Directory(
        '${externalDirectory.path}\\standalone-scripts',
      );
      await externalScriptDirectory.create(recursive: true);

      for (final name in <String>[
        'build_anydoes.ps1',
        'run_anydoes.ps1',
        'setup_android_signing.ps1',
      ]) {
        final externalScript = await File(
          '${scriptDirectory.path}\\$name',
        ).copy('${externalScriptDirectory.path}\\$name');
        final result = await runScript(externalScript, <String>[
          '-ProjectDirectory',
          projectFixture.absolute.path,
          '-ManifestPath',
          explicitManifest.path,
          '-ValidateProjectOnly',
        ]);

        expect(result.exitCode, 0, reason: '$name: ${outputOf(result)}');
        expect(
          outputOf(result),
          contains(explicitManifest.path.toLowerCase()),
          reason: name,
        );
      }
    },
  );
}
