import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/model/upscale_result.dart';

abstract class ImageUpscaleService {
  Future<Response?> upscaleImage(XFile image);

  Future<UpscaleResult?> processResponse(Response? response);

  Future<bool> saveHistoryInPrefs(List<UpscaleResult> upscaleHistory);

  List<UpscaleResult> getHistoryFromPrefs();
}
