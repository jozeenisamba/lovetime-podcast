
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'youtube_service.dart';

void main() {
  runApp(const LoveTimeApp());
}

const Color backgroundColor = Color(0xFF0C0714);
const Color surfaceColor = Color(0xFF191225);
const Color cardColor = Color(0xFF21172F);
const Color rose = Color(0xFFF43F5E);
const Color cream = Color(0xFFF1F0F5);
const Color muted = Color(0xFFB8AFC2);
const Color purple = Color(0xFF342052);

Widget appBrandLogo({double size = 28}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(size / 2),
      boxShadow: [
        BoxShadow(
          color: rose.withValues(alpha: 0.25),
          blurRadius: 12,
          spreadRadius: 1,
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: Image.asset(
        'assets/logo.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    ),
  );
}

class LoveTimeApp extends StatelessWidget {
  const LoveTimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LoveTime Podcast',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: backgroundColor,
        fontFamily: 'Outfit',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontWeight: FontWeight.bold,
            letterSpacing: -0.6,
          ),
          displayMedium: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontWeight: FontWeight.bold,
            letterSpacing: -0.4,
          ),
          headlineLarge: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontWeight: FontWeight.bold,
            letterSpacing: -0.4,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w700,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w500,
            height: 1.6,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w500,
            height: 1.6,
          ),
        ).apply(
          bodyColor: cream,
          displayColor: cream,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: rose,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class TrendingAudioClip {
  final String title;
  final String platform;
  final String description;
  final String url;
  final String thumbnail;
  final Map<String, String> localizedTitles;
  final Map<String, String> localizedDescriptions;

  const TrendingAudioClip({
    required this.title,
    required this.platform,
    required this.description,
    required this.url,
    required this.thumbnail,
    this.localizedTitles = const {},
    this.localizedDescriptions = const {},
  });
}

class StoryArticle {
  final String title;
  final String source;
  final String summary;
  final String body;

  const StoryArticle({
    required this.title,
    required this.source,
    required this.summary,
    required this.body,
  });
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedTab = 0;
  String language = 'sw';
  final Set<String> favorites = {};
  final TextEditingController searchController = TextEditingController();
  final TextEditingController storyController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController contactNameController = TextEditingController();
  final TextEditingController contactEmailController = TextEditingController();
  final TextEditingController contactMessageController = TextEditingController();

  String storySubject = '';
  String contactType = '';
  bool anonymous = true;

  List<YoutubeVideo> youtubeVideos = [];
  bool loadingYoutube = true;
  String? youtubeError;

  static const String websitePodcastAudioUrl =
      'https://lovetimepodcast.netlify.app/audio/lovetime-zipo-tofauti.mp3';

  final List<Map<String, String>> websiteVideoEpisodes = const [
    {
      'id': 'jdSrocovjk4',
      'title': 'Alikaa Miezi Mitatu Bila Kuomba Chochote, Sababu Halisi Ni Hii',
      'category': 'Mahusiano',
    },
    {
      'id': 'klWyND-ZfvA',
      'title': 'Sababu za Maumivu na Harufu: Namna ya Kuongea na Mpenzi Wako',
      'category': 'Afya & Mapenzi',
    },
    {
      'id': 'hArGeP17qjw',
      'title': 'Wengi Hawajui Hii Sehemu Yenye Raha Ukitalii Mlima',
      'category': 'Mahaba & Ukaribu',
    },
  ];

  final List<String> tiktokVideoIds = const [
    '7619696402595155220',
    '7628675479721102612',
    '7700626793170062612',
    '7698325414611094802',
    '7702045512693861638',
    '7680320107557555464',
    '7606332298413427988',
    '7536532535208070456',
  ];

  final List<TrendingAudioClip> popularAudioClips = const [
    TrendingAudioClip(
      title: 'Mkasa wa Upendo wa kweli',
      platform: 'YouTube Shorts',
      description: 'Mwanamke anasema: "Ninahitaji upendo wa kweli, si maneno tu."',
      url: 'https://www.youtube.com/embed/CF4lV1H0P8M?autoplay=1&playsinline=1',
      thumbnail: 'https://img.youtube.com/vi/CF4lV1H0P8M/hqdefault.jpg',
      localizedTitles: {
        'en': 'A True Love Story',
        'fr': 'Une histoire de véritable amour',
      },
      localizedDescriptions: {
        'en': 'A woman says: "I need true love, not just words."',
        'fr': 'Une femme dit : « J’ai besoin du véritable amour, pas seulement de mots. »',
      },
    ),
    TrendingAudioClip(
      title: 'Maongezi ya ndoa na kukubaliana',
      platform: 'TikTok Trend',
      description: 'Kijana anasema: "Kama unataka ndoa, lazima kuwe na maelewano ya moyo."',
      url: 'https://www.tiktok.com/@lovetime_podcast',
      thumbnail: 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?auto=format&fit=crop&w=900&q=80',
      localizedTitles: {
        'en': 'Marriage Conversations and Agreement',
        'fr': 'Conversation et accord dans le mariage',
      },
      localizedDescriptions: {
        'en': 'A young person says: "If you want marriage, there must be agreement of the heart."',
        'fr': 'Un jeune dit : « Si tu veux te marier, il faut qu’il y ait un accord du cœur. »',
      },
    ),
    TrendingAudioClip(
      title: 'Ushauri wa kufaulu mahusiano',
      platform: 'YouTube',
      description: 'Mtu anasema: "Usikubali maumivu ya moyo yanakuteka bila kuzungumza."',
      url: 'https://www.youtube.com/embed/fJ9rUzIMcZQ?autoplay=1&playsinline=1',
      thumbnail: 'https://img.youtube.com/vi/fJ9rUzIMcZQ/hqdefault.jpg',
      localizedTitles: {
        'en': 'Advice for Successful Relationships',
        'fr': 'Conseils pour réussir sa relation',
      },
      localizedDescriptions: {
        'en': 'Someone says: "Do not let emotional pain consume you without speaking about it."',
        'fr': 'Quelqu’un dit : « Ne laissez pas la douleur émotionnelle vous envahir sans en parler. »',
      },
    ),
  ];

  final List<StoryArticle> popularStoryArticles = const [
    StoryArticle(
      title: 'Ninahitaji upendo wa kweli, si maneno tu',
      source: 'YouTube Shorts / TikTok trend',
      summary: 'Mwanamke alieleza jinsi watu wanaposema "nakupenda" lakini hawataki kuchukua hatua ya kukulinda, kukuheshimu na kukupa usalama wa moyo.',
      body: 'Katika video hiyo, mwanamke alitoa maelezo ya kihoji ya hisia zake. Alisema kwamba watu wengi wanaweza kusema "nakupenda" lakini bila kumjali, bila kukubeba kwa wakati mgumu, na bila kujenga ahadi za kweli. Alifafanua kwamba upendo wa kweli hupimwi kwa maneno tu, bali kwa vitendo vya kuthibitisha, kujenga imani na kuwepo kwa watu wenye nia nzuri. Hivyo, alihimiza vijana na wanandoa wasikubali kuishi katika hofu au msukumo wa upendo usio na msingi.\n\nKwa maana hiyo, kila mtu anapaswa kujua kwamba kupenda kunahitaji utulivu, ukarimu wa moyo, na nia ya kukaa pamoja kwa uaminifu. Aina hiyo ya upendo inajenga usalama, si tu msisimko wa muda. Pamoja na hivyo, watu wanaotaka kujenga mahusiano yenye afya ni lazima waongee kwa wazi, wakubaliane na kuhamasisha udadisi kwa vitendo vinavyotimiza ahadi.',
    ),
    StoryArticle(
      title: 'Ndoa haiwezi kukaa bila maelewano ya moyo',
      source: 'TikTok / short video',
      summary: 'Kijana alisisitiza kwamba ndoa inahitaji kuzungumza, kusikiliza na kukubali mapungufu ya mwenzi ili kuepuka makosa ya kujiziba kwenye hisia.',
      body: 'Katika video ya mtindo wa TikTok, kijana alitaka kuonyesha kwamba ndoa haiwezi kuimarika kwa kupaa kwa hisia za muda tu. Hali ya kihisia ni muhimu, lakini ufunguo wa kujenga ndoa yenye uaminifu ni maelewano. Watu wengi wanafeli kwa sababu wanakumbwa na hisia za hasira na kutokuelewana, lakini hawapati nafasi ya kukubali ukweli.\n\nAlisema kwamba watu wanahitaji kuzungumza kwa utulivu, kujadili changamoto bila kubagua, na kupenda kwa akili pamoja na moyo. Ukosefu wa maelewano husababisha chuki na kukataa kwa siri. Hivyo, kwenye mahusiano, kila mmoja anahitaji kukariri kwamba kusikia ni aina ya upendo, na kulenga kwenye suluhu si kurudi nyuma. Mahusiano mafupi ya mtazamo yanaweza kuwa na makosa, lakini kwa mazungumzo ya kweli, maisha yanaweza kupita kwenye sehemu salama.',
    ),
    StoryArticle(
      title: 'Usikubali maumivu ya moyo yakuteke bila kujadili',
      source: 'YouTube conversation',
      summary: 'Tofauti ya maumivu ya moyo na mimya ya kusikiliza ni kwamba watu wengi wanaishi kwa kujinyima, halafu wanajenga kizazi cha kufichua hisia kutoka ndani.',
      body: 'Katika video ya YouTube, mhadhiri alieleza kwamba watu wengi huishi kwa hali ya kukandamiza hisia zao kwa sababu ya hofu ya kuhukumiwa. Matokeo yake, maumivu ya moyo hujengwa ndani, lakini hayasuluhishwi. Alisema kwamba kikundi cha watu wanaoteseka kihisia hufanya kazi kwa kutojua jinsi ya kulalamika, na kwa hiyo hujifungia macho kwa furaha.\n\nKitu muhimu ni kwamba mahusiano na marafiki wanapaswa kuwa sehemu ya usalama wa kiakili. Wakati mtu anapohisi ubaguzi, ukosefu wa usikilizaji, au hofu ya hapana, ni vizuri kulizungumzia kwa mtu aliyeaminika. Kufanya hivyo ni hatua ya afya ya akili na kuanza kwa uponyaji wa moyo. Ndalama ya msingi ni kwamba usikubali huzuni ya ndani ikauke bila jibu.',
    ),
  ];

  final List<StoryArticle> dmStoryRequests = const [
    StoryArticle(
      title: 'Mke anataka kujua siku zote ni vipi niwe mume mzuri',
      source: 'DM / TikTok screenshot',
      summary: 'Mume aliomba ushauri kuhusu jinsi ya kujenga upendo zaidi kwa mke wake ambaye anatakiwa kilema cha kufika kwa ugumu.',
      body: 'Katika screenshot iliyotumwa kupitia DM, mume aliandika: "Ninafanya kila kitu kwa familia yangu lakini wife wangu anasema siyo kweli. Ninahitaji kujua ni vipi nipendewe zaidi?"\n\nKatika jibu lake, alielezwa kwamba upendo hujengwa kwa usikilizaji wa kweli, sio kwa matendo ya kupendeza kwa macho tu. Watoto na wanawake wengi wanahitaji kuona kwamba mume anawajibika, anamjaza moyo kwa makini, na anashauri kwa usawa. Kitu cha msingi ni kujenga mazingira ya usalama husika. Kulingana na taarifa, mwanamke anahitaji kuona kwamba mume anaelewa hisia, anashughulikia masuala ya nyumbani kwa makini, na hafanyi kuzungumza kwa kupendeza tu. \n\nHivyo, mume anapaswa kutunza kifundisho cha kuzungumza, kusikiliza bila kukasirisha, na kudumisha kiapo kwa familia kwa nguvu ya amani na utulivu.',
    ),
    StoryArticle(
      title: 'Kijana aliomba msaada baada ya kufungwa moyo',
      source: 'DM / YouTube screenshot',
      summary: 'Katika kuhaririwa kwa makala hii, kijana alisema kwamba alilazimishwa kutojiamini baada ya kuachwa na mpenzi, na alihitaji ushauri wa kujenga tena imani.',
      body: 'Katika ujumbe wa DM, kijana aliandika kwamba alishindwa kujiamini baada ya kukatazwa na mpenzi aliyekuwa akimsadikisha. Alisema ni vigumu kujitengeneza tena, kwani kila anapofikiri, hushangaa kuhusu makosa yake. Hivyo alihitaji msaada wa kiakili.\n\nJibu lilimaanisha kwamba watu wengi wanaohangaika ndani ya hisia wameweka kikwazo cha kujitenga na kujifungia ndani. Upole wa moyo unahitaji kubadilishwa na kuelewa kwamba kukubali furaha ni haki ya kila mtu. Kijana alihimizwa kuupenda mwenyewe kwanza, kufikiri kwa utulivu, na kuepuka kupendwa bila kukubaliana. Hasa, mtu anayefikia uponyaji huanza kwa kukubali ukweli, kufuata sehemu ya kujikumbusha kwamba amefanikiwa kwa njia zake.',
    ),
    StoryArticle(
      title: 'Wanafunzi wengi walituma screenshot wakimlilia shauri la mahusiano',
      source: 'DM / Tiktok comments',
      summary: 'Hilo lilikuwa na watu wengi waliotuma maelezo ya hisia zao baada ya marafiki kuchanganya hisia za mapenzi na uhasama.',
      body: 'Katika maelezo hayo, ijapokuwa yalikuwa makala ya video za kawaida, watu wengi walikubali kukaribisha maoni ya kibinadamu kuhusu marafiki waliofanya makosa ya kupenda bila kufahamu. Wanafunzi waliongea kwamba wazazi na marafiki wengi wanaweza kuleta pressure ambayo inafanya mtu kufika kwa ubaya wa ufikiri.\n\nIli kujenga afya ya hisia, watu wanaopenda kukaribisha ushauri ni lazima waelewe kwamba upendo na marafiki ni sehemu ya kujenga usalama. Mambo ya msingi ni kuzungumzia kwa uwazi, kupata nafasi ya kufichua hisia bila kuolewa na hofu, na kusahau mapenzi ya upendo unaokosa. Kila mtu anahitaji kukubaliwa kwa uaminifu, na hiyo ndiyo chanzo cha maendeleo ya moyo na maisha.',
    ),
  ];

  final Map<String, Map<String, String>> translations = {
    'sw': {
      'home': 'Mwanzo',
      'episodes': 'Vipindi',
      'youtube': 'YouTube',
      'story': 'Tuma Mkasa',
      'more': 'Zaidi',
      'welcome': 'Sauti ya Mahusiano, Upendo & Maisha ya Kweli.',
      'intro': 'Karibu kwenye LoveTime Podcast. Mahali salama panapojadili hisia, changamoto za ndoa, uponyaji wa moyo, urafiki na namna ya kujenga upendo thabiti.',
      'listen': 'Sikiliza Sasa',
      'sendStory': 'Tuma Mkasa Wako',
      'about': 'Kuhusu LoveTime Podcast',
      'aboutText': 'LoveTime Podcast ni chanzo cha kuzungumza kwa uwazi kuhusu upendo, mahusiano, ndoa, uponyaji wa moyo, marafiki, na maisha ya kweli. Tunatoa mazungumzo ya kina, simulizi halisi na ushauri unaojaa kwa watu wanaotaka kujenga uhusiano wenye afya, kujifunza na kujitambua.',
      'truth': 'Ukweli na Usiri',
      'truthText': 'Nafasi salama ya kusimulia bila kuhukumiwa.',
      'advice': 'Ushauri wa Kitaalamu',
      'adviceText': 'Mijadala na uchambuzi kutoka kwa watu wenye uzoefu na wataalamu.',
      'episodesTitle': 'Vipindi vya Hivi Karibuni',
      'episodesText': 'Tazama simulizi, mijadala na maoni ya kina kutoka LoveTime Podcast.',
      'services': 'Huduma Zetu',
      'consult': 'Kikao cha Ushauri',
      'consultText': 'Pata nafasi ya mazungumzo binafsi na mtaalamu wa mahusiano.',
      'partnership': 'Matangazo na Ushirikiano',
      'partnershipText': 'Tangaza biashara au brand yako kupitia LoveTime Podcast.',
      'events': 'Matukio ya Moja kwa Moja',
      'eventsText': 'Mijadala, maonesho na matukio ya wanandoa na vijana.',
      'storyTitle': 'Simulia Mkasa Wako',
      'storyText': 'Tuma swali au simulizi lako la mahusiano. Unaweza kuchagua kuficha utambulisho wako.',
      'nickname': 'Jina la utani (si lazima)',
      'subject': 'Mada ya mkasa',
      'yourStory': 'Andika mkasa au swali lako hapa...',
      'anonymous': 'Ficha utambulisho wangu',
      'send': 'Tuma Mkasa Wangu',
      'contact': 'Wasiliana Nasi',
      'contactText': 'Tungependa kusikia kutoka kwako. Kwa maoni, ushirikiano au kushiriki kwenye podcast, wasiliana nasi.',
      'name': 'Jina lako',
      'email': 'Barua pepe',
      'message': 'Ujumbe wako',
      'messageType': 'Aina ya ujumbe',
      'sendMessage': 'Tuma Ujumbe',
      'favorites': 'Vipindi Vilivyopendwa',
      'noFavorites': 'Bado hujaongeza video kwenye vipendwa.',
      'language': 'Chagua lugha',
      'refresh': 'Sasisha video',
      'noVideos': 'Hakuna video zilizopatikana kwa sasa.',
      'retry': 'Jaribu tena',
      'all': 'Vyote',
      'search': 'Tafuta video...',
      'platforms': 'Tupate kwenye majukwaa',
      'location': 'Dar es Salaam, Tanzania',
      'popularAudioTitle': 'Sauti za video zinazopendwa',
      'popularAudioSubtitle': 'TikTok na YouTube zinazotoka kwenye mitindo ya watu wanaozungumza kuhusu upendo, ndoa na maisha.',
      'listenAll': 'Sikiliza zote',
      'allAudioClips': 'Vipande vyote vya sauti',
      'readArticlesTitle': 'Makala ya kusoma',
      'readArticlesSubtitle': 'Video za TikTok na YouTube zimeandikwa kwenye makala fupi za watu wanaopenda kusoma.',
      'dmStoriesTitle': 'Mikasa kutoka DM',
      'dmStoriesSubtitle': 'Video za watu waliotuma screenshots wakitaka ushauri zimeandikwa kama hadithi za kusoma.',
      'articleReader': 'Makala ya kusoma',
      'youtubeHeader': 'LoveTime on YouTube',
      'youtubeSubtitle': 'Video mpya kutoka kwenye channel yetu.',
      'youtubeSectionTitle': 'Video za hivi karibuni',
      'openYoutubeChannel': 'Fungua YouTube Channel',
      'youtubeChannelName': 'LOVETIME PODCAST',
      'youtubeLoadError': 'Imeshindikana kupata video. Hakikisha una intaneti.',
      'contactTitle': 'Wasiliana nasi',
      'podcastBrand': 'LoveTime Podcast',
      'brandTagline': 'Sauti ya mahusiano, upendo na maisha ya kweli.',
      'readMore': 'Soma zaidi',
      'allAudioClipsScreenTitle': 'Vipande vyote vya sauti',
      'brandBadge': 'PODCAST YA MAHUSIANO',
      'storySubjectCheating': 'Usaliti & Shaka',
      'storySubjectMarriage': 'Changamoto ya Ndoa',
      'storySubjectNewRelationship': 'Kuanzisha Mahusiano mapya',
      'storySubjectFamily': 'Changamoto na Wakwe / Familia',
      'storySubjectOther': 'Mengineyo',
      'contactTypeGuest': 'Podcast Guest',
      'contactTypeSponsorship': 'Sponsorship',
      'contactTypeCounselling': 'Counselling Session',
      'contactTypeGeneral': 'General Comment',
      'storyNotice': 'Ujumbe utaandaliwa kwenye WhatsApp yako ili uutume. Hauhifadhiwi moja kwa moja kwenye server ya LoveTime.',
      'linkOpenFailed': 'Imeshindikana kufungua kiungo.',
      'storyRequired': 'Tafadhali andika mkasa au swali lako kwanza.',
      'contactRequired': 'Tafadhali andika ujumbe wako.',
      'anonymousName': 'Siri / Anonymous',
      'videoRecent': 'Video za hivi karibuni',
      'copyright': 'LoveTime Podcast ©',
      'creator': 'Mtengenezaji wa App',
      'mainHost': 'Mwenyeji Mkuu wa LoveTime Podcast',
    },
    'en': {
      'home': 'Home',
      'episodes': 'Episodes',
      'youtube': 'YouTube',
      'story': 'Submit Story',
      'more': 'More',
      'welcome': 'The Voice of Relationships, Love & Real Life.',
      'intro': 'Welcome to LoveTime Podcast, a safe space for conversations about emotions, marriage challenges, healing, friendship and building lasting love.',
      'listen': 'Listen Now',
      'sendStory': 'Submit Your Story',
      'about': 'About LoveTime Podcast',
      'aboutText': 'LoveTime Podcast is a space for honest conversations about love, relationships, marriage, healing, friendship and real-life experiences. We create meaningful discussions, personal stories and practical guidance for people who want healthier relationships, deeper understanding and emotional growth.',
      'truth': 'Honesty and Privacy',
      'truthText': 'A safe space to share without judgment.',
      'advice': 'Professional Guidance',
      'adviceText': 'Discussions and insights from experienced people and specialists.',
      'episodesTitle': 'Recent Episodes',
      'episodesText': 'Watch stories, debates and conversations from LoveTime Podcast.',
      'services': 'Our Services',
      'consult': 'Private Consultation',
      'consultText': 'Arrange a private conversation with a relationship specialist.',
      'partnership': 'Advertising & Partnerships',
      'partnershipText': 'Promote your business or brand through LoveTime Podcast.',
      'events': 'Live Events',
      'eventsText': 'Discussions, shows and events for couples and young people.',
      'storyTitle': 'Share Your Story',
      'storyText': 'Send your relationship story or question. You can choose to hide your identity.',
      'nickname': 'Nickname (optional)',
      'subject': 'Story subject',
      'yourStory': 'Write your story or question here...',
      'anonymous': 'Hide my identity',
      'send': 'Submit My Story',
      'contact': 'Contact Us',
      'contactText': 'We would love to hear from you. Contact us for feedback, partnerships or podcast appearances.',
      'name': 'Your name',
      'email': 'Email address',
      'message': 'Your message',
      'messageType': 'Message type',
      'sendMessage': 'Send Message',
      'favorites': 'Favorite Videos',
      'noFavorites': 'You have not added any favorite videos yet.',
      'language': 'Choose language',
      'refresh': 'Refresh videos',
      'noVideos': 'No videos available right now.',
      'retry': 'Try again',
      'all': 'All',
      'search': 'Search videos...',
      'platforms': 'Find us on platforms',
      'location': 'Dar es Salaam, Tanzania',
      'popularAudioTitle': 'Popular audio clips',
      'popularAudioSubtitle': 'TikTok and YouTube clips where people talk openly about love, marriage and life.',
      'listenAll': 'Listen all',
      'allAudioClips': 'All audio clips',
      'readArticlesTitle': 'Reading articles',
      'readArticlesSubtitle': 'TikTok and YouTube videos turned into short readable stories for people who love to read.',
      'dmStoriesTitle': 'DM stories',
      'dmStoriesSubtitle': 'Videos and screenshots from people asking for advice, now turned into readable stories.',
      'articleReader': 'Reading article',
      'youtubeHeader': 'LoveTime on YouTube',
      'youtubeSubtitle': 'Fresh videos from our channel.',
      'youtubeSectionTitle': 'Latest videos',
      'openYoutubeChannel': 'Open YouTube Channel',
      'youtubeChannelName': 'LOVETIME PODCAST',
      'youtubeLoadError': 'We could not load the videos. Please check your internet connection.',
      'contactTitle': 'Contact us',
      'podcastBrand': 'LoveTime Podcast',
      'brandTagline': 'The voice of relationships, love and real life.',
      'readMore': 'Read more',
      'allAudioClipsScreenTitle': 'All audio clips',
      'brandBadge': 'RELATIONSHIP PODCAST',
      'storySubjectCheating': 'Betrayal & Drama',
      'storySubjectMarriage': 'Marriage Challenges',
      'storySubjectNewRelationship': 'Starting a New Relationship',
      'storySubjectFamily': 'Family & Partnership Challenges',
      'storySubjectOther': 'Other',
      'contactTypeGuest': 'Podcast Guest',
      'contactTypeSponsorship': 'Sponsorship',
      'contactTypeCounselling': 'Counselling Session',
      'contactTypeGeneral': 'General Comment',
      'storyNotice': 'Your message will be prepared in WhatsApp for sending. It is not stored directly on the LoveTime server.',
      'linkOpenFailed': 'Could not open link.',
      'storyRequired': 'Please write your story or question first.',
      'contactRequired': 'Please write your message.',
      'anonymousName': 'Anonymous',
      'videoRecent': 'Recent videos',
      'copyright': 'LoveTime Podcast ©',
      'creator': 'App Developer',
      'mainHost': 'Main Host of LoveTime Podcast',
    },
    'fr': {
      'home': 'Accueil',
      'episodes': 'Épisodes',
      'youtube': 'YouTube',
      'story': 'Votre histoire',
      'more': 'Plus',
      'welcome': 'La voix des relations, de l’amour et de la vraie vie.',
      'intro': 'Bienvenue sur LoveTime Podcast, un espace sûr pour parler des émotions, du mariage, de la guérison du cœur, de l’amitié et de l’amour durable.',
      'listen': 'Écouter',
      'sendStory': 'Envoyer votre histoire',
      'about': 'À propos de LoveTime Podcast',
      'aboutText': 'LoveTime Podcast est un espace de conversation ouverte sur l’amour, les relations, le mariage, la guérison émotionnelle, l’amitié et les expériences de la vie réelle. Nous partageons des discussions profondes, des histoires authentiques et des conseils utiles pour ceux qui souhaitent construire des relations plus saines, comprendre davantage et grandir émotionnellement.',
      'truth': 'Vérité et confidentialité',
      'truthText': 'Un espace sûr pour partager sans jugement.',
      'advice': 'Conseils professionnels',
      'adviceText': 'Des échanges et analyses avec des personnes expérimentées et des spécialistes.',
      'episodesTitle': 'Épisodes récents',
      'episodesText': 'Découvrez les histoires et débats de LoveTime Podcast.',
      'services': 'Nos services',
      'consult': 'Consultation privée',
      'consultText': 'Organisez un échange privé avec un spécialiste des relations.',
      'partnership': 'Publicité et partenariats',
      'partnershipText': 'Faites connaître votre entreprise ou votre marque.',
      'events': 'Événements en direct',
      'eventsText': 'Rencontres et événements pour les couples et les jeunes.',
      'storyTitle': 'Racontez votre histoire',
      'storyText': 'Envoyez votre histoire ou question. Vous pouvez choisir de cacher votre identité.',
      'nickname': 'Surnom (facultatif)',
      'subject': 'Sujet',
      'yourStory': 'Écrivez votre histoire ou question...',
      'anonymous': 'Cacher mon identité',
      'send': 'Envoyer mon histoire',
      'contact': 'Contactez-nous',
      'contactText': 'Contactez-nous pour vos commentaires, partenariats ou participations au podcast.',
      'name': 'Votre nom',
      'email': 'Adresse e-mail',
      'message': 'Votre message',
      'messageType': 'Type de message',
      'sendMessage': 'Envoyer',
      'favorites': 'Vidéos favorites',
      'noFavorites': 'Vous n’avez pas encore de vidéos favorites.',
      'language': 'Choisir la langue',
      'refresh': 'Actualiser les vidéos',
      'noVideos': 'Aucune vidéo disponible pour le moment.',
      'retry': 'Réessayer',
      'all': 'Tout',
      'search': 'Rechercher des vidéos...',
      'platforms': 'Retrouvez-nous',
      'location': 'Dar es Salaam, Tanzanie',
      'popularAudioTitle': 'Sons et vidéos populaires',
      'popularAudioSubtitle': 'Des clips TikTok et YouTube où les gens parlent ouvertement d’amour, de mariage et de vie.',
      'listenAll': 'Tout écouter',
      'allAudioClips': 'Tous les clips audio',
      'readArticlesTitle': 'Articles à lire',
      'readArticlesSubtitle': 'Des vidéos TikTok et YouTube transformées en histoires courtes pour les lecteurs.',
      'dmStoriesTitle': 'Histoires DM',
      'dmStoriesSubtitle': 'Des vidéos et captures d’écran de personnes demandant des conseils, maintenant transformées en histoires lisibles.',
      'articleReader': 'Article à lire',
      'youtubeHeader': 'LoveTime sur YouTube',
      'youtubeSubtitle': 'Nouvelles vidéos depuis notre chaîne.',
      'youtubeSectionTitle': 'Vidéos récentes',
      'openYoutubeChannel': 'Ouvrir la chaîne YouTube',
      'youtubeChannelName': 'LOVETIME PODCAST',
      'youtubeLoadError': 'Nous n’avons pas pu charger les vidéos. Vérifiez votre connexion internet.',
      'contactTitle': 'Contactez-nous',
      'podcastBrand': 'LoveTime Podcast',
      'brandTagline': 'La voix des relations, de l’amour et de la vraie vie.',
      'readMore': 'Lire la suite',
      'allAudioClipsScreenTitle': 'Tous les clips audio',
      'brandBadge': 'PODCAST DES RELATIONS',
      'storySubjectCheating': 'Trahison & Drame',
      'storySubjectMarriage': 'Défis du mariage',
      'storySubjectNewRelationship': 'Commencer une nouvelle relation',
      'storySubjectFamily': 'Défis familiaux & de couple',
      'storySubjectOther': 'Autre',
      'contactTypeGuest': 'Invité du podcast',
      'contactTypeSponsorship': 'Partenariat',
      'contactTypeCounselling': 'Consultation',
      'contactTypeGeneral': 'Commentaire général',
      'storyNotice': 'Votre message sera préparé dans WhatsApp pour être envoyé. Il n’est pas stocké directement sur le serveur LoveTime.',
      'linkOpenFailed': 'Impossible d’ouvrir le lien.',
      'storyRequired': 'Veuillez d’abord écrire votre histoire ou votre question.',
      'contactRequired': 'Veuillez écrire votre message.',
      'anonymousName': 'Anonyme',
      'videoRecent': 'Vidéos récentes',
      'copyright': 'LoveTime Podcast ©',
      'creator': 'Développeur de l’application',
      'mainHost': 'Présentateur principal de LoveTime Podcast',
    },
  };

  String tr(String key) => translations[language]?[key] ?? key;

  @override
  void initState() {
    super.initState();
    storySubject = tr('storySubjectMarriage');
    contactType = tr('contactTypeGuest');
    loadYoutubeVideos();
  }

  @override
  void dispose() {
    searchController.dispose();
    storyController.dispose();
    nicknameController.dispose();
    contactNameController.dispose();
    contactEmailController.dispose();
    contactMessageController.dispose();
    super.dispose();
  }

  Future<void> loadYoutubeVideos() async {
    if (mounted) {
      setState(() {
        loadingYoutube = true;
        youtubeError = null;
      });
    }
    try {
      final videos = await YoutubeService.fetchVideos();
      if (!mounted) return;
      setState(() {
        youtubeVideos = videos;
        loadingYoutube = false;
        youtubeError = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loadingYoutube = false;
        youtubeError = e.toString();
      });
    }
  }

  Future<void> openLink(String url) async {
    final opened = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr('linkOpenFailed'))),
      );
    }
  }

  void openInAppMedia(
    String title,
    String url, {
    String? narration,
    Map<String, String>? narrationTranslations,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MediaPlayerScreen(
          title: title,
          url: url,
          narration: narration,
          narrationTranslations: narrationTranslations,
          initialLanguage: language,
        ),
      ),
    );
  }

  String localizedAudioTitle(TrendingAudioClip audio) {
    return audio.localizedTitles[language] ?? audio.title;
  }

  String localizedAudioDescription(TrendingAudioClip audio) {
    return audio.localizedDescriptions[language] ?? audio.description;
  }

  Map<String, String> youtubeNarrationTranslations(YoutubeVideo video) {
    final description = video.description.trim();
    if (description.isNotEmpty) {
      return {
        'sw': '$description\n\nVideo: ${video.title}.',
        'en': '${video.title}. $description',
        'fr': '${video.title}. $description',
      };
    }
    return {
      'sw': 'Sikiliza ${video.title}, mazungumzo ya LoveTime Podcast kuhusu mahusiano, upendo na maisha ya kweli.',
      'en': 'Listen to ${video.title}, a LoveTime Podcast conversation about relationships, love and real life.',
      'fr': 'Découvrez ${video.title}, une conversation LoveTime Podcast sur les relations, l’amour et la vie réelle.',
    };
  }

  String youtubeNarration(YoutubeVideo video) {
    final description = video.description.trim();
    if (description.isNotEmpty) {
      return '$description\n\nVideo: ${video.title}.';
    }
    switch (language) {
      case 'en':
        return 'Watch ${video.title}, a LoveTime Podcast conversation about relationships, love and real life.';
      case 'fr':
        return 'Découvrez ${video.title}, une conversation LoveTime Podcast sur les relations, l’amour et la vie réelle.';
      default:
        return 'Sikiliza ${video.title}, mazungumzo ya LoveTime Podcast kuhusu mahusiano, upendo na maisha ya kweli.';
    }
  }

  StoryArticle youtubeArticle(YoutubeVideo video) {
    final source = language == 'fr'
        ? 'Vidéo YouTube / LoveTime Podcast'
        : language == 'en'
            ? 'YouTube video / LoveTime Podcast'
            : 'Video ya YouTube / LoveTime Podcast';
    final summary = youtubeNarration(video);
    final body = language == 'fr'
        ? '${video.title}\n\n$summary\n\nCette vidéo est disponible directement dans LoveTime Podcast. Vous pouvez utiliser les commandes de narration pour écouter son résumé en Français.'
        : language == 'en'
            ? '${video.title}\n\n$summary\n\nThis video is available directly inside LoveTime Podcast. You can use the narration controls to listen to its summary in English.'
            : '${video.title}\n\n$summary\n\nVideo hii inapatikana moja kwa moja ndani ya LoveTime Podcast. Tumia sauti ya dubbing kusikiliza muhtasari wake kwa Kiswahili, Kiingereza au Kifaransa.';
    return StoryArticle(title: video.title, source: source, summary: summary, body: body);
  }

  Widget youtubeArticlesSection() {
    final recentVideos = youtubeVideos.take(6).toList();
    if (recentVideos.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle(
          language == 'fr'
              ? 'Articles automatiques'
              : language == 'en'
                  ? 'Automatic articles'
                  : 'Makala za kiotomatiki',
          subtitle: language == 'fr'
              ? 'Chaque nouvelle vidéo YouTube génère une fiche lisible et audible.'
              : language == 'en'
                  ? 'Every new YouTube video creates a readable and audible article.'
                  : 'Kila video mpya ya YouTube hutengeneza makala ya kusoma na kusikiliza.',
        ),
        ...recentVideos.map((video) {
          final article = youtubeArticle(video);
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
            ),
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => StoryArticleScreen(article: article)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(article.source, style: const TextStyle(color: rose, fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(article.title, style: const TextStyle(color: cream, fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text(article.summary, maxLines: 4, overflow: TextOverflow.ellipsis, style: const TextStyle(color: muted, height: 1.55, fontSize: 13)),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  void openAllAudioClips() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AudioPlaylistScreen(
          clips: popularAudioClips,
          title: tr('allAudioClipsScreenTitle'),
          language: language,
        ),
      ),
    );
  }

  Future<void> sendStory() async {
    if (storyController.text.trim().isEmpty) {
      showMessage(tr('storyRequired'));
      return;
    }
    final name = anonymous ? tr('anonymousName') : nicknameController.text.trim();
    final message = '''
LOVE TIME PODCAST - MKASA MPYA

Jina: ${name.isEmpty ? tr('anonymousName') : name}
Mada: $storySubject

Mkasa:
${storyController.text.trim()}
''';
    final uri = Uri.https('wa.me', '/255652818853', {'text': message});
    await openLink(uri.toString());
  }

  Future<void> sendContact() async {
    if (contactMessageController.text.trim().isEmpty) {
      showMessage(tr('contactRequired'));
      return;
    }
    final message = '''
LOVE TIME PODCAST - MAWASILIANO

Jina: ${contactNameController.text.trim()}
Email: ${contactEmailController.text.trim()}
Aina: $contactType

Ujumbe:
${contactMessageController.text.trim()}
''';
    final uri = Uri.https('wa.me', '/255652818853', {'text': message});
    await openLink(uri.toString());
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void changeLanguage(String? value) {
    if (value == null) return;

    setState(() {
      language = value;
      storySubject = tr('storySubjectMarriage');
      contactType = tr('contactTypeGuest');
    });
  }

  void selectTab(int index) {
    setState(() => selectedTab = index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      homePage(),
      episodesPage(),
      youtubePage(),
      storyPage(),
      morePage(),
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF120A1C),
              Color(0xFF0C0714),
              Color(0xFF130D1D),
            ],
          ),
        ),
        child: SafeArea(
          child: IndexedStack(
            index: selectedTab,
            children: pages,
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: 68,
        backgroundColor: surfaceColor.withValues(alpha: 0.95),
        elevation: 14,
        indicatorColor: rose.withValues(alpha: 0.18),
        shadowColor: rose.withValues(alpha: 0.12),
        selectedIndex: selectedTab,
        onDestinationSelected: selectTab,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home, color: rose),
            label: tr('home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.play_circle_outline),
            selectedIcon: const Icon(Icons.play_circle, color: rose),
            label: tr('episodes'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.smart_display_outlined),
            selectedIcon: const Icon(Icons.smart_display, color: rose),
            label: tr('youtube'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.mail_outline),
            selectedIcon: const Icon(Icons.mail, color: rose),
            label: tr('story'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu),
            selectedIcon: const Icon(Icons.menu, color: rose),
            label: tr('more'),
          ),
        ],
      ),
    );
  }

  Widget heading(String title, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'PlayfairDisplay',
            color: cream,
            fontSize: 27,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 7),
          Text(subtitle, style: const TextStyle(color: muted, height: 1.5)),
        ],
      ],
    );
  }

  Widget sectionTitle(String title, {String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: heading(title, subtitle: subtitle),
    );
  }

  Widget homePage() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
      children: [
        Row(
          children: [
            appBrandLogo(size: 34),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'LoveTime Podcast',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            languageSelector(),
          ],
        ),
        const SizedBox(height: 25),
        Container(
          padding: const EdgeInsets.all(23),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              colors: [Color(0xFF342052), Color(0xFF170D24), Color(0xFF281226)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: rose.withValues(alpha: 0.22)),
            boxShadow: [
              BoxShadow(
                color: rose.withValues(alpha: 0.08),
                spreadRadius: 1,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: rose.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  tr('brandBadge'),
                  style: const TextStyle(
                    color: rose,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                tr('welcome'),
                style: const TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 30,
                  height: 1.25,
                  fontWeight: FontWeight.bold,
                  color: cream,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                tr('intro'),
                style: const TextStyle(color: muted, height: 1.65, fontSize: 14),
              ),
              const SizedBox(height: 22),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  FilledButton.icon(
                    onPressed: () => selectTab(2),
                    icon: const Icon(Icons.play_arrow),
                    label: Text(tr('listen')),
                    style: FilledButton.styleFrom(
                      backgroundColor: rose,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => selectTab(3),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: cream,
                      side: const BorderSide(color: rose),
                    ),
                    child: Text(tr('sendStory')),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        sectionTitle(tr('about')),
        Text(
          tr('aboutText'),
          style: const TextStyle(color: muted, height: 1.7),
        ),
        const SizedBox(height: 18),
        infoCard(Icons.lock_outline, tr('truth'), tr('truthText')),
        infoCard(Icons.psychology_outlined, tr('advice'), tr('adviceText')),
        const SizedBox(height: 30),
        sectionTitle(tr('episodesTitle'), subtitle: tr('episodesText')),
        if (loadingYoutube)
          const Center(child: CircularProgressIndicator(color: rose))
        else if (youtubeVideos.isEmpty)
          Text(tr('noVideos'), style: const TextStyle(color: muted))
        else
          ...youtubeVideos.take(3).map(videoCard),
        TextButton(
          onPressed: () => selectTab(2),
          child: Text(tr('listen')),
        ),
        const SizedBox(height: 25),
        websitePodcastAudioSection(),
        const SizedBox(height: 25),
        audioHighlightsSection(),
        const SizedBox(height: 25),
        youtubeArticlesSection(),
        const SizedBox(height: 25),
        storyArticlesSection(),
        const SizedBox(height: 25),
        sectionTitle(tr('services')),
        infoCard(Icons.people_outline, tr('consult'), tr('consultText')),
        infoCard(Icons.campaign_outlined, tr('partnership'), tr('partnershipText')),
        infoCard(Icons.event_outlined, tr('events'), tr('eventsText')),
        const SizedBox(height: 25),
        platformSection(),
        const SizedBox(height: 25),
        contactSummary(),
      ],
    );
  }

  Widget infoCard(IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: rose, size: 27),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(
                  color: cream, fontWeight: FontWeight.bold, fontSize: 16,
                )),
                const SizedBox(height: 6),
                Text(description, style: const TextStyle(
                  color: muted, height: 1.5, fontSize: 13,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget episodesPage() {
    final query = searchController.text.toLowerCase();
    final filtered = youtubeVideos.where(
      (video) => video.title.toLowerCase().contains(query),
    ).toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        heading(tr('episodesTitle'), subtitle: tr('episodesText')),
        const SizedBox(height: 20),
        audioHighlightsSection(),
        const SizedBox(height: 18),
        TextField(
          controller: searchController,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: tr('search'),
            prefixIcon: const Icon(Icons.search, color: rose),
            filled: true,
            fillColor: surfaceColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 18),
        if (loadingYoutube)
          const Center(child: CircularProgressIndicator(color: rose))
        else if (filtered.isEmpty)
          Text(tr('noVideos'), style: const TextStyle(color: muted))
        else
          ...filtered.map(videoCard),
      ],
    );
  }

  Widget youtubePage() {
    return RefreshIndicator(
      color: rose,
      onRefresh: loadYoutubeVideos,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          heading(tr('youtubeHeader'),
              subtitle: tr('youtubeSubtitle')),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                const Icon(Icons.play_circle_fill, color: rose, size: 60),
                const SizedBox(height: 12),
                Text(
                  tr('youtubeChannelName'),
                  style: const TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => openInAppMedia(
                    'LoveTime YouTube',
                    'https://www.youtube.com/@LOVETIMEPODCAST',
                  ),
                  icon: const Icon(Icons.open_in_new),
                  label: Text(tr('openYoutubeChannel')),
                  style: FilledButton.styleFrom(backgroundColor: rose),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: Text(
                  tr('videoRecent'),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: loadYoutubeVideos,
                icon: const Icon(Icons.refresh, color: rose),
              ),
            ],
          ),
          if (loadingYoutube)
            const Padding(
              padding: EdgeInsets.all(30),
              child: Center(child: CircularProgressIndicator(color: rose)),
            )
          else if (youtubeError != null)
            Column(
              children: [
                Text(
                  tr('youtubeLoadError'),
                  style: const TextStyle(color: muted),
                ),
                TextButton(
                  onPressed: loadYoutubeVideos,
                  child: Text(tr('retry')),
                ),
              ],
            )
          else if (youtubeVideos.isEmpty)
            Text(tr('noVideos'), style: const TextStyle(color: muted))
          else
            ...youtubeVideos.map(videoCard),
          const SizedBox(height: 28),
          websiteVideoEpisodesSection(),
          const SizedBox(height: 28),
          tiktokVideosSection(),
        ],
      ),
    );
  }

  Widget websitePodcastAudioSection() {
    final title = language == 'fr'
        ? 'Audio podcast du site'
        : language == 'en'
            ? 'Website podcast audio'
            : 'Audio ya podcast kutoka website';
    final subtitle = language == 'fr'
        ? 'Écoutez le podcast Love Time directement dans l’application.'
        : language == 'en'
            ? 'Listen to the Love Time Podcast directly inside the app.'
            : 'Sikiliza Love Time Podcast moja kwa moja ndani ya app.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle(title, subtitle: subtitle),
        Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: rose.withValues(alpha: 0.12)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(14),
            leading: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: rose.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.graphic_eq, color: rose, size: 30),
            ),
            title: const Text('Love Time - Zipo Tofauti', style: TextStyle(color: cream, fontWeight: FontWeight.w700)),
            subtitle: const Text('Love Time Podcast Show • 01:41', style: TextStyle(color: muted)),
            trailing: const Icon(Icons.play_circle_fill, color: rose, size: 38),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => WebsiteAudioPlayerScreen(
                  title: 'Love Time - Zipo Tofauti',
                  url: websitePodcastAudioUrl,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget websiteVideoEpisodesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle(
          language == 'fr'
              ? 'Vidéo podcast du site'
              : language == 'en'
                  ? 'Website podcast videos'
                  : 'Video za podcast kutoka website',
          subtitle: language == 'fr'
              ? 'Les épisodes vidéo publiés sur LoveTime Podcast.'
              : language == 'en'
                  ? 'The video episodes published on LoveTime Podcast.'
                  : 'Vipindi vya video vilivyo kwenye LoveTime Podcast.',
        ),
        ...websiteVideoEpisodes.map((episode) {
          final videoId = episode['id']!;
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'https://i.ytimg.com/vi/$videoId/hqdefault.jpg',
                  width: 86,
                  height: 58,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(episode['title']!, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: cream, fontSize: 14, fontWeight: FontWeight.w700)),
              subtitle: Text(episode['category']!, style: const TextStyle(color: rose, fontSize: 11)),
              trailing: const Icon(Icons.play_circle_fill, color: rose),
              onTap: () => openInAppMedia(
                episode['title']!,
                'https://www.youtube.com/embed/$videoId?autoplay=1&playsinline=1&enablejsapi=1&origin=https://lovetimepodcast.netlify.app&widget_referrer=https://lovetimepodcast.netlify.app',
                narration: episode['title'],
                narrationTranslations: {
                  'sw': episode['title']!,
                  'en': episode['title']!,
                  'fr': episode['title']!,
                },
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget tiktokVideosSection() {
    final headingTitle = language == 'fr'
        ? 'TikTok récents'
        : language == 'en'
            ? 'Recent TikTok videos'
            : 'Video za TikTok za hivi karibuni';
    final headingSubtitle = language == 'fr'
        ? 'Les 8 dernières vidéos fournies de LoveTime Podcast.'
        : language == 'en'
            ? 'The 8 supplied videos from LoveTime Podcast.'
            : 'Video 8 zilizotolewa kutoka LoveTime Podcast.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle(headingTitle, subtitle: headingSubtitle),
        ...tiktokVideoIds.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final videoId = entry.value;
          final title = language == 'fr'
              ? 'LoveTime Podcast • TikTok $index'
              : language == 'en'
                  ? 'LoveTime Podcast • TikTok $index'
                  : 'LoveTime Podcast • TikTok $index';
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: rose.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.music_note, color: rose, size: 28),
              ),
              title: Text(title, style: const TextStyle(color: cream, fontWeight: FontWeight.w700)),
              subtitle: Text(videoId, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: muted, fontSize: 11)),
              trailing: const Icon(Icons.play_circle_fill, color: rose, size: 34),
              onTap: () => openInAppMedia(
                title,
                'https://www.tiktok.com/player/v1/$videoId?autoplay=1&controls=1',
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget audioHighlightsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: sectionTitle(tr('popularAudioTitle'),
                  subtitle: tr('popularAudioSubtitle')),
            ),
            TextButton.icon(
              onPressed: openAllAudioClips,
              icon: const Icon(Icons.play_circle_fill, size: 18, color: rose),
              label: Text(tr('listenAll'), style: const TextStyle(color: rose)),
            ),
          ],
        ),
        ...popularAudioClips.map((audio) {
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
            ),
            child: InkWell(
              onTap: () => openInAppMedia(
                localizedAudioTitle(audio),
                audio.url,
                narration: localizedAudioDescription(audio),
                narrationTranslations: {
                  'sw': audio.description,
                  ...audio.localizedDescriptions,
                },
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(18),
                    ),
                    child: SizedBox(
                      width: 110,
                      height: 110,
                      child: Image.network(
                        audio.thumbnail,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: purple,
                          child: const Icon(
                            Icons.play_circle_fill,
                            color: cream,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            audio.platform,
                            style: const TextStyle(
                              color: rose,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            localizedAudioTitle(audio),
                            style: const TextStyle(
                              color: cream,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            localizedAudioDescription(audio),
                            style: const TextStyle(
                              color: muted,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget storyArticlesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle(tr('readArticlesTitle'),
            subtitle: tr('readArticlesSubtitle')),
        ...popularStoryArticles.map((article) {
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
            ),
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => StoryArticleScreen(article: article),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.source,
                      style: const TextStyle(
                        color: rose,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.title,
                      style: const TextStyle(
                        color: cream,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.summary,
                      style: const TextStyle(
                        color: muted,
                        height: 1.55,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget communityStoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle(tr('dmStoriesTitle'),
            subtitle: tr('dmStoriesSubtitle')),
        ...dmStoryRequests.map((story) {
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
            ),
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => StoryArticleScreen(article: story),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.source,
                    style: const TextStyle(
                      color: rose,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    story.title,
                    style: const TextStyle(
                      color: cream,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    story.summary,
                    style: const TextStyle(
                      color: muted,
                      height: 1.55,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget videoCard(YoutubeVideo video) {
    final isFavorite = favorites.contains(video.id);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => openInAppMedia(
              video.title,
              video.embedUrl,
              narration: youtubeNarration(video),
              narrationTranslations: youtubeNarrationTranslations(video),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    video.thumbnail,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: purple,
                      child: const Icon(
                        Icons.play_circle_fill,
                        color: cream,
                        size: 60,
                      ),
                    ),
                  ),
                  const Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                      size: 55,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 13, 8, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => openInAppMedia(
                      video.title,
                      video.embedUrl,
                      narration: youtubeNarration(video),
                      narrationTranslations: youtubeNarrationTranslations(video),
                    ),
                    child: Text(
                      video.title,
                      style: const TextStyle(
                        color: cream,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (isFavorite) {
                        favorites.remove(video.id);
                      } else {
                        favorites.add(video.id);
                      }
                    });
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: rose,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Text(
              'LoveTime Podcast',
              style: TextStyle(color: muted, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget storyPage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        heading(tr('storyTitle'), subtitle: tr('storyText')),
        const SizedBox(height: 20),
        storyArticlesSection(),
        const SizedBox(height: 22),
        communityStoriesSection(),
        const SizedBox(height: 22),
        TextField(
          controller: nicknameController,
          decoration: fieldDecoration(tr('nickname')),
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          initialValue: storySubject,
          decoration: fieldDecoration(tr('subject')),
          dropdownColor: surfaceColor,
          items: [
            tr('storySubjectCheating'),
            tr('storySubjectMarriage'),
            tr('storySubjectNewRelationship'),
            tr('storySubjectFamily'),
            tr('storySubjectOther'),
          ].map((item) => DropdownMenuItem(
            value: item,
            child: Text(item),
          )).toList(),
          onChanged: (value) {
            if (value != null) setState(() => storySubject = value);
          },
        ),
        const SizedBox(height: 14),
        TextField(
          controller: storyController,
          minLines: 6,
          maxLines: 10,
          decoration: fieldDecoration(tr('yourStory')),
        ),
        const SizedBox(height: 10),
        CheckboxListTile(
          value: anonymous,
          onChanged: (value) => setState(() => anonymous = value ?? true),
          title: Text(tr('anonymous')),
          activeColor: rose,
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: sendStory,
          icon: const Icon(Icons.send),
          label: Text(tr('send')),
          style: FilledButton.styleFrom(
            backgroundColor: rose,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          tr('storyNotice'),
          style: const TextStyle(color: muted, fontSize: 12, height: 1.5),
        ),
      ],
    );
  }

  InputDecoration fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: rose),
      ),
    );
  }

  Widget morePage() {
    final favoriteVideos = youtubeVideos
        .where((video) => favorites.contains(video.id))
        .toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        heading(tr('more')),
        const SizedBox(height: 22),
        sectionTitle(tr('favorites')),
        if (favoriteVideos.isEmpty)
          Text(tr('noFavorites'), style: const TextStyle(color: muted))
        else
          ...favoriteVideos.map(videoCard),
        const SizedBox(height: 25),
        sectionTitle(tr('contact')),
        Text(tr('contactText'),
            style: const TextStyle(color: muted, height: 1.6)),
        const SizedBox(height: 17),
        TextField(
          controller: contactNameController,
          decoration: fieldDecoration(tr('name')),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: contactEmailController,
          keyboardType: TextInputType.emailAddress,
          decoration: fieldDecoration(tr('email')),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: contactType,
          dropdownColor: surfaceColor,
          decoration: fieldDecoration(tr('messageType')),
          items: [
            tr('contactTypeGuest'),
            tr('contactTypeSponsorship'),
            tr('contactTypeCounselling'),
            tr('contactTypeGeneral'),
          ].map((item) => DropdownMenuItem(
            value: item,
            child: Text(item),
          )).toList(),
          onChanged: (value) {
            if (value != null) setState(() => contactType = value);
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: contactMessageController,
          minLines: 4,
          maxLines: 7,
          decoration: fieldDecoration(tr('message')),
        ),
        const SizedBox(height: 14),
        FilledButton.icon(
          onPressed: sendContact,
          icon: const Icon(Icons.send),
          label: Text(tr('sendMessage')),
          style: FilledButton.styleFrom(backgroundColor: rose),
        ),
        const SizedBox(height: 25),
        contactSummary(),
        const SizedBox(height: 25),
        sectionTitle(tr('language')),
        languageSelector(expanded: true),
        const SizedBox(height: 25),
        platformSection(),
        const SizedBox(height: 30),
        Center(
          child: Column(
            children: [
              Text(
                tr('copyright'),
                style: const TextStyle(color: muted, fontSize: 12),
              ),
              const SizedBox(height: 10),
              Text(
                '${tr('creator')} • ${tr('mainHost')}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: muted, fontSize: 12, height: 1.5),
              ),
              const SizedBox(height: 4),
              const Text(
                'Joseph Nisamba aka Jozee Piano',
                textAlign: TextAlign.center,
                style: TextStyle(color: cream, fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget contactSummary() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr('contactTitle'),
            style: const TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          contactLine(Icons.phone, '+255 652 818 853',
              () => openLink('https://wa.me/255652818853')),
          contactLine(Icons.email_outlined, 'lovetimepodcast@gmail.com',
              () => openLink('mailto:lovetimepodcast@gmail.com')),
          contactLine(Icons.location_on_outlined, tr('location'), null),
          contactLine(Icons.language, 'lovetimepodcast.netlify.app',
              () => openLink('https://lovetimepodcast.netlify.app/')),
        ],
      ),
    );
  }

  Widget contactLine(IconData icon, String text, VoidCallback? action) {
    return InkWell(
      onTap: action,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: rose, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: const TextStyle(color: cream))),
          ],
        ),
      ),
    );
  }

  Widget platformSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle(tr('platforms')),
        Wrap(
          spacing: 9,
          runSpacing: 9,
          children: [
            platformChip('YouTube', Icons.play_circle_fill,
                'https://www.youtube.com/@LOVETIMEPODCAST'),
            platformChip('TikTok', Icons.music_note,
                'https://www.tiktok.com/@lovetime_podcast'),
            platformChip('Spotify', Icons.graphic_eq, 'https://spotify.com'),
            platformChip('Apple Podcasts', Icons.podcasts,
                'https://apple.com/apple-podcasts/'),
            platformChip('Google Podcasts', Icons.podcasts,
                'https://podcasts.google.com'),
          ],
        ),
      ],
    );
  }

  Widget platformChip(String label, IconData icon, String url) {
    return ActionChip(
      avatar: Icon(icon, color: rose, size: 18),
      label: Text(label),
      backgroundColor: surfaceColor,
      side: BorderSide(color: rose.withValues(alpha: 0.2)),
      labelStyle: const TextStyle(color: cream),
      onPressed: () => openInAppMedia(label, url),
    );
  }

  Widget languageSelector({bool expanded = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: language,
          dropdownColor: surfaceColor,
          isExpanded: expanded,
          iconEnabledColor: rose,
          style: const TextStyle(color: cream, fontSize: 13),
          items: const [
            DropdownMenuItem(value: 'sw', child: Text('🇹🇿 Kiswahili')),
            DropdownMenuItem(value: 'en', child: Text('🇬🇧 English')),
            DropdownMenuItem(value: 'fr', child: Text('🇫🇷 Français')),
          ],
          onChanged: changeLanguage,
        ),
      ),
    );
  }
}

class StoryArticleScreen extends StatelessWidget {
  final StoryArticle article;

  const StoryArticleScreen({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: cream,
        iconTheme: const IconThemeData(color: cream),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            appBrandLogo(size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(article.source),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.source,
              style: const TextStyle(
                color: rose,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              article.title,
              style: const TextStyle(
                color: cream,
                fontFamily: 'PlayfairDisplay',
                fontSize: 30,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              article.summary,
              style: const TextStyle(
                color: muted,
                fontSize: 15,
                height: 1.7,
              ),
            ),
            const SizedBox(height: 22),
            const Divider(color: Colors.white24),
            const SizedBox(height: 22),
            Text(
              article.body,
              style: const TextStyle(
                color: cream,
                fontSize: 16,
                height: 1.9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AudioPlaylistScreen extends StatelessWidget {
  final List<TrendingAudioClip> clips;
  final String title;
  final String language;

  const AudioPlaylistScreen({
    super.key,
    required this.clips,
    required this.title,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: cream,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            appBrandLogo(size: 24),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: clips.length,
        itemBuilder: (_, index) {
          final clip = clips[index];
          final localizedTitle = clip.localizedTitles[language] ?? clip.title;
          final localizedDescription = clip.localizedDescriptions[language] ?? clip.description;
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MediaPlayerScreen(
                    title: localizedTitle,
                    url: clip.url,
                    narration: localizedDescription,
                    narrationTranslations: {
                      'sw': clip.description,
                      ...clip.localizedDescriptions,
                    },
                    initialLanguage: language,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(18),
                    ),
                    child: SizedBox(
                      width: 110,
                      height: 110,
                      child: Image.network(
                        clip.thumbnail,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: purple,
                          child: const Icon(Icons.play_circle_fill, color: cream, size: 40),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            clip.platform,
                            style: const TextStyle(
                              color: rose,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            localizedTitle,
                            style: const TextStyle(
                              color: cream,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            localizedDescription,
                            style: const TextStyle(
                              color: muted,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class WebsiteAudioPlayerScreen extends StatefulWidget {
  final String title;
  final String url;

  const WebsiteAudioPlayerScreen({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<WebsiteAudioPlayerScreen> createState() => _WebsiteAudioPlayerScreenState();
}

class _WebsiteAudioPlayerScreenState extends State<WebsiteAudioPlayerScreen> {
  final AudioPlayer player = AudioPlayer();
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    player.onDurationChanged.listen((value) {
      if (mounted) {
        setState(() => duration = value);
      }
    });
    player.onPositionChanged.listen((value) {
      if (mounted) {
        setState(() => position = value);
      }
    });
    player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          isPlaying = false;
          position = Duration.zero;
        });
      }
    });
    player.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() => isPlaying = state == PlayerState.playing);
      }
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> togglePlayback() async {
    if (isPlaying) {
      await player.pause();
      return;
    }
    await player.play(UrlSource(widget.url));
  }

  String formatTime(Duration value) {
    final minutes = value.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> seekBy(int seconds) async {
    final target = position + Duration(seconds: seconds);
    final safeTarget = Duration(
      milliseconds: target.inMilliseconds.clamp(0, duration.inMilliseconds).toInt(),
    );
    await player.seek(safeTarget);
  }

  @override
  Widget build(BuildContext context) {
    final maxMilliseconds = duration.inMilliseconds > 0 ? duration.inMilliseconds.toDouble() : 1.0;
    final currentMilliseconds = position.inMilliseconds.clamp(0, duration.inMilliseconds).toDouble();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(widget.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        backgroundColor: backgroundColor,
        foregroundColor: cream,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 520),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: rose.withValues(alpha: 0.18)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: rose.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.graphic_eq, color: rose, size: 64),
                ),
                const SizedBox(height: 22),
                Text(widget.title, textAlign: TextAlign.center, style: const TextStyle(color: cream, fontFamily: 'PlayfairDisplay', fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 7),
                const Text('Love Time Podcast Show', style: TextStyle(color: muted)),
                const SizedBox(height: 24),
                Slider(
                  value: currentMilliseconds.clamp(0, maxMilliseconds),
                  max: maxMilliseconds,
                  activeColor: rose,
                  inactiveColor: Colors.white24,
                  onChanged: (value) => player.seek(Duration(milliseconds: value.toInt())),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatTime(position), style: const TextStyle(color: muted, fontSize: 12)),
                    Text(formatTime(duration), style: const TextStyle(color: muted, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(onPressed: () => seekBy(-15), tooltip: 'Rudi sekunde 15', icon: const Icon(Icons.replay_10, color: muted, size: 32)),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: togglePlayback,
                      style: FilledButton.styleFrom(backgroundColor: rose, minimumSize: const Size(64, 64), shape: const CircleBorder()),
                      child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 34),
                    ),
                    const SizedBox(width: 12),
                    IconButton(onPressed: () => seekBy(15), tooltip: 'Songa sekunde 15', icon: const Icon(Icons.forward_10, color: muted, size: 32)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MediaPlayerScreen extends StatefulWidget {
  final String title;
  final String url;
  final String? narration;
  final Map<String, String>? narrationTranslations;
  final String initialLanguage;

  const MediaPlayerScreen({
    super.key,
    required this.title,
    required this.url,
    this.narration,
    this.narrationTranslations,
    this.initialLanguage = 'sw',
  });

  @override
  State<MediaPlayerScreen> createState() => _MediaPlayerScreenState();
}

class _MediaPlayerScreenState extends State<MediaPlayerScreen> {
  final FlutterTts flutterTts = FlutterTts();
  late String dubbingLanguage;
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    dubbingLanguage = widget.initialLanguage;
    flutterTts.setCompletionHandler(() {
      if (mounted) setState(() => isSpeaking = false);
    });
    flutterTts.setCancelHandler(() {
      if (mounted) setState(() => isSpeaking = false);
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  String get localeCode {
    switch (dubbingLanguage) {
      case 'en':
        return 'en-US';
      case 'fr':
        return 'fr-FR';
      default:
        return 'sw-TZ';
    }
  }

  Future<void> playNarration() async {
    final text = widget.narrationTranslations?[dubbingLanguage] ??
        widget.narration ??
        widget.title;
    await flutterTts.stop();
    await flutterTts.setLanguage(localeCode);
    await flutterTts.setSpeechRate(0.48);
    await flutterTts.setPitch(1.0);
    setState(() => isSpeaking = true);
    final result = await flutterTts.speak(text);
    if (result != 1 && mounted) setState(() => isSpeaking = false);
  }

  Future<void> stopNarration() async {
    await flutterTts.stop();
    if (mounted) setState(() => isSpeaking = false);
  }

  String dubbingLabel(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      default:
        return 'Kiswahili';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF0C0714))
      ..setUserAgent('Mozilla/5.0 (Linux; Android 14; Mobile) AppleWebKit/537.36 Chrome/131.0.0.0 Mobile Safari/537.36')
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {},
          onPageStarted: (page) {},
          onPageFinished: (page) {},
          onWebResourceError: (error) {},
          onNavigationRequest: (request) => NavigationDecision.navigate,
        ),
      )
      ..loadRequest(
        Uri.parse(widget.url),
        headers: const {
          'Referer': 'https://lovetimepodcast.netlify.app/',
          'Origin': 'https://lovetimepodcast.netlify.app',
        },
      );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            appBrandLogo(size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(widget.title, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        actions: widget.url.contains('/embed/') || widget.url.contains('/player/v1/')
            ? [
                IconButton(
                  tooltip: widget.url.contains('tiktok.com') ? 'Open in TikTok' : 'Watch on YouTube',
                  onPressed: () async {
                    if (widget.url.contains('tiktok.com')) {
                      final videoId = Uri.parse(widget.url).pathSegments.last;
                      await launchUrl(
                        Uri.parse('https://www.tiktok.com/@lovetime_podcast/video/$videoId'),
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      final videoId = Uri.parse(widget.url).pathSegments.last;
                      await launchUrl(
                        Uri.parse('https://www.youtube.com/watch?v=$videoId'),
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  icon: const Icon(Icons.open_in_new, color: cream),
                ),
              ]
            : null,
        backgroundColor: backgroundColor,
        foregroundColor: cream,
        iconTheme: const IconThemeData(color: cream),
      ),
      body: Column(
        children: [
          Expanded(child: WebViewWidget(controller: controller)),
          if (widget.narration != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              color: surfaceColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.record_voice_over, color: rose, size: 20),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Dubbing / Lugha ya sauti',
                          style: TextStyle(fontWeight: FontWeight.bold, color: cream),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Stop narration',
                        onPressed: stopNarration,
                        icon: const Icon(Icons.stop_circle_outlined, color: muted),
                      ),
                      FilledButton.icon(
                        onPressed: isSpeaking ? stopNarration : playNarration,
                        icon: Icon(isSpeaking ? Icons.pause : Icons.play_arrow),
                        label: Text(isSpeaking ? 'Sitisha' : 'Sikiliza'),
                        style: FilledButton.styleFrom(backgroundColor: rose),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: ['sw', 'en', 'fr'].map((code) {
                      final selected = dubbingLanguage == code;
                      return ChoiceChip(
                        label: Text(dubbingLabel(code)),
                        selected: selected,
                        selectedColor: rose.withValues(alpha: 0.28),
                        side: BorderSide(color: selected ? rose : Colors.white24),
                        labelStyle: TextStyle(color: selected ? cream : muted),
                        onSelected: (_) async {
                          await stopNarration();
                          setState(() => dubbingLanguage = code);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.narrationTranslations?[dubbingLanguage] ?? widget.narration!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: muted, height: 1.45, fontSize: 12),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
