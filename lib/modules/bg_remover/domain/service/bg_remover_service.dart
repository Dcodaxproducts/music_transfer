import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/model/bg_remover_result.dart';

abstract class BgRemoverService {
  Future<Response?> removeBg(XFile image);

  Future<BgRemoverResult?> processResponse(Response? response);

  Future<bool> saveHistoryInPrefs(List<BgRemoverResult> history);

  List<BgRemoverResult> getHistoryFromPrefs();
}
