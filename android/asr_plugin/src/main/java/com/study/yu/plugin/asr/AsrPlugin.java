package com.study.yu.plugin.asr;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.util.Log;

import java.util.ArrayList;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class AsrPlugin implements MethodChannel.MethodCallHandler, PluginRegistry.RequestPermissionsResultListener {

    private final static String TAG = "AsrPlugin";
    private final Activity activity;
    private boolean isAllPermissionGranted;
    private ResultStateFul channelResult;
    private AsrManager asrManager;

    public static void registerWith(PluginRegistry.Registrar registrar) {
        MethodChannel channel = new MethodChannel(registrar.messenger(), "asr_plugin");
        final AsrPlugin instance = new AsrPlugin(registrar.activity());
        //registrar.addActivityResultListener(instance);
        registrar.addRequestPermissionsResultListener(instance);
        channel.setMethodCallHandler(instance);
    }

    private AsrPlugin(Activity activity) {
        this.activity = activity;
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {

        this.channelResult = ResultStateFul.of(result);

        switch (methodCall.method) {
            case "checkPermission":
                checkPermission();
                break;
            case "start":
                start();
                break;
            case "stop":
                stop();
                break;
            case "cancel":
                cancel();
                break;
            case "release":
                release();
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    //检查动态权限
    private void checkPermission() {

        Log.e(TAG, "checkPermission");

        String[] permissions = {
                Manifest.permission.RECORD_AUDIO,
                Manifest.permission.ACCESS_NETWORK_STATE,
                Manifest.permission.INTERNET,
                Manifest.permission.READ_PHONE_STATE,
                Manifest.permission.WRITE_EXTERNAL_STORAGE
        };

        ArrayList<String> toApplyList = new ArrayList<>();

        for (String perm : permissions) {
            if (PackageManager.PERMISSION_GRANTED != ContextCompat.checkSelfPermission(activity, perm)) {
                toApplyList.add(perm);
                // 进入到这里代表没有权限.

            }
        }
        String[] tmpList = new String[toApplyList.size()];
        if (!toApplyList.isEmpty()) {
            ActivityCompat.requestPermissions(activity, toApplyList.toArray(tmpList), 123);
        }else {
            //所有权限都申请通过
            isAllPermissionGranted = true;
            channelResult.success(true);
            Log.e(TAG, "checkPermission allGranted: true");
        }
    }

    @Override
    public boolean onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        isAllPermissionGranted = true;
        for (int result : grantResults) {
            if (result != PackageManager.PERMISSION_GRANTED) {
                isAllPermissionGranted = false;
                break;
            }
        }

        channelResult.success(isAllPermissionGranted);
        Log.e(TAG, "checkPermission allGranted: " + isAllPermissionGranted);

        return isAllPermissionGranted;
    }

    //开始录音
    private void start() {

        Log.e(TAG, "start");
        AsrManager asrManager = getAsrManager();
        if (asrManager != null) {
            asrManager.start();
        }

    }

    //结束录音
    private void stop() {
        Log.e(TAG, "stop");
        if (asrManager != null) {
            asrManager.stop();
        }
    }

    //取消录音
    private void cancel() {
        Log.e(TAG, "cancel");
        if (asrManager != null) {
            asrManager.cancel();
        }
    }

    //释放资源
    private void release() {
        Log.e(TAG, "release");
        if (asrManager != null) {
            asrManager.release();
            asrManager = null;
        }
    }


    @Nullable
    private AsrManager getAsrManager() {
        if (asrManager == null) {
            if (activity != null && !activity.isFinishing()) {
                asrManager = new AsrManager(activity, recogListener);
            }
        }
        return asrManager;
    }

    private ImpRecogListener recogListener = new ImpRecogListener(){

        //最终识别结果
        @Override
        public void onAsrFinalResult(String[] results, RecogResult recogResult) {
            if (channelResult != null) {
                channelResult.success(results[0]);
            }
        }

        //识别失败
        @Override
        public void onAsrFinishError(int errorCode, int subErrorCode, String descMessage, RecogResult recogResult) {
            if (channelResult != null) {
                channelResult.error(descMessage, null, null);
            }
        }
    };

}
