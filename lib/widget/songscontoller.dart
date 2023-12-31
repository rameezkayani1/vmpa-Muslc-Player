import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class MusicController extends GetxController {
  late OnAudioQuery audioQuery;
  final player = AudioPlayer();
  List<PlaylistModel> playlists = [];
  Map<int, List<SongModel>> playlistSongsMap = {};
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
    initializeController();
  }

  Future<void> initializeController() async {
    audioQuery = OnAudioQuery();
    await fetchPlaylists();
  }

  Future<void> fetchPlaylists() async {
    try {
      var status = await Permission.storage.status;
      if (status.isGranted) {
        playlists = await audioQuery.queryPlaylists();
        await updatePlaylistSongsMap();
      } else {
        // Request permission and handle the response
        var result = await Permission.storage.request();
        if (result.isGranted) {
          await fetchPlaylists(); // Retry fetching playlists after permission is granted
        } else {
          // Handle permission denied scenario
        }
      }
    } catch (e) {
      print('Error fetching playlists: $e');
    }
  }

  // Future<void> fetchPlaylists() async {
  //   try {
  //     playlists = await audioQuery.queryPlaylists();
  //     await updatePlaylistSongsMap();
  //   } catch (e) {
  //     print('Error fetching playlists: $e');
  //   }
  // }

  Future<void> updatePlaylistSongsMap() async {
    for (var playlist in playlists) {
      List<SongModel> songs = await fetchSongsForPlaylist(playlist.id);
      playlistSongsMap[playlist.id] = songs;
    }
  }

  Future<bool> createNewPlaylist(String playlistName) async {
    try {
      bool success = await audioQuery.createPlaylist(playlistName);
      if (success) {
        await fetchPlaylists(); // Update the playlists after creating a new one
      }
      return success;
    } catch (e) {
      print('Error creating new playlist: $e');
      return false;
    }
  }

  Future<List<SongModel>> fetchSongsForPlaylist(int playlistId) async {
    return playlistSongsMap[playlistId] ?? [];
  }

  bool isSongInPlaylist(SongModel song, int playlistId) {
    return playlistSongsMap.containsKey(playlistId) &&
        playlistSongsMap[playlistId]!.contains(song);
  }

  // Future<void> addSongToPlaylist(int playlistId, SongModel song) async {
  //   try {
  //     await audioQuery.addToPlaylist(playlistId, song.id);
  //     if (playlistSongsMap.containsKey(playlistId)) {
  //       playlistSongsMap[playlistId]!.add(song);
  //     } else {
  //       playlistSongsMap[playlistId] = [song];
  //     }
  //     update();
  //   } catch (e) {
  //     print('Error adding song to playlist: $e');
  //   }
  // }
  Future<void> addSongToPlaylist(int playlistId, SongModel song) async {
    try {
      // Check if the song is already in the playlist
      if (!isSongInPlaylist(song, playlistId)) {
        await audioQuery.addToPlaylist(playlistId, song.id);

        // Update the local playlistSongsMap
        if (playlistSongsMap.containsKey(playlistId)) {
          playlistSongsMap[playlistId]!.add(song);
        } else {
          playlistSongsMap[playlistId] = [song];
        }

        update();
        _showAddToPlaylistSnackbar(true);
      } else {
        // Show a snackbar indicating that the song is already in the playlist
        _showAddToPlaylistSnackbar(false);
      }
    } catch (e) {
      print('Error adding song to playlist: $e');
      _showAddToPlaylistSnackbar(false);
    }
  }

  void _showAddToPlaylistSnackbar(bool success) {
    String message = success
        ? 'Song added to playlist successfully'
        : 'Failed to add song to playlist';
    if (!success) {
      message = 'Song is already in the playlist';
    }
    Get.snackbar(
      'Add to Playlist',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: success ? Colors.green : Colors.red,
      colorText: Colors.white,
    );
  }

  Updateposition() {
    player.durationStream.listen((d) {
      duration.value = d.toString().split(".")[0];
      max.value = d!.inSeconds.toDouble();
    });
    player.positionStream.listen((p) {
      position.value = p.toString().split(".")[0];
      value.value = p.inSeconds.toDouble();
    });
  }

  changeDurationtoSecond(seconds) {
    var duration = Duration(seconds: seconds);
    player.seek(duration);
  }

  playSong(String? uri, int index) {
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
  }

  // void checkPermission() async {
  //   final plugin = DeviceInfoPlugin();
  //   final android = await plugin.androidInfo;

  //   final perm = android.version.sdkInt < 33
  //       ? await Permission.storage.request()
  //       : PermissionStatus.granted;

  //   if (perm == PermissionStatus.granted) {
  //     print("granted");
  //   }
  //   if (perm == PermissionStatus.denied) {
  //     print("denied");
  //   }
  //   if (perm == PermissionStatus.permanentlyDenied) {
  //     openAppSettings();
  //   }
  // }

  checkPermission() async {
    var perm = await Permission.storage.request();
    if (perm.isGranted) {
      print("granted");
    } else if (perm.isDenied) {
      print("denied");
      openAppSettings();
    } else if (perm.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
