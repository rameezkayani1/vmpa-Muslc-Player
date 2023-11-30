// import 'package:flutter/material.dart';
// import 'package:on_audio_query/on_audio_query.dart';

// class PlaylistDetailsPage extends StatelessWidget {
//   final PlaylistModel playlist;

//   const PlaylistDetailsPage({Key? key, required this.playlist}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Playlist Details'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Playlist Name: ${playlist.id}',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             FutureBuilder<List<SongModel>>(
//               future: OnAudioQuery().queryAudiosFrom (
//                 playlist: playlist.id,
//                 // sortType: SortType.DEFAULT,
//               ),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return CircularProgressIndicator();
//                 } else if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return Text('No songs in the playlist');
//                 } else {
//                   List<SongModel> songs = snapshot.data!;

//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 16),
//                       Text(
//                         'Number of Songs: ${songs.length}',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       SizedBox(height: 16),
//                       Text(
//                         'Song List:',
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 8),
//                       Expanded(
//                         child: ListView.builder(
//                           itemCount: songs.length,
//                           itemBuilder: (context, index) {
//                             return ListTile(
//                               title: Text(songs[index].title),
//                               subtitle: Text(songs[index].artist.toString()),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
