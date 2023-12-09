// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vmpa/widget/songscontoller.dart';
import 'package:flutter/material.dart';

import '../Screens/albummusic.dart';

// ...

class MusicAlbum extends StatefulWidget {
  const MusicAlbum({Key? key});

  @override
  State<MusicAlbum> createState() => _MusicAlbumState();
}

class _MusicAlbumState extends State<MusicAlbum> {
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
          body: FutureBuilder<List<AlbumModel>>(
            future: OnAudioQuery().queryAlbums(),
            builder: (BuildContext context,
                AsyncSnapshot<List<AlbumModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No Albums Found'));
              } else {
                List<AlbumModel> albums = snapshot.data!;

                return Padding(
                  padding: EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount: albums.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                          albums[index].album,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Get.to(() => AlbumSongsScreen(album: albums[index]));

                          // Handle album tap (e.g., navigate to album details screen)
                        },
                        subtitle: Text(
                          "${albums[index].album} songs",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        leading: QueryArtworkWidget(
                          id: albums[index].id,
                          type: ArtworkType.ALBUM,
                          nullArtworkWidget: Icon(
                            Icons.album,
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
