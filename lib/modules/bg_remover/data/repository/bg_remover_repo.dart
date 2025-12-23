import 'package:http/http.dart';
import '../../../../core/api/api_client_impl.dart';
import '../model/bg_remover_result.dart';

abstract class BgRemoverRepo {
  Future<Response?> removeImageBackground(
    Map<String, dynamic> body,
    MultipartBody multipartBody,
  );

  Future<bool> saveHistoryInPrefs(List<BgRemoverResult> history);

  List<String>? getHistoryFromPrefs();
}
