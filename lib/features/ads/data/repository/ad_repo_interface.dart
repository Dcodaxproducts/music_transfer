import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart';

abstract class AdRepoInterface {
  Future<Response?> getAdIds();
  Future<T?> loadAd<T>(String unitId);
  FullScreenContentCallback<T> getFullScreenContentCallback<T>();
}
