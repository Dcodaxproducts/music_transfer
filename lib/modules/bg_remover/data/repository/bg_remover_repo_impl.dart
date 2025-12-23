import 'dart:convert';
import 'package:pixart_app/core/api/api_client.dart';
import 'package:pixart_app/imports.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/api/api_client_impl.dart';
import '../model/bg_remover_result.dart';
import 'bg_remover_repo.dart';

class BgRemoverRepoImpl implements BgRemoverRepo {
  final ApiClient apiClient;
  final SharedPreferences prefs;
  BgRemoverRepoImpl({required this.apiClient, required this.prefs});

  @override
  Future<Response?> removeImageBackground(
    Map<String, dynamic> body,
    MultipartBody multipartBody,
  ) async => await apiClient.postMultipart(Endpoints.removeBackground, body, [
    multipartBody,
  ], hideLoading: false);

  @override
  Future<bool> saveHistoryInPrefs(List<BgRemoverResult> history) async {
    return await prefs.setStringList(
      SharedKeys.bgRemoverHistory,
      history.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  @override
  List<String>? getHistoryFromPrefs() {
    return prefs.getStringList(SharedKeys.bgRemoverHistory);
  }
}
