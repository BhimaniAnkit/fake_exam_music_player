import 'package:flutter/material.dart';
import 'MusicData.dart';
import 'MusicDetailPage.dart';
import 'package:http/http.dart' as http;
import 'ServiceApi.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MusicData> musicList = [];


  @override
  void initState() {
    super.initState();
    fetchMusicData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music App'),
      ),
      body: customListCard(),
      // body: customListCard(),
    );
  }
  Future<void> fetchMusicData() async{
    final musiclist = await ServiceApi().getAllFetchMusicData();
    setState(() {
      musicList = musiclist;
    });
  }
  Widget customListCard(){
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: musicList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => MusicDetailPage(playList: musicList[index], currentIndex: 0)));
            // Navigator.push(context, MaterialPageRoute(builder: (context) => MusicDetailPage(response: musicList[index],playList: musicList, index: index,),));
            Navigator.push(context, MaterialPageRoute(builder: (context) => MusicDetailPage(response: musicList[index],playList: musicList,index: index,),));

          },
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0,right: 8.0,top: 4.0,bottom: 8.0),
                  child: SizedBox(
                    child: FadeInImage.assetNetwork(
                      height: 60,
                      width: 60,
                      placeholder: "images/musicplaceholder.png",
                      image: musicList[index].image.toString(),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Flexible(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    musicList[index].title.toString(),
                    style: TextStyle(color: Colors.white,fontSize: 18),
                  ),
                  SizedBox(height: 8,),
                  Text(
                    musicList[index].artist.toString(),
                    style: TextStyle(color: Colors.grey,fontSize: 12),
                  ),
                ],
              )),
            ],
          ),
        );
      },);
  }
}
