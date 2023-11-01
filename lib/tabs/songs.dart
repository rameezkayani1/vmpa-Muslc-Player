// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vmpa/widget/songscontoller.dart';
import 'package:flutter/material.dart';

class Songpage extends StatefulWidget {
  const Songpage({super.key});

  @override
  State<Songpage> createState() => _SongpageState();
}

class _SongpageState extends State<Songpage> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());

    return Scaffold(
      backgroundColor: Colors.black45,
      body: FutureBuilder<List<SongModel>>(
          future: controller.audioQuery.querySongs(
            ignoreCase: true,
            orderType: OrderType.ASC_OR_SMALLER,
            sortType: null,
            uriType: UriType.EXTERNAL,
          ),
          builder: (BuildContext context, snapshot) {
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
                padding: EdgeInsets.all(20.0),
                child: ListView.builder(
                    itemCount: 25,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32)),
                        child: ListTile(
                          title: Text(
                            "${snapshot.data![index].displayNameWOExt}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.white),
                          ),
                          subtitle: Text(
                            " ${snapshot.data![index].artist}",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          leading: Icon(
                            Icons.music_note,
                            color: Colors.white,
                            size: 32,
                          ),
                          trailing: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      );
                    }),
              );
            }
          }),
    );
  }
}


/////
///
///
///
///
///