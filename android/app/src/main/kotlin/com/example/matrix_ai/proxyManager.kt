package pixart.aiart.generator

import android.content.Context
import android.content.Intent
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import mobileproxy.Mobileproxy
import mobileproxy.Proxy

class ProxyManager(private val context: Context) : MethodChannel.MethodCallHandler {

    private var proxy: Proxy? = null

    companion object {
        const val PROXY_CHANNEL = "com.example.matrix_ai/proxy"
    }

    fun setupMethodChannel(messenger: io.flutter.plugin.common.BinaryMessenger) {
        MethodChannel(messenger, PROXY_CHANNEL).setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "startOutlineProxy" -> handleStartProxy(call, result)
            "stopOutlineProxy" -> handleStopProxy(result)
            else -> result.notImplemented()
        }
    }

    private fun handleStartProxy(call: MethodCall, result: MethodChannel.Result) {
        val key = call.argument<String>("key")
        val ip = call.argument<String>("ip")
        val port = call.argument<String>("port")

        if (key.isNullOrBlank() || ip.isNullOrBlank() || port.isNullOrBlank()) {
            result.error("InvalidArguments", "Key, IP, or Port cannot be null or empty", null)
            return
        }

        try {
            // Start the proxy
            proxy = Mobileproxy.runProxy("$ip:$port", Mobileproxy.newStreamDialerFromConfig(key))
            result.success("Proxy started at: ${proxy?.address()}")
        } catch (e: Exception) {
            result.error("ProxyError", "Failed to start proxy: ${e.message}", null)
        }
    }

    private fun handleStopProxy(result: MethodChannel.Result) {
        if (proxy != null) {
            // Stop the proxy
            proxy?.stop(0)
            proxy = null
            result.success("Proxy and VPN stopped successfully")
        } else {
            result.error("ProxyNotSet", "No active proxy to stop", null)
        }
    }

    fun onDestroy() {
        if (proxy != null) {
            proxy?.stop(0)
            proxy = null
        }
    }
}
