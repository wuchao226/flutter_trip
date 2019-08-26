package com.wuc.flutter.trip;

import android.os.Bundle;

import com.wuc.flutter.plugin.asr.AsrPlugin;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        registerSelfPlugin();
    }

    /**
     * 百度语音监听
     */
    private void registerSelfPlugin() {
        AsrPlugin.registerWith(registrarFor("com.wuc.flutter.plugin.asr.AsrPlugin"));
    }

}
