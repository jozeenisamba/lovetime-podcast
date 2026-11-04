import 'package:flutter_test/flutter_test.dart';
import 'package:lovetime_podcast/youtube_service.dart';

void main() {
  test('YoutubeVideo provides an in-app embed URL for direct playback', () {
    const video = YoutubeVideo(
      id: 'dQw4w9WgXcQ',
      title: 'Demo video',
      thumbnail: 'https://example.com/thumb.jpg',
      published: '2026-01-01T00:00:00Z',
    );

    expect(video.embedUrl, contains('/embed/dQw4w9WgXcQ'));
    expect(video.embedUrl, contains('autoplay=1'));
    expect(video.embedUrl, contains('origin=https://lovetimepodcast.netlify.app'));
  });
}
