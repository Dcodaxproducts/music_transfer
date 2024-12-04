package pixart.aiart.generator

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

import pixart.aiart.generator.ProxyManager

class MainActivity : FlutterActivity() {

    private lateinit var proxyManager: ProxyManager

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Register Google Mobile Ads Native Ad Factory
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, "listTile", ListTileNativeAdFactory(context)
        )

        // Initialize and set up ProxyManager
        proxyManager = ProxyManager(context)
        proxyManager.setupMethodChannel(flutterEngine.dartExecutor.binaryMessenger)
    }

    override fun onDestroy() {
        // Clean up ProxyManager
        proxyManager.onDestroy()
        super.onDestroy()
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)

        // Unregister Google Mobile Ads Native Ad Factory
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "listTile")
    }
}
