import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class RecommendationsWidget extends StatelessWidget {
  final List<SongModel> recommendations;
  final Function(int) onSongSelected;

  RecommendationsWidget(
      {required this.recommendations, required this.onSongSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: recommendations.asMap().entries.map((entry) {
        final index = entry.key;
        final song = entry.value;
        return InkWell(
          onTap: () {
            // Call the onSongSelected callback when a song is tapped
            onSongSelected(index);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                // Add an icon, such as a music note icon
                Icon(
                  Icons.music_note,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  song.displayNameWOExt,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
