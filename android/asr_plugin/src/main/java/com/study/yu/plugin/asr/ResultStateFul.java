package com.study.yu.plugin.asr;

import android.support.annotation.Nullable;
import android.util.Log;

import io.flutter.plugin.common.MethodChannel;

// 因为 MethodChannel 只能一次通信，回复一次，所以做一个检查
public class ResultStateFul implements MethodChannel.Result {

    private MethodChannel.Result result;
    private boolean called;

    public static ResultStateFul of(MethodChannel.Result result) {
        return new ResultStateFul(result);
    }

    private ResultStateFul(MethodChannel.Result result) {
        this.result = result;
    }

    @Override
    public void success(@Nullable Object o) {
        if (!called) {
            called = true;
            result.success(o);
        }else {
            alreadyCalledError();
        }
    }

    @Override
    public void error(String s, @Nullable String s1, @Nullable Object o) {
        if (!called) {
            called = true;
            result.error(s, s1, o);
        }else {
            alreadyCalledError();
        }
    }

    @Override
    public void notImplemented() {
        if (!called) {
            called = true;
            result.notImplemented();
        }else {
            alreadyCalledError();
        }
    }

    private void alreadyCalledError(){
        Log.e("ResultStateFul", "MethodChannel 已回复，不能重复调用");
    }
}
