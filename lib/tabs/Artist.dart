import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vmpa/widget/songscontoller.dart';

import '../Screens/artistmusic.dart';

// ...

class Artist extends StatefulWidget {
  const Artist({Key? key});

  @override
  State<Artist> createState() => _ArtistState();
}

class _ArtistState extends State<Artist> {
  var controller = Get.put(MusicController());

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
          body: FutureBuilder<List<ArtistModel>>(
            future: OnAudioQuery().queryArtists(),
            builder: (BuildContext context,
                AsyncSnapshot<List<ArtistModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No Artists Found'));
              } else {
                List<ArtistModel> artists = snapshot.data!;

                return Padding(
                  padding: EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount: artists.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                          artists[index].artist,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Get.to(
                              () => ArtistMusicScreen(artist: artists[index]));
                        },
                        subtitle: Text(
                          "${artists[index].numberOfAlbums} albums",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        leading: QueryArtworkWidget(
                          id: artists[index].id,
                          type: ArtworkType.ARTIST,
                          nullArtworkWidget: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
