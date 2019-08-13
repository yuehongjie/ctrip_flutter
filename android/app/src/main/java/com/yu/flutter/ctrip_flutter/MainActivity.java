package com.yu.flutter.ctrip_flutter;

import android.os.Bundle;
import android.util.Log;

import com.study.yu.plugin.asr.AsrPlugin;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    //注册自定义插件
    registerSelfPlugin();
  }


  public void registerSelfPlugin() {
      //注册 asr 插件
      AsrPlugin.registerWith(registrarFor("com.study.yu.plugin.asr.AsrPlugin"));
  }


}
