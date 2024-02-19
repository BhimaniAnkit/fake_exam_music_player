class MusicData {
  String? id;
  String? title;
  String? album;
  String? artist;
  String? genre;
  String? source;
  String? image;
  int? trackNumber;
  int? totalTrackCount;
  int? duration;
  String? site;

  MusicData(
      {this.id,
        this.title,
        this.album,
        this.artist,
        this.genre,
        this.source,
        this.image,
        this.trackNumber,
        this.totalTrackCount,
        this.duration,
        this.site});

  MusicData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    album = json['album'];
    artist = json['artist'];
    genre = json['genre'];
    source = json['source'];
    image = json['image'];
    trackNumber = json['trackNumber'];
    totalTrackCount = json['totalTrackCount'];
    duration = json['duration'];
    site = json['site'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['album'] = this.album;
    data['artist'] = this.artist;
    data['genre'] = this.genre;
    data['source'] = this.source;
    data['image'] = this.image;
    data['trackNumber'] = this.trackNumber;
    data['totalTrackCount'] = this.totalTrackCount;
    data['duration'] = this.duration;
    data['site'] = this.site;
    return data;
  }
}
