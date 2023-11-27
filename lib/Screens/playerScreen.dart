// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../widget/RecommendedSongs.dart';
import '../widget/songscontoller.dart';

class PlayerScreen extends StatefulWidget {
  final List<SongModel> data;

  const PlayerScreen({super.key, required this.data});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  bool showRecommendations = false;

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();

    return Stack(children: [
      Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF1D1B29), Color(0xFF4527A0)]))),
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
                      shape: BoxShape.circle),
                  child: QueryArtworkWidget(
                    id: widget.data[controller.playindex.value].id,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                )),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xFF1D1B29), Color(0xFF4527A0)]),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16))),
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
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          widget.data[controller.playindex.value].artist
                              .toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
                                    color: Colors.white),
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
                                    }),
                              ),
                              Text(
                                controller.duration.value,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Obx(
                          () => Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
//
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              controller.playSong(
                                                  widget
                                                      .data[controller
                                                              .playindex.value -
                                                          1]
                                                      .uri,
                                                  controller.playindex.value -
                                                      1);
                                            },
                                            icon: Icon(
                                              Icons.skip_previous,
                                              color: Colors.white,
                                              size: 40,
                                            )),
                                        CircleAvatar(
                                          radius: 34,
                                          backgroundColor: Colors.blueAccent,
                                          child: Transform.scale(
                                            scale: 2.2,
                                            child: IconButton(
                                              onPressed: () {
                                                if (controller
                                                    .isplaying.value) {
                                                  controller.player.pause();
                                                  controller.isplaying(false);
                                                  // Pause action
                                                } else {
                                                  controller.player.play();
                                                  controller.isplaying(true);

                                                  // Play action
                                                }
                                              },

                                              icon: Icon(
                                                controller.isplaying.value
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                                color: Colors.white,
                                                size: 32,
                                              ),
                                              // ),
                                              // IconButton(
                                              //     onPressed: () {
                                              //       if (controller.isplaying.value) {
                                              //         controller.player.pause();
                                              //         controller.isplaying(false);
                                              //       } else {
                                              //         controller.player.play();
                                              //         controller.isplaying(true);
                                              //       }
                                              //       ;
                                              //     },
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              controller.playSong(
                                                  widget
                                                      .data[controller
                                                              .playindex.value +
                                                          1]
                                                      .uri,
                                                  controller.playindex.value +
                                                      1);
                                            },
                                            icon: Icon(
                                              Icons.skip_next,
                                              color: Colors.white,
                                              size: 40,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              Column(
                                // mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              showRecommendations =
                                                  !showRecommendations;
                                              print(showRecommendations);
                                            });
                                          },
                                          icon: Icon(
                                            Icons.next_plan_sharp,
                                            color: Colors.white,
                                            size: 40,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Container(
                        //   alignment: Alignment.topLeft,
                        //   child: Text(
                        //     "Up Next:",
                        //     style: TextStyle(color: Colors.white, fontSize: 15),
                        //   ),
                        // ),
                        Visibility(
                          visible: showRecommendations,
                          child: Expanded(
                            child: RecommendationsWidget(
                              recommendations: widget.data.sublist(
                                controller.playindex.value + 1,
                                controller.playindex.value + 4,
                              ),
                              // Pass a callback to handle song selection
                              onSongSelected: (index) {
                                // Scroll to the top
                                Scrollable.ensureVisible(
                                  context,
                                  duration: Duration(milliseconds: 500),
                                );

                                // Play the selected song
                                // controller.playSong(
                                //     widget.data[index + 1].uri, index + 1);
                                int actualIndex =
                                    controller.playindex.value + 1 + index;
                                controller.playSong(
                                    widget.data[actualIndex].uri, actualIndex);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
