
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'youtube_service.dart';
void main() {
  runApp(const LoveTimeApp());
}

const Color backgroundColor = Color(0xFF171216);
const Color cardColor = Color(0xFF261B22);
const Color burgundy = Color(0xFF713B50);
const Color softPink = Color(0xFFD9A6B8);
const Color cream = Color(0xFFF3E7EB);
const Color mutedText = Color(0xFFBDAEB5);

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: burgundy,
          brightness: Brightness.dark,
          surface: backgroundColor,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class Episode {
  final String title;
  final String description;
  final String category;
  final IconData icon;

  const Episode({
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
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
  String category = 'Vyote';
  final TextEditingController searchController = TextEditingController();
  final Set<String> favorites = {};

  final List<Episode> episodes = const [
    Episode(
      title: 'Siri za Mahusiano',
      description: 'Mazungumzo kuhusu mapenzi na maisha ya pamoja.',
      category: 'Mahusiano',
      icon: Icons.favorite_rounded,
    ),
    Episode(
      title: 'Maisha ya Ndoa',
      description: 'Kujenga ndoa yenye upendo, heshima na amani.',
      category: 'Ndoa',
      icon: Icons.volunteer_activism_rounded,
    ),
    Episode(
      title: 'Familia na Malezi',
      description: 'Mawazo kuhusu familia na malezi ya watoto.',
      category: 'Familia',
      icon: Icons.family_restroom_rounded,
    ),
    Episode(
      title: 'Hadithi za Maisha',
      description: 'Simulizi, uzoefu na mafunzo kutoka kwa watu.',
      category: 'Maisha',
      icon: Icons.auto_stories_rounded,
    ),
  ];

  final Map<String, Map<String, String>> translations = {
    'sw': {
      'home': 'Nyumbani',
      'episodes': 'Vipindi',
      'youtube': 'YouTube',
      'favorites': 'Vipendwa',
      'profile': 'Wasifu',
      'welcome': 'Karibu LoveTime Podcast',
      'subtitle': 'Mahusiano • Ndoa • Familia • Maisha',
      'featured': 'Vipindi vya kuangazia',
      'all': 'Vyote',
      'relationships': 'Mahusiano',
      'marriage': 'Ndoa',
      'family': 'Familia',
      'life': 'Maisha',
      'search': 'Tafuta kipindi...',
      'openYoutube': 'Tembelea YouTube Channel',
      'youtubeTitle': 'LoveTime kwenye YouTube',
      'youtubeDescription':
          'Tazama mazungumzo, mijadala na simulizi kuhusu mahusiano na maisha.',
      'favoritesTitle': 'Vipindi unavyovipenda',
      'emptyFavorites': 'Bado hujaongeza kipindi kwenye vipendwa.',
      'profileTitle': 'Wasifu wako',
      'language': 'Chagua lugha',
      'noResults': 'Hakuna kipindi kilichopatikana.',
    },
    'en': {
      'home': 'Home',
      'episodes': 'Episodes',
      'youtube': 'YouTube',
      'favorites': 'Favorites',
      'profile': 'Profile',
      'welcome': 'Welcome to LoveTime Podcast',
      'subtitle': 'Relationships • Marriage • Family • Life',
      'featured': 'Featured episodes',
      'all': 'All',
      'relationships': 'Relationships',
      'marriage': 'Marriage',
      'family': 'Family',
      'life': 'Life',
      'search': 'Search episodes...',
      'openYoutube': 'Visit YouTube Channel',
      'youtubeTitle': 'LoveTime on YouTube',
      'youtubeDescription':
          'Watch conversations, debates and stories about relationships and life.',
      'favoritesTitle': 'Your favorite episodes',
      'emptyFavorites': 'You have not added any favorites yet.',
      'profileTitle': 'Your profile',
      'language': 'Choose language',
      'noResults': 'No episodes found.',
    },
    'fr': {
      'home': 'Accueil',
      'episodes': 'Épisodes',
      'youtube': 'YouTube',
      'favorites': 'Favoris',
      'profile': 'Profil',
      'welcome': 'Bienvenue sur LoveTime Podcast',
      'subtitle': 'Relations • Mariage • Famille • Vie',
      'featured': 'Épisodes à découvrir',
      'all': 'Tout',
      'relationships': 'Relations',
      'marriage': 'Mariage',
      'family': 'Famille',
      'life': 'Vie',
      'search': 'Rechercher un épisode...',
      'openYoutube': 'Visiter la chaîne YouTube',
      'youtubeTitle': 'LoveTime sur YouTube',
      'youtubeDescription':
          'Découvrez des conversations et des histoires sur les relations et la vie.',
      'favoritesTitle': 'Vos épisodes favoris',
      'emptyFavorites': 'Vous n’avez pas encore ajouté de favoris.',
      'profileTitle': 'Votre profil',
      'language': 'Choisir la langue',
      'noResults': 'Aucun épisode trouvé.',
    },
  };

  String tr(String key) => translations[language]![key] ?? key;

  String translatedCategory(String value) {
    switch (value) {
      case 'Vyote':
        return tr('all');
      case 'Mahusiano':
        return tr('relationships');
      case 'Ndoa':
        return tr('marriage');
      case 'Familia':
        return tr('family');
      case 'Maisha':
        return tr('life');
      default:
        return value;
    }
  }
  List<YoutubeVideo> youtubeVideos = [];
  bool loadingYoutube = true;
  String? youtubeError;

  @override
  void initState() {
    super.initState();
    loadYoutubeVideos();
  }

  Future<void> loadYoutubeVideos() async {
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
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> openYoutube() async {
    final uri = Uri.parse('https://www.youtube.com/@LOVETIMEPODCAST');
    final opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Imeshindikana kufungua YouTube.')),
      );
    }
  }

  void changeLanguage(String? value) {
    if (value != null) {
      setState(() => language = value);
    }
  }

  List<Episode> get filteredEpisodes {
    final query = searchController.text.toLowerCase();

    return episodes.where((episode) {
      final matchesCategory =
          category == 'Vyote' || episode.category == category;
      final matchesSearch = episode.title.toLowerCase().contains(query) ||
          episode.description.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      homePage(),
      episodesPage(),
      youtubePage(),
      favoritesPage(),
      profilePage(),
    ];

    return Scaffold(
      body: SafeArea(child: pages[selectedTab]),
      bottomNavigationBar: NavigationBar(
        height: 70,
        backgroundColor: const Color(0xFF211820),
        indicatorColor: burgundy.withValues(alpha: 0.55),
        selectedIndex: selectedTab,
        onDestinationSelected: (index) {
          setState(() => selectedTab = index);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded, color: cream),
            label: tr('home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.play_circle_outline),
            selectedIcon: const Icon(Icons.play_circle_fill),
            label: tr('episodes'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.smart_display_outlined),
            selectedIcon: const Icon(Icons.smart_display),
            label: tr('youtube'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_border),
            selectedIcon: const Icon(Icons.favorite),
            label: tr('favorites'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: tr('profile'),
          ),
        ],
      ),
    );
  }

  Widget pageHeader(String title, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: cream,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(color: mutedText)),
        ],
      ],
    );
  }

  Widget homePage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'LoveTime',
              style: TextStyle(
                color: softPink,
                fontSize: 27,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            languageSelector(),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              colors: [Color(0xFF633449), Color(0xFF30202A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.favorite_rounded, color: softPink, size: 30),
              const SizedBox(height: 18),
              Text(
                tr('welcome'),
                style: const TextStyle(
                  color: cream,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                tr('subtitle'),
                style: const TextStyle(color: Color(0xFFE7CBD5)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        pageHeader(tr('featured')),
        const SizedBox(height: 15),
        ...episodes.take(3).map(episodeCard),
        const SizedBox(height: 15),
        youtubeBanner(),
      ],
    );
  }

  Widget episodesPage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        pageHeader(tr('episodes')),
        const SizedBox(height: 18),
        TextField(
          controller: searchController,
          onChanged: (_) => setState(() {}),
          style: const TextStyle(color: cream),
          decoration: InputDecoration(
            hintText: tr('search'),
            hintStyle: const TextStyle(color: mutedText),
            prefixIcon: const Icon(Icons.search, color: softPink),
            filled: true,
            fillColor: cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 8,
          children: ['Vyote', 'Mahusiano', 'Ndoa', 'Familia', 'Maisha']
              .map(
                (item) => ChoiceChip(
                  label: Text(translatedCategory(item)),
                  selected: category == item,
                  selectedColor: burgundy,
                  backgroundColor: cardColor,
                  labelStyle: const TextStyle(color: cream),
                  onSelected: (_) => setState(() => category = item),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 15),
        if (filteredEpisodes.isEmpty)
          Text(tr('noResults'), style: const TextStyle(color: mutedText))
        else
          ...filteredEpisodes.map(episodeCard),
      ],
    );
  }
  Widget episodeCard(Episode episode) {
  final isFavorite = favorites.contains(episode.title);

  return Container(
    margin: const EdgeInsets.only(bottom: 13),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(17),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.04),
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: burgundy.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(episode.icon, color: softPink, size: 27),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                episode.title,
                style: const TextStyle(
                  color: cream,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                episode.description,
                style: const TextStyle(
                  color: mutedText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Favorite',
          onPressed: () {
            setState(() {
              if (isFavorite) {
                favorites.remove(episode.title);
              } else {
                favorites.add(episode.title);
              }
            });
          },
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: softPink,
          ),
        ),
      ],
    ),
  );
}


  Widget youtubeBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.smart_display, color: softPink, size: 32),
          const SizedBox(height: 10),
          Text(
            tr('youtubeTitle'),
            style: const TextStyle(
              color: cream,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tr('youtubeDescription'),
            style: const TextStyle(color: mutedText),
          ),
          const SizedBox(height: 15),
          FilledButton.icon(
            onPressed: openYoutube,
            style: FilledButton.styleFrom(
              backgroundColor: burgundy,
              foregroundColor: cream,
            ),
            icon: const Icon(Icons.play_arrow),
            label: Text(tr('openYoutube')),
          ),
        ],
      ),
    );
  }

  
  Widget youtubePage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        pageHeader(tr('youtubeTitle')),
        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.play_circle_fill,
                color: softPink,
                size: 75,
              ),
              const SizedBox(height: 18),
              Text(
                tr('youtubeDescription'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: mutedText,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: openYoutube,
                style: FilledButton.styleFrom(
                  backgroundColor: burgundy,
                  foregroundColor: cream,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
                icon: const Icon(Icons.open_in_new),
                label: Text(tr('openYoutube')),
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Video za hivi karibuni',
              style: TextStyle(
                color: cream,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: loadYoutubeVideos,
              icon: const Icon(
                Icons.refresh,
                color: softPink,
              ),
              tooltip: 'Refresh videos',
            ),
          ],
        ),

        const SizedBox(height: 12),

        if (loadingYoutube)
          const Padding(
            padding: EdgeInsets.all(30),
            child: Center(
              child: CircularProgressIndicator(
                color: softPink,
              ),
            ),
          ),

        if (!loadingYoutube && youtubeError != null)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.wifi_off,
                  color: softPink,
                  size: 40,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Imeshindikana kupakia video. Tafadhali jaribu tena.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: cream),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: loadYoutubeVideos,
                  child: const Text('Jaribu tena'),
                ),
              ],
            ),
          ),

        if (!loadingYoutube &&
            youtubeError == null &&
            youtubeVideos.isEmpty)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Hakuna video zilizopatikana kwa sasa.',
              textAlign: TextAlign.center,
              style: TextStyle(color: mutedText),
            ),
          ),

        ...youtubeVideos.map((video) {
          return Container(
            margin: const EdgeInsets.only(bottom: 18),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(18),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () async {
                await launchUrl(
                  Uri.parse(video.url),
                  mode: LaunchMode.externalApplication,
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      video.thumbnail,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: burgundy,
                          child: const Icon(
                            Icons.play_circle_fill,
                            color: cream,
                            size: 65,
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video.title,
                          style: const TextStyle(
                            color: cream,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.play_circle_outline,
                              color: softPink,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'LoveTime Podcast',
                              style: TextStyle(
                                color: mutedText,
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.open_in_new,
                              color: softPink,
                              size: 18,
                            ),
                          ],
                        ),
                      ],
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


  Widget favoritesPage() {
    final favoriteEpisodes = episodes
        .where((episode) => favorites.contains(episode.title))
        .toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        pageHeader(tr('favoritesTitle')),
        const SizedBox(height: 18),
        if (favoriteEpisodes.isEmpty)
          Text(
            tr('emptyFavorites'),
            style: const TextStyle(color: mutedText),
          )
        else
          ...favoriteEpisodes.map(episodeCard),
      ],
    );
  }

  Widget profilePage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        pageHeader(tr('profileTitle')),
        const SizedBox(height: 25),
        const CircleAvatar(
          radius: 42,
          backgroundColor: burgundy,
          child: Icon(Icons.person, color: cream, size: 45),
        ),
        const SizedBox(height: 15),
        const Center(
          child: Text(
            'LoveTime Podcast',
            style: TextStyle(
              color: cream,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Text(
          tr('language'),
          style: const TextStyle(color: cream, fontSize: 16),
        ),
        const SizedBox(height: 10),
        languageSelector(expanded: true),
      ],
    );
  }

  Widget languageSelector({bool expanded = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: language,
          dropdownColor: cardColor,
          isExpanded: expanded,
          iconEnabledColor: softPink,
          style: const TextStyle(color: cream),
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
