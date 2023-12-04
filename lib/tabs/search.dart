import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get.dart';
import '../Screens/playerScreen.dart';
import '../widget/songscontoller.dart';

class SearchPage extends StatelessWidget {
  final PlayerController controller = Get.put(PlayerController());

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("Search"),
          actions: [
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                // Clear the search query
                controller.audioQuery.querySongs(
                  ignoreCase: true,
                  orderType: OrderType.ASC_OR_SMALLER,
                  sortType: null,
                  uriType: UriType.EXTERNAL,
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: MusicSearchDelegate(controller: controller),
        ),
      ),
    ]);
  }
}

class MusicSearchDelegate extends StatefulWidget {
  final PlayerController controller;

  MusicSearchDelegate({required this.controller});

  @override
  _MusicSearchDelegateState createState() => _MusicSearchDelegateState();
}

class _MusicSearchDelegateState extends State<MusicSearchDelegate> {
  late Future<List<SongModel>> _searchResults;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchResults = _loadAllSongs();
  }

  Future<List<SongModel>> _loadAllSongs() async {
    return widget.controller.audioQuery.querySongs(
      ignoreCase: true,
      orderType: OrderType.ASC_OR_SMALLER,
      sortType: null,
      uriType: UriType.EXTERNAL,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          style: TextStyle(fontSize: 20, color: Colors.white),
          controller: _searchController,
          onChanged: (query) {
            // Update the search results as the user types
            setState(() {
              _searchResults = _filterSongs(query);
            });
          },
          decoration: InputDecoration(
            hintText: "Search for songs...",
            hintStyle: TextStyle(fontSize: 18.0, color: Colors.white),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
          ),
        ),
        FutureBuilder<List<SongModel>>(
          future: _searchResults,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                  child: Text(
                "No Song Found",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white),
              ));
            } else {
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        "${snapshot.data![index].displayNameWOExt}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white),
                      ),
                      onTap: () {
                        Get.to(
                          () => PlayerScreen(
                            data: snapshot.data!,
                          ),
                          transition: Transition.downToUp,
                        );
                        widget.controller
                            .playSong(snapshot.data![index].uri, index);
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
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Implement your actions here
                        },
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Future<List<SongModel>> _filterSongs(String query) async {
    final List<SongModel> allSongs = await _loadAllSongs();
    final List<SongModel> filteredSongs = allSongs
        .where((song) =>
            song.displayNameWOExt.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return filteredSongs;
  }
}
