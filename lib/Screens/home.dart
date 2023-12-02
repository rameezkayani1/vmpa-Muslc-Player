import 'package:flutter/material.dart';
import 'package:vmpa/tabs/songs.dart';

import '../tabs/Album.dart';
import '../tabs/Artist.dart';
import '../tabs/search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            // backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Image.asset("assets/logo.png",
                  fit: BoxFit.cover, height: 20.00, width: 20.00),
            ),
            title: const Text(
              "VMPA",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 25),
                child: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    showSearch(
                        context: context, delegate: MusicSearchDelegate());
                  },
                ),
              ),
            ],
            bottom: const TabBar(
              tabs: [
                Tab(
                  child: Text(
                    "Song",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    "Album",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    "Artist",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    "playlist",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              Songpage(),
              MusicAlbum(),
              Artist(),
              MusicAlbum(),

              // PlaylistPage(),

              // PlaylistManagementPage(playlists: playlists,),
              // playlist(),
            ],
          ),
        ));
  }
}
