
import 'package:flutter/material.dart';

void main() {
  runApp(const LoveTimeApp());
}

const red = Color(0xFFE50932);
const gold = Color(0xFFFFC928);
const bg = Color(0xFF101010);
const card = Color(0xFF1D1D1D);

class LoveTimeApp extends StatelessWidget {
  const LoveTimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LoveTime Podcast',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.dark(
          primary: red,
          secondary: gold,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTab = 0;
  String category = 'Vyote';
  final search = TextEditingController();

  final episodes = [
    ['NILICHEPUKA KWENYE NDOA', 'Mahusiano', 'Dakika 45'],
    ['JE, NDOA YA PILI NI SULUHISHO?', 'Ndoa', 'Dakika 38'],
    ['SIRI ZA MAHUSIANO YENYE FURAHA', 'Maisha', 'Dakika 52'],
    ['MAPENZI, PESA NA FAMILIA', 'Familia', 'Dakika 41'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: selectedTab == 0 ? home() : otherPage(),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: card,
        indicatorColor: red.withValues(alpha: 0.25),
        selectedIndex: selectedTab,
        onDestinationSelected: (value) {
          setState(() => selectedTab = value);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Nyumbani',
          ),
          NavigationDestination(
            icon: Icon(Icons.play_circle_outline),
            label: 'Vipindi',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            label: 'Vipendwa',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Wasifu',
          ),
        ],
      ),
    );
  }

  Widget home() {
    final filtered = episodes.where((e) {
      final matchesSearch =
          e[0].toLowerCase().contains(search.text.toLowerCase());
      final matchesCategory =
          category == 'Vyote' || e[1] == category;
      return matchesSearch && matchesCategory;
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: red,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('LOVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    )),
                  Text('TIME PODCAST',
                    style: TextStyle(
                      color: gold,
                      fontSize: 11,
                      letterSpacing: 3,
                      fontWeight: FontWeight.bold,
                    )),
                ],
              ),
            ),
            const Icon(Icons.notifications_none, size: 27),
          ],
        ),
        const SizedBox(height: 28),
        const Text('KARIBU LOVE TIME ❤️',
          style: TextStyle(
            color: gold,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          )),
        const SizedBox(height: 8),
        const Text('Mahusiano, maisha\nna burudani.',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            height: 1.15,
          )),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              colors: [Color(0xFF8F001F), Color(0xFF25000B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('KIPINDI MAALUM',
                style: TextStyle(
                  color: gold,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                )),
              const SizedBox(height: 12),
              const Text('MAZUNGUMZO\nYANAYOBADILI MAISHA',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                )),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: () => setState(() => selectedTab = 1),
                icon: const Icon(Icons.play_arrow),
                label: const Text('GUNDUA VIPINDI'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        TextField(
          controller: search,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Tafuta kipindi...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 23),
        const Text('CHAGUA KATEGORIA',
          style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['Vyote', 'Mahusiano', 'Ndoa', 'Maisha', 'Familia']
                .map((item) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(item),
                    selected: category == item,
                    selectedColor: red,
                    onSelected: (_) => setState(() => category = item),
                  ),
                )).toList(),
          ),
        ),
        const SizedBox(height: 24),
        const Text('VIPINDI VYA KARIBUNI',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          )),
        const SizedBox(height: 12),
        ...filtered.map((e) => episodeCard(e)),
        const SizedBox(height: 25),
        const Center(
          child: Text('LOVE TIME PODCAST • MAHUSIANO NA MAISHA',
            style: TextStyle(color: Colors.white38, fontSize: 10)),
        ),
      ],
    );
  }

  Widget episodeCard(List<String> episode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: red.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(Icons.mic, color: gold, size: 35),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(episode[1],
                  style: const TextStyle(color: gold, fontSize: 11)),
                const SizedBox(height: 5),
                Text(episode[0],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  )),
                const SizedBox(height: 5),
                Text(episode[2],
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                  )),
              ],
            ),
          ),
          const Icon(Icons.play_circle_fill, color: red, size: 34),
        ],
      ),
    );
  }

  Widget otherPage() {
    final titles = ['Nyumbani', 'Vipindi vyote', 'Vipendwa vyangu', 'Wasifu'];
    final icons = [
      Icons.home,
      Icons.play_circle,
      Icons.favorite,
      Icons.person,
    ];
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icons[selectedTab], color: red, size: 65),
          const SizedBox(height: 15),
          Text(titles[selectedTab],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )),
          const SizedBox(height: 8),
          const Text('LoveTime Podcast',
            style: TextStyle(color: gold)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => setState(() => selectedTab = 0),
            child: const Text('RUDI NYUMBANI'),
          ),
        ],
      ),
    );
  }
}
