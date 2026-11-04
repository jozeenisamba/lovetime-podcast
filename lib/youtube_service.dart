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

  static XmlElement? findElement(XmlElement parent, String localName) {
    for (final element in parent.descendants.whereType<XmlElement>()) {
      if (element.name.local == localName) {
        return element;
      }
    }
    return null;
  }

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

    final entries = document.descendants
        .whereType<XmlElement>()
        .where((element) => element.name.local == 'entry');

    return entries.map((entry) {
      final id = findElement(entry, 'videoId')?.innerText;
      final title = findElement(entry, 'title')?.innerText;
      final published = findElement(entry, 'published')?.innerText;

      if (id == null || title == null || published == null) {
        throw Exception('Taarifa za video hazijakamilika');
      }

      final thumbnail = findElement(entry, 'thumbnail')
              ?.getAttribute('url') ??
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