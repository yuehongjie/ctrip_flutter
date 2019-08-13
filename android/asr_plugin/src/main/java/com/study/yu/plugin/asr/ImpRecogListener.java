package com.study.yu.plugin.asr;

//一个 IRecogListener 的空实现，方便选择性实现
public class ImpRecogListener implements IRecogListener{
    @Override
    public void onAsrReady() {

    }

    @Override
    public void onAsrBegin() {

    }

    @Override
    public void onAsrEnd() {

    }

    @Override
    public void onAsrPartialResult(String[] results, RecogResult recogResult) {

    }

    @Override
    public void onAsrOnlineNluResult(String nluResult) {

    }

    @Override
    public void onAsrFinalResult(String[] results, RecogResult recogResult) {

    }

    @Override
    public void onAsrFinish(RecogResult recogResult) {

    }

    @Override
    public void onAsrFinishError(int errorCode, int subErrorCode, String descMessage, RecogResult recogResult) {

    }

    @Override
    public void onAsrLongFinish() {

    }

    @Override
    public void onAsrVolume(int volumePercent, int volume) {

    }

    @Override
    public void onAsrAudio(byte[] data, int offset, int length) {

    }

    @Override
    public void onAsrExit() {

    }

    @Override
    public void onOfflineLoaded() {

    }

    @Override
    public void onOfflineUnLoaded() {

    }
}
