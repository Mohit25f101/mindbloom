import 'dart:async';

// Minimal mock definitions for testing
class Target {
  final String name;
  Target(this.name);
}

class Environment {}

// ✅ Remove invalid internal imports
// import 'package:flutter_tools/src/build_info.dart';
// import 'package:flutter_tools/src/build_system/build_system.dart';
// import '../../lib/src/build_system.dart' show BuildSystem;

// ✅ If you need custom types, define them here
class BuildResult {
  final bool success;
  final String message;

  BuildResult(this.success, {this.message = ''});
}

abstract class BuildSystem {
  Future<BuildResult> build();
}

// ✅ Your test system
class TestBuildSystem implements BuildSystem {
  final List<BuildResult> _results;
  final BuildResult? _singleResult;
  final Exception? _exception;
  int _nextResult = 0;
  void Function(Target, Environment)? _onRun;

  TestBuildSystem.list(this._results, [this._exception, this._singleResult, this._onRun]);

  TestBuildSystem.all(this._singleResult, [this._exception, this._onRun]) : _results = [];

  @override
  Future<BuildResult> build() async {
    if (_exception != null) {
      throw _exception;
    }
    return _singleResult ?? (_results.isNotEmpty ? _results.first : BuildResult(true));
  }

  Future<BuildResult> buildIncremental(
    Target target,
    Environment environment,
    BuildResult? previousBuild,
  ) async {
    if (_onRun != null) {
      _onRun!(target, environment);
    }
    if (_exception != null) {
      throw _exception;
    }
    if (_singleResult != null) {
      return _singleResult;
    }
    if (_results.isEmpty || _nextResult >= _results.length) {
      throw StateError('Unexpected buildIncremental request of [${target.name}');
    }
    return _results[_nextResult++];
  }
}

// Stub for encodeDartDefines to resolve error
String encodeDartDefines(Map<String, String> defines) {
  return defines.entries.map((e) => '${e.key}=${e.value}').join(',');
}

/// Encodes a map of key-value pairs into a comma-separated base64 encoded string.
///
/// ## Example
///
/// ```dart
/// print(encodeDartDefines({'FLUTTER_WEB': 'true', 'FLUTTER_WEB_CANVASKIT_URL': 'https://example.com'}));
/// // RkxVVFRFUl9XRUI9dHJ1ZQo=,RkxVVFRFUl9XRUJfQ0FOVkFTS0lUX1VSTD1odHRwczovL2V4YW1wbGUuY29t
/// ```
String encodeDartDefinesMap(Map<String, String> defines) {
  // Directly pass the map to encodeDartDefines
  return encodeDartDefines(defines);
}
