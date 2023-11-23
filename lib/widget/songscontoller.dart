import 'package:permission_handler/permission_handler.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class PlayerController extends GetxController {
  // show modelbottomsheet
  final audioQuery = OnAudioQuery();
  final player = AudioPlayer();
  var playindex = 0.obs;
  var isplaying = false.obs;
  var duration = ''.obs;
  var position = ''.obs;
  var max = 0.0.obs;
  var value = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    checkPermission();
  }

  Updateposition() {
    player.durationStream.listen((d) {
      duration.value = d.toString().split(".")[0];
      max.value = d!.inSeconds.toDouble();
      print("durition");
    });
    player.positionStream.listen((p) {
      position.value = p.toString().split(".")[0];
      value.value = p.inSeconds.toDouble();
    });
    print("positon");
  }

  changeDurationtoSecond(seconds) {
    var duration = Duration(seconds: seconds);
    player.seek(duration);
  }

  // playSong(String? uri, index) {
  //   if (isplaying) {
  //     player.pause();
  //     isplaying = false;
  //     print('pause the song');
  //   } else {
  //     // playindex.value = index;
  //     player.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
  //     player.play();
  //     isplaying = true;
  //     print('play the song');
  //   }
  // }
  playSong(String? uri, index) {
    playindex.value = index;
    try {
      player.setAudioSource(
        AudioSource.uri(Uri.parse(uri!)),
      );
      Updateposition();
      player.play();
      isplaying(true);
    } on Exception catch (e) {
      print(e.toString());
    }
    ;
  }

  // void pauseSong() {
  //   // Implement your logic to pause the song
  //   // Set isPlaying to false
  //   // player.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
  //   player.pause();

  //   isplaying(false);
  //   print('Pausing the song');
  // }

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

