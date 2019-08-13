
import 'package:flutter/services.dart';

//百度 AI 语音 Native 通信接口
class AsrManager {

  static const MethodChannel _channel = const MethodChannel('asr_plugin');


  /// 检查权限
  static Future<bool> checkPermission() async {
    return await _channel.invokeMethod('checkPermission');
  }

  /// 开始录音
  static Future<String> start({Map params}) async {

    return await _channel.invokeMethod('start', params ?? {});
  }

  /// 停止录音
  static Future<String> stop() async {

    return await _channel.invokeMethod('stop');
  }

  /// 取消录音
  static Future<String> cancel() async {

    return await _channel.invokeMethod('cancel');
  }

  static void release() {
    _channel.invokeMethod('release');
  }

}