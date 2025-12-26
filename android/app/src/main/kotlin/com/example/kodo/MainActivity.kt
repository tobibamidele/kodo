package com.example.kodo

import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {

    companion object {
        private const val SCREENSHOT_CHANNEL = "screenshot_channel"
        private const val DISABLE_SCREENSHOT = "disable_screenshot"
        private const val ENABLE_SCREENSHOT = "enable_screenshot"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            SCREENSHOT_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                // Disables screenshot by setting the FLAG_SECURE key
                DISABLE_SCREENSHOT -> {
                    window.setFlags(
                        WindowManager.LayoutParams.FLAG_SECURE,
                        WindowManager.LayoutParams.FLAG_SECURE
                    )
                    result.success(null)
                }

                // Enables screenshot by clearing the FLAG_SECURE key
                ENABLE_SCREENSHOT -> {
                    window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }
    }
}
