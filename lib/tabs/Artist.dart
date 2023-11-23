import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vmpa/widget/songscontoller.dart';

class Artist extends StatefulWidget {
  const Artist({super.key});

  @override
  State<Artist> createState() => _ArtistState();
}

class _ArtistState extends State<Artist> {
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
              // sortType: null,
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
                                " ${snapshot.data![index].artist}}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.white),
                              ),
                              onTap: () {
                                // Get.to(() => PlayerScreen);
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => PlayerScreen()));
                              },
                              leading: QueryArtworkWidget(
                                id: snapshot.data![index].id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: Icon(
                                  Icons.music_note,
                                  color: Colors.white,
                                  size: 32,
                                ),
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
