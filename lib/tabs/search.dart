import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vmpa/Screens/playerScreen.dart';

import '../widget/songscontoller.dart';

class MusicSearchDelegate extends SearchDelegate<String> {
  final PlayerController controller = Get.put(PlayerController());

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SongSearchResults(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SongSearchResults(query: query);
  }
}

class SongSearchResults extends StatelessWidget {
  final String query;

  const SongSearchResults({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlayerController controller = Get.find();

    return FutureBuilder<List<SongModel>>(
      future: controller.audioQuery.querySongs(
        ignoreCase: true,
        orderType: OrderType.ASC_OR_SMALLER,
        sortType: null,
        uriType: UriType.EXTERNAL,
        //  where: 'title LIKE ? OR artist LIKE ? OR album LIKE ?',
        //   whereArgs: ['%$query%', '%$query%', '%$query%'],
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
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: ListTile(
                      title: Text(
                        "${snapshot.data![index].displayNameWOExt}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Get.to(
                          () => PlayerScreen(
                            data: snapshot.data!,
                          ),
                          transition: Transition.downToUp,
                        );
                        controller.playSong(snapshot.data[index].uri, index);
                      },
                      subtitle: Text(
                        " ${snapshot.data![index].artist}",
                        style: TextStyle(fontSize: 12, color: Colors.white),
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
                      trailing: IconButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed: () {
                          // Your code for handling more options...
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
