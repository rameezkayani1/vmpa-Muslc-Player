// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vmpa/widget/songscontoller.dart';
import 'package:flutter/material.dart';

import '../Screens/playerScreen.dart';

class Songpage extends StatefulWidget {
  const Songpage({super.key});

  @override
  State<Songpage> createState() => _SongpageState();
}

class _SongpageState extends State<Songpage> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());

    return Stack(children: [
      Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF1D1B29), Color(0xFF4527A0)]))),
      Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<List<SongModel>>(
            future: controller.audioQuery.querySongs(
              ignoreCase: true,
              orderType: OrderType.ASC_OR_SMALLER,
              sortType: null,
              uriType: UriType.EXTERNAL,
            ),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List snap = snapshot.data;
                if (snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text("No Song Found"),
                  );
                } else {
                  print("$snap ");
                  return Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ListView.builder(
                        itemCount: snap.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32)),
                            child: ListTile(
                              title: Text(
                                "${snapshot.data![index].displayNameWOExt}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.white),
                              ),
                              onTap: () {
                                Get.to(
                                  () => PlayerScreen(
                                    data: snapshot.data!,
                                  ),
                                  transition: Transition.downToUp,
                                );
                                controller.playSong(
                                    snapshot.data[index].uri, index);
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => PlayerScreen(
                                //               data: snapshot.data![index],
                                //               // key: snapshot.data![index],
                                //             ),
                                //             controller.playSong(
                                //       snapshot.data[index].uri, index);
                                //             )
                                //             );
                              },
                              subtitle: Text(
                                " ${snapshot.data![index].artist}",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                              leading: QueryArtworkWidget(
                                id: snapshot.data![index].id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: Icon(
                                  Icons.music_note,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                              // trailing:
                              //     // controller.playindex.value == index && controller.isplaying.value ?
                              //     //
                              //     //     ?
                              //     Icon(
                              //   Icons.play_arrow,
                              //   color: Colors.white,
                              //   size: 32,
                              // )
                              // // : null,
                              // onTap:() {
                              //   controller.playSong(
                              //   snapshot.data[index].uri, index);
                              // },

                              trailing: IconButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        height: 250,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ListTile(
                                              leading: Icon(Icons.playlist_add),
                                              title: Text('Ad to Playlist'),
                                            ),
                                            ListTile(
                                              leading: Icon(Icons.share),
                                              title: Text('Share'),
                                            ),
                                            SizedBox(
                                              height: 0,
                                            ),
                                            ListTile(
                                              leading:
                                                  Icon(Icons.details_outlined),
                                              title: Text('detail'),
                                            ),
                                            ListTile(
                                              leading:
                                                  Icon(Icons.delete_forever),
                                              title: Text('delete'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                  // controller.playSong(
                                  //     snapshot.data[index].uri, index);
                                },
                              ),
                            ),
                          );
                        }),
                  );
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    ]);
  }
}
//
//