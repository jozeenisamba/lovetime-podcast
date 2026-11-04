
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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

  String storySubject = 'Changamoto ya Ndoa';
  String contactType = 'Podcast Guest';
  bool anonymous = true;

  List<YoutubeVideo> youtubeVideos = [];
  bool loadingYoutube = true;
  String? youtubeError;

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
      'aboutText': 'Tunaongea kile watu wanachokihisi lakini wanaogopa kukisema. LoveTime ni daraja la kuelewana na kujenga upendo wa kweli kupitia mazungumzo, elimu na simulizi halisi.',
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
      'aboutText': 'We talk about what people feel but are afraid to say. LoveTime is a bridge to understanding and true love through conversations, education and real stories.',
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
      'aboutText': 'Nous parlons de ce que les gens ressentent mais n’osent pas dire. LoveTime favorise la compréhension et le véritable amour grâce aux échanges et aux histoires réelles.',
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
    },
  };

  String tr(String key) => translations[language]?[key] ?? key;

  @override
  void initState() {
    super.initState();
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
        const SnackBar(content: Text('Imeshindikana kufungua kiungo.')),
      );
    }
  }

  Future<void> sendStory() async {
    if (storyController.text.trim().isEmpty) {
      showMessage('Tafadhali andika mkasa au swali lako kwanza.');
      return;
    }
    final name = anonymous ? 'Siri / Anonymous' : nicknameController.text.trim();
    final message = '''
LOVE TIME PODCAST - MKASA MPYA

Jina: ${name.isEmpty ? 'Anonymous' : name}
Mada: $storySubject

Mkasa:
${storyController.text.trim()}
''';
    final uri = Uri.https('wa.me', '/255652818853', {'text': message});
    await openLink(uri.toString());
  }

  Future<void> sendContact() async {
    if (contactMessageController.text.trim().isEmpty) {
      showMessage('Tafadhali andika ujumbe wako.');
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
    if (value != null) setState(() => language = value);
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
      body: SafeArea(child: IndexedStack(
        index: selectedTab,
        children: pages,
      )),
      bottomNavigationBar: NavigationBar(
        height: 68,
        backgroundColor: surfaceColor,
        indicatorColor: rose.withValues(alpha: 0.18),
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
            const Icon(Icons.favorite, color: rose, size: 27),
            const SizedBox(width: 9),
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
            borderRadius: BorderRadius.circular(25),
            gradient: const LinearGradient(
              colors: [Color(0xFF342052), Color(0xFF170D24), Color(0xFF281226)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: rose.withValues(alpha: 0.2)),
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
                child: const Text(
                  'PODCAST YA MAHUSIANO',
                  style: TextStyle(
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
          heading('LoveTime on YouTube',
              subtitle: 'Video mpya kutoka kwenye channel yetu.'),
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
                const Text(
                  'LOVETIME PODCAST',
                  style: TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => openLink(
                    'https://www.youtube.com/@LOVETIMEPODCAST',
                  ),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Fungua YouTube Channel'),
                  style: FilledButton.styleFrom(backgroundColor: rose),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Video za hivi karibuni',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                const Text(
                  'Imeshindikana kupata video. Hakikisha una intaneti.',
                  style: TextStyle(color: muted),
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
        ],
      ),
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
            onTap: () => openLink(video.url),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    video.thumbnail,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
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
                    onTap: () => openLink(video.url),
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
        TextField(
          controller: nicknameController,
          decoration: fieldDecoration(tr('nickname')),
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          value: storySubject,
          decoration: fieldDecoration(tr('subject')),
          dropdownColor: surfaceColor,
          items: const [
            'Usaliti & Shaka',
            'Changamoto ya Ndoa',
            'Kuanzisha Mahusiano mapya',
            'Changamoto na Wakwe / Familia',
            'Mengineyo',
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
        const Text(
          'Ujumbe utaandaliwa kwenye WhatsApp yako ili uutume. '
          'Hauhifadhiwi moja kwa moja kwenye server ya LoveTime.',
          style: TextStyle(color: muted, fontSize: 12, height: 1.5),
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
          value: contactType,
          dropdownColor: surfaceColor,
          decoration: fieldDecoration(tr('messageType')),
          items: const [
            'Podcast Guest',
            'Sponsorship',
            'Counselling Session',
            'General Comment',
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
        const Center(
          child: Text(
            'LoveTime Podcast ©',
            style: TextStyle(color: muted, fontSize: 12),
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
          const Text(
            'Wasiliana nasi',
            style: TextStyle(
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
      onPressed: () => openLink(url),
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
