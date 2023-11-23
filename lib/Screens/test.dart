import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../widget/songscontoller.dart';

class PlayerScreen extends StatefulWidget {
  final SongModel data;

  const PlayerScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration:
                      BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: QueryArtworkWidget(
                    id: widget.data.id,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.data.displayNameWOExt,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        widget.data.artist.toString(),
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 10),
                      // Row(
                      //   children: [
                      //     Text(
                      //       // controller.formatDuration(controller.position),
                      //       style: TextStyle(color: Colors.grey),
                      //     ),
                      //     Expanded(
                      //       child: Slider(
                      //         // value: controller.position.inSeconds.toDouble(),
                      //         // max: controller.duration.inSeconds.toDouble(),
                      //         onChanged: (newValue) {
                      //           // Handle slider value change
                      //           // You might want to seek the player to the new position
                      //           controller.seekTo(Duration(seconds: newValue.toInt()));
                      //         },
                      //       ),
                      //     ),
                      //   Text(
                      //     controller.formatDuration(controller.duration),
                      //     style: TextStyle(color: Colors.grey),
                      //   ),
                      // ],
                      // ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.shuffle),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.skip_previous, size: 40),
                          ),
                          Obx(
                            () => CircleAvatar(
                              radius: 34,
                              backgroundColor: Colors.black,
                              child: Transform.scale(
                                scale: 2.5,
                                child: IconButton(
                                  onPressed: () {
                                    if (controller.playSong(
                                        widget.data.uri.toString(),
                                        widget.data)) {
                                      controller.player.pause();
                                    } else {
                                      controller.player.play();
                                    }
                                  },
                                  icon: Icon(
                                    controller.isplaying.value
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.skip_next, size: 40),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.repeat),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
