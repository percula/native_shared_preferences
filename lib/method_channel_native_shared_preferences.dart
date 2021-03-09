// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/services.dart';

import 'native_shared_preferences_platform_interface.dart';

const MethodChannel _kChannel = MethodChannel('native_shared_preferences');

/// Wraps NSUserDefaults (on iOS) and SharedPreferences (on Android), providing
/// a persistent store for simple data.
///
/// Data is persisted to disk asynchronously.
class MethodChannelNativeSharedPreferencesStore extends NativeSharedPreferencesStorePlatform {
  @override
  Future<bool> remove(String key) {
    return _invokeBoolMethod('remove', <String, dynamic>{
      'key': key,
    });
  }

  @override
  Future<bool> setValue(String? valueType, String key, Object value) {
    return _invokeBoolMethod('set$valueType', <String, dynamic>{
      'key': key,
      'value': value,
    });
  }

  Future<bool> _invokeBoolMethod(String method, Map<String, dynamic> params) {
    return _kChannel.invokeMethod<bool>(method, params).then<bool>((dynamic result) => result);
  }

  @override
  Future<bool?> clear() {
    return _kChannel.invokeMethod<bool>('clear');
  }

  @override
  Future<Map<String, Object>?> getAll() {
    return _kChannel.invokeMapMethod<String, Object>('getAll');
  }

  @override
  Future<Map<String, Object>?> getAllFromDictionary(List<String> keys) {
    return _kChannel.invokeMapMethod('getAllFromDictionary', <String, Object>{
      'keys': keys,
    });
  }
}
