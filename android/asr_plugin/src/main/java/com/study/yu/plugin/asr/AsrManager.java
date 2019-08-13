package com.study.yu.plugin.asr;

import android.content.Context;
import android.util.Log;

import com.baidu.speech.EventListener;
import com.baidu.speech.EventManager;
import com.baidu.speech.EventManagerFactory;
import com.baidu.speech.asr.SpeechConstant;

public class AsrManager {

    /**
     * SDK 内部核心 EventManager 类
     */
    private EventManager asr;

    // SDK 内部核心 事件回调类， 用于开发者写自己的识别回调逻辑
    private EventListener eventListener;

    // 未release前，只能 new 一个
    private static volatile boolean isInited = false;

    private static final String TAG = "AsrManager";

    /**
     * 初始化
     *
     * @param context context
     * @param recogListener 将 EventListener 结果做解析的 DEMO 回调。使用 RecogEventAdapter 适配 EventListener
     */
    public AsrManager(Context context, IRecogListener recogListener) {
        this(context, new RecogEventAdapter(recogListener));
    }

    /**
     * 初始化 提供 EventManagerFactory需要的Context和EventListener
     *
     * @param context
     * @param eventListener 识别状态和结果回调
     */
    private AsrManager(Context context, EventListener eventListener) {
        if (isInited) {
            Log.e(TAG, "还未调用release()，请勿新建一个新类");
            throw new RuntimeException("还未调用release()，请勿新建一个新类");
        }
        isInited = true;
        this.eventListener = eventListener;
        // SDK集成步骤 初始化asr的EventManager示例，多次得到的类，只能选一个使用
        asr = EventManagerFactory.create(context, "asr");
        // SDK集成步骤 设置回调event， 识别引擎会回调这个类告知重要状态和识别结果
        asr.registerListener(eventListener);
    }


    /**
     * 开始
     */
    public void start() {
        if (!isInited) {
            throw new RuntimeException("release() was called");
        }
        asr.send(SpeechConstant.ASR_START, "{}", null, 0, 0);
    }


    /**
     * 提前结束录音等待识别结果。
     */
    public void stop() {
        Log.d(TAG, "停止录音");
        // SDK 集成步骤（可选）停止录音
        if (!isInited) {
            throw new RuntimeException("release() was called");
        }
        asr.send(SpeechConstant.ASR_STOP, "{}", null, 0, 0);
    }

    /**
     * 取消本次识别，取消后将立即停止不会返回识别结果。
     * cancel 与stop的区别是 cancel在stop的基础上，完全停止整个识别流程，
     */
    public void cancel() {
        Log.d(TAG, "取消识别");
        if (!isInited) {
            throw new RuntimeException("release() was called");
        }
        // SDK集成步骤 (可选） 取消本次识别
        asr.send(SpeechConstant.ASR_CANCEL, "{}", null, 0, 0);
    }

    public void release() {
        if (asr == null) {
            return;
        }
        cancel();

        // SDK 集成步骤（可选），卸载listener
        asr.unregisterListener(eventListener);
        asr = null;
        isInited = false;
    }

    public void setEventListener(IRecogListener recogListener) {
        if (!isInited) {
            throw new RuntimeException("release() was called");
        }
        this.eventListener = new RecogEventAdapter(recogListener);
        asr.registerListener(eventListener);
    }

}
