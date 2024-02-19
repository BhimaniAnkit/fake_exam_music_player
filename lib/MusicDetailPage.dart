import 'dart:convert';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'MusicData.dart';
import 'package:http/http.dart' as http;

class MusicDetailPage extends StatefulWidget {
  MusicData response;
  final List<MusicData> playList;
  // final int currentIndex;

  // MusicDetailPage({Key? key,required this.playList,required this.currentIndex}) : super(key: key);

  int index;
  //  MusicDetailPage({Key? key,required this.response,required this.index}) : super(key: key);
  MusicDetailPage({Key? key,required this.response,required this.playList,required this.index}) : super(key: key);

  @override
  State<MusicDetailPage> createState() => _MusicDetailPageState();
}

class _MusicDetailPageState extends State<MusicDetailPage> {
  // late AudioPlayer player;
  final player = AudioPlayer();
  // late List<Map<String,dynamic>> songs;
  // int currentIndex = 0;
  // List <MusicData> playlist = []; // Add your list of MusicData here
  bool isPlaying = false;
  Duration duration = Duration(seconds: 0);
  Duration position = Duration(seconds: 0);

  @override
  void initState() {
    super.initState();
    // player = AudioPlayer();
    // fetchData();
    setAudio();
    // print("currentIndex:= $currentIndex");

    player.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    player.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    player.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final url = widget.response.image.toString();
    final MusicData currentSong = widget.playList[widget.index];
    // final MusicData currentSong = widget.playList[widget.currentIndex];
    // final MusicData currentSong = widget.playlist[widget.currentIndex];


    return Scaffold(
      appBar: AppBar(
        title: Text("Music Detail Page"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.network(
                url,
                height: MediaQuery.of(context).size.height / 2.75,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 32,),
            Text(
              // "${currentSong['title']}",
              widget.response.title.toString(),
              style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4,),
            Text(
              // "${currentSong['artist']}",
              widget.response.artist.toString(),
              style: TextStyle(fontSize: 20),
            ),
            Slider(
                value: position.inMilliseconds.toDouble(),
                min: 0.0,
                activeColor: Colors.white,
                max: duration.inMilliseconds.toDouble(),
                label: "${position} / ${duration}",
                onChanged: (value) async {
                  // player.seek(Duration(milliseconds: value.toInt()));
                  // final position = Duration(seconds: value.toInt());
                  await player.seek(position);
                  await player.resume();
                },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatTime(position)),
                  Text(formatTime(duration - position)),
                ],
              ),
            ),
            Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: () async {
                  // Logic for Previous Button
                  playPreviousSong();
                },
                  icon: Icon(Icons.skip_previous_sharp),
                  splashRadius: 30.0,
                  iconSize: 50,
                  tooltip: "Play Previous Song",
                  splashColor: Colors.cyan,
                  hoverColor: Colors.lightBlueAccent,
                ),
                CircleAvatar(
                  radius: 35,
                  child: IconButton(onPressed: () async {
                    // player.play(currentSong['source']);
                    // playSong(currentSong['source']);
                    if(isPlaying){
                      await player.pause();
                    }
                    else{
                      await player.resume();
                    }
                  }, icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),iconSize: 50,),
                ),
                IconButton(onPressed: () {
                  // Logic for Next Button
                  playNextSong();
                },
                  icon: Icon(Icons.skip_next_sharp),
                  splashRadius: 30.0,
                  iconSize: 50,
                  tooltip: "Play Next Song",
                  splashColor: Colors.cyan,
                  hoverColor: Colors.lightBlueAccent,
                ),
                IconButton(
                  onPressed: () async {
                    try{
                      await FileDownloader.downloadFile(
                        url: "${widget.response.source.toString()}",
                        name: widget.response.title,
                        onDownloadCompleted: (String path) {
                          print("Your File Downloaded Completed := $path");
                        },
                        onDownloadError: (errorMessage) {
                          print("Download Failed := $errorMessage");
                        },
                      );
                    }
                    catch(e){
                      print("Error Downloading File := $e");
                    }
                    // FileDownloader.downloadFile(
                    //   url: "${widget.response.source.toString()}",
                    //   // url: "${widget.d!.source}",
                    //   name: "${widget.response.title}",
                    //   // name: "Your File is Downloading",
                    //   onDownloadCompleted: (String path) {
                    //     print("Your File Downloaded Completed := $path");
                    //   },
                    //   onDownloadError: (errorMessage) {
                    //     print("Download Failed: $errorMessage");
                    //   },
                    // );
                  }, icon: Icon(Icons.download),),
              ],
            ),),
            // CircleAvatar(
            //   radius: 35,
            //   child: IconButton(onPressed: () async {
            //     if(isPlaying){
            //       await player.pause();
            //     }
            //     else{
            //       await player.resume();
            //     }
            //   }, icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),iconSize: 50,),
            // ),
          ],
        ),
      ),
    );
  }

  void setAudio() async {
    try {
      // player.setReleaseMode(ReleaseMode.loop);
      await player.setSourceUrl(widget.response.source.toString());
      await player.resume();
    } catch (e) {
      print("Error setting audio:= $e");
    }
  }

  void playPreviousSong() async{
    player.pause();
    print(0.11);
    int previousIndex = (widget.index - 1 + widget.playList.length) % widget.playList.length;
    print("previousIndex:= ${previousIndex}");
    setState(() {
      widget.index = previousIndex;
      widget.response = MusicData(
        title: widget.playList[previousIndex].title,
        artist: widget.playList[previousIndex].artist,
        image: widget.playList[previousIndex].image,
        source: widget.playList[previousIndex].source,
      );
    });
    // player.setReleaseMode(ReleaseMode.loop);
    // await player.setSourceUrl(widget.response.source.toString());
    // await player.resume();
    setAudio();
  }

  void playNextSong() async{
    int nextIndex = (widget.index + 1) % widget.playList.length;
    setState(() {
      widget.index = nextIndex;
      widget.response = MusicData(
        title: widget.playList[nextIndex].title,
        artist: widget.playList[nextIndex].artist,
        image: widget.playList[nextIndex].image,
        source: widget.playList[nextIndex].source,
      );
    });
    setAudio();
  }

  // Future<void> setAudio() async{
  //   try{
  //     player.setReleaseMode(ReleaseMode.loop);
  //     // await player.setSourceUrl(widget.playlist[widget.currentIndex].source.toString());
  //     // await player.setSourceUrl(playlist[currentIndex].source.toString());
  //     // await player.setSource(widget.response.source.toString() as Source);
  //     await player.setSourceUrl(widget.response.source.toString());
  //     // await player.resume();
  //   }
  //   catch(e){
  //     print("Error setting audio:= $e");
  //   }
  // }

  String formatTime(Duration duration){
    String twoDigits(int n) => n.toString().padLeft(2,"");
    final hours = twoDigits(duration.inHours);
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if(duration.inHours > 0)hours,
      twoDigitMinutes,
      twoDigitSeconds
    ].join(':');
  }
}
