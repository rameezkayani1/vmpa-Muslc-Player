// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'dart:math';
import '../widget/RecommendedSongs.dart';
import '../widget/songscontoller.dart';

class PlayerScreen extends StatefulWidget {
  final List<SongModel> data;

  const PlayerScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  bool showRecommendations = false;
  var controller = Get.find<PlayerController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1D1B29), Color(0xFF4527A0)],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      height: 250,
                      width: 250,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color(0xFF4527A0),
                          Color(0xFF1D1B29),
                        ]),
                        shape: BoxShape.circle,
                      ),
                      child: QueryArtworkWidget(
                        id: widget.data[controller.playindex.value].id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 100,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF1D1B29), Color(0xFF4527A0)],
                        ),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Obx(
                        () => Column(
                          children: [
                            Text(
                              widget.data[controller.playindex.value]
                                  .displayNameWOExt,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              widget.data[controller.playindex.value].artist
                                  .toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Obx(
                              () => Row(
                                children: [
                                  Text(
                                    controller.position.value,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Expanded(
                                    child: Slider(
                                      thumbColor: Colors.amber,
                                      inactiveColor: Colors.white,
                                      activeColor: Colors.red,
                                      value: controller.value.value,
                                      min: const Duration(seconds: 0)
                                          .inSeconds
                                          .toDouble(),
                                      max: controller.max.value,
                                      onChanged: (newvalue) {
                                        controller.changeDurationtoSecond(
                                            newvalue.toInt());
                                        newvalue = newvalue;
                                      },
                                    ),
                                  ),
                                  Text(
                                    controller.duration.value,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Obx(
                              () => Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                if (widget.data.isNotEmpty &&
                                                    controller.playindex.value >
                                                        0) {
                                                  controller.playSong(
                                                    widget
                                                        .data[controller
                                                                .playindex
                                                                .value -
                                                            1]
                                                        .uri,
                                                    controller.playindex.value -
                                                        1,
                                                  );
                                                } else {
                                                  // Handle when it's already the first song or the list is empty
                                                  // For example, you might want to loop to the last song:
                                                  if (widget.data.isNotEmpty) {
                                                    controller.playSong(
                                                      widget.data.last.uri,
                                                      widget.data.length - 1,
                                                    );
                                                  }
                                                  // Or display a message to the user:
                                                  // ScaffoldMessenger.of(context).showSnackBar(
                                                  //   SnackBar(
                                                  //     content: Text('You are already at the first song.'),
                                                  //   ),
                                                  // );
                                                }
                                              },
                                              icon: Icon(
                                                Icons.skip_previous,
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                            ),
                                            CircleAvatar(
                                              radius: 34,
                                              backgroundColor:
                                                  Colors.blueAccent,
                                              child: Transform.scale(
                                                scale: 2.2,
                                                child: IconButton(
                                                  onPressed: () {
                                                    if (controller
                                                        .isplaying.value) {
                                                      controller.player.pause();
                                                      controller
                                                          .isplaying(false);
                                                    } else {
                                                      controller.player.play();
                                                      controller
                                                          .isplaying(true);
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
                                            IconButton(
                                              onPressed: () {
                                                if (widget.data.isNotEmpty &&
                                                    controller.playindex.value +
                                                            1 <
                                                        widget.data.length) {
                                                  controller.playSong(
                                                    widget
                                                        .data[controller
                                                                .playindex
                                                                .value +
                                                            1]
                                                        .uri,
                                                    controller.playindex.value +
                                                        1,
                                                  );
                                                } else {
                                                  // Handle when it's already the last song or the list is empty
                                                  // For example, you might want to loop to the first song:
                                                  if (widget.data.isNotEmpty) {
                                                    controller.playSong(
                                                      widget.data.first.uri,
                                                      0,
                                                    );
                                                  }
                                                  // Or display a message to the user:
                                                  // ScaffoldMessenger.of(context).showSnackBar(
                                                  //   SnackBar(
                                                  //     content: Text('You are already at the last song.'),
                                                  //   ),
                                                  // );
                                                }
                                              },
                                              icon: Icon(
                                                Icons.skip_next,
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              List<SongModel> recommendedSongs =
                                                  getRandomSongs();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      RecommendedSongsPage(
                                                    recommendedSongs:
                                                        recommendedSongs,
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: Icon(
                                              Icons.next_plan_sharp,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<SongModel> getRandomSongs() {
    List<SongModel> shuffledSongs = List.from(widget.data);
    shuffledSongs.shuffle();
    return shuffledSongs.take(10).toList();
  }
}
