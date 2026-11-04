import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class YoutubeVideo {
  final String id;
  final String title;
  final String thumbnail;
  final String published;

  const YoutubeVideo({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.published,
  });

  String get url => 'https://www.youtube.com/watch?v=$id';
}

class YoutubeService {
  static const String channelId = 'UCADV2hay2J0SThrc-vlqRIg';

  static Future<List<YoutubeVideo>> fetchVideos() async {
    final uri = Uri.parse(
      'https://www.youtube.com/feeds/videos.xml?channel_id=$channelId',
    );

    final response = await http.get(
      uri,
      headers: {'User-Agent': 'Mozilla/5.0'},
    ).timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Imeshindikana kupata video kutoka YouTube');
    }

    final document = XmlDocument.parse(response.body);
    final entries = document.findAllElements('entry');

    return entries.map((entry) {
      final id = entry
          .findElements('videoId', namespaceUri: null)
          .first
          .innerText;

      final title = entry.findElements('title').first.innerText;

      final published = entry.findElements('published').first.innerText;

      final thumbnail = entry
          .findElements('thumbnail', namespaceUri: null)
          .first
          .getAttribute('url') ??
          'https://img.youtube.com/vi/$id/hqdefault.jpg';

      return YoutubeVideo(
        id: id,
        title: title,
        thumbnail: thumbnail,
        published: published,
      );
    }).toList();
  }
}
