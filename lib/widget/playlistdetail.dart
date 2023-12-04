// import 'package:flutter/material.dart';

// import 'model.dart';

// class PlaylistDetailsPage extends StatefulWidget {
//   final PlaylistModel playlist;

//   PlaylistDetailsPage({Key? key, required this.playlist}) : super(key: key);

//   @override
//   _PlaylistDetailsPageState createState() => _PlaylistDetailsPageState();
// }

// class _PlaylistDetailsPageState extends State<PlaylistDetailsPage> {
//   List<String> playlistSongs = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.playlist.name),
//       ),
//       body: ListView.builder(
//         itemCount: playlistSongs.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(playlistSongs[index]),
//             // Add onTap functionality to play the song or perform other actions.
//             onTap: () {
//               // Implement the desired action when a song is tapped.
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           // Show a dialog or navigate to a new page to add songs to the playlist.
//           String newSong = await showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: Text('Add New Song'),
//                 content: TextField(
//                   decoration: InputDecoration(labelText: 'Song Name'),
//                   onChanged: (value) => newSong = value,
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context); // Close the dialog.
//                     },
//                     child: Text('Cancel'),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       // Implement the logic to add the new song to the playlist.
//                       Navigator.pop(context, newSong);
//                     },
//                     child: Text('Add'),
//                   ),
//                 ],
//               );
//             },
//           );

//           if (newSong != null && newSong.isNotEmpty) {
//             setState(() {
//               playlistSongs.add(newSong);
//             });
//           }
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
