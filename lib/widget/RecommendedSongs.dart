import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vmpa/widget/songscontoller.dart';
import '../Screens/playerScreen.dart';

class RecommendedSongsPage extends StatelessWidget {
  final List<SongModel> recommendedSongs;
  final PlayerController controller = Get.find<PlayerController>();

  RecommendedSongsPage({Key? key, required this.recommendedSongs})
      : super(key: key);

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
          title: Text('Recommended Songs'),
        ),
        body: ListView.builder(
          itemCount: recommendedSongs.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                recommendedSongs[index].displayName,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white),
              ),
              subtitle: Text(
                recommendedSongs[index].artist ?? 'Unknown Artist',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.white),
              ),
              onTap: () {
                Get.to(
                  () => PlayerScreen(
                    data:
                        recommendedSongs, // Pass the entire list of recommended songs
                  ),
                  transition: Transition.downToUp,
                );
                controller.playSong(recommendedSongs[index].uri, index);
              },
              leading: QueryArtworkWidget(
                id: recommendedSongs[index].id,
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
                    size: 32,
                  ),
                  onPressed: () {}),
            );
          },
        ),
      ),
    ]);
  }
}
