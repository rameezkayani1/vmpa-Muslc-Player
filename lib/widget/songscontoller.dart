import 'package:permission_handler/permission_handler.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get.dart';

class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();

  @override
  void onInit() {
    super.onInit();
    checkPermission();
  }

  checkPermission() async {
    var perm = await Permission.storage.request();

    if (perm.isGranted) {
    } else {
      checkPermission();
    }
  }
}

// class Playercontroller extends Getxcontroller {

// final audioquery = OnAudioquery();

// @override
//  void Oninit(){
// super.oninit();

// checkPermission();

// }

// checkPermission() async {

// var perm = await permission storge request();
// if (perm is Grandted) {

// return audioQuery querySongs(
// ignorecase: true,
// orderType: OrdertyopeASC_OR_SMALLER,
// sortType: null.urlType.External,
// );
// esle {
// checkPermission();
// }
// }

// }

// }

