import 'package:flutter/material.dart';
import 'package:vmpa/tabs/songs.dart';

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
              child: new Image.asset("assets/logo.png",
                  fit: BoxFit.cover, height: 20.00, width: 20.00),
            ),
            title: Text(
              "VMPA",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 25),
                child: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
            ],
            bottom: TabBar(
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
          body: TabBarView(
            children: [
              Songpage(),
              Icon(Icons.album, size: 350),
              Icon(Icons.person, size: 350),
              Icon(Icons.playlist_add, size: 350),
            ],
          ),
        ));
  }
}
