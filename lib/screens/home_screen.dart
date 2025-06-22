import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../widgets/navigation_bar.dart';
import '../widgets/shortcut_menu.dart';
import 'detail_screen.dart'; // Import DetailScreen agar bisa dipakai navigasi
import 'booking_screen.dart'; // Import BookingScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _searchQuery = '';

  // Untuk hasil filter
  List<Map<String, String>> get filteredPlaystations {
    if (_searchQuery.isEmpty) return playstations;
    return playstations.where((ps) {
      final name = ps["name"]?.toLowerCase() ?? '';
      final location = ps["location"]?.toLowerCase() ?? '';
      return name.contains(_searchQuery.toLowerCase()) ||
          location.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _onTabTapped(int index) {
    if (index == 1) {
      Navigator.pushNamed(context, '/booking');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/profile');
    }
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Map<String, String>> playstations = [
    {
      "name": "PS Galaxy",
      "location": "Jl. Merdeka No. 10",
      "image": "assets/images/gamehub.png",
    },
    {
      "name": "Game Zone",
      "location": "Jl. Sudirman No. 22",
      "image": "assets/images/playzone.png",
    },
  ];

  final List<Map<String, String>> recommendations = [
    {
      "name": "Warzone PS",
      "location": "Jl. Pahlawan No. 45",
      "image": "assets/images/warzone-PS.png",
      "description":
          "Tempat rental PlayStation nyaman dengan fasilitas lengkap, AC, WiFi, dan snack.",
      "rating": "4.8",
      "reviews": "132",
      "facilities": "AC, WiFi, Snack & Minuman, Sofa Nyaman",
      "open_hours": "10:00 - 23:00",
      "price": "Rp 10.000 / jam",
    },
    {
      "name": "PS Galaxy",
      "location": "Jl. Merdeka No. 10",
      "image": "assets/images/gamehub.png",
      "description":
          "PS favorit dengan banyak pilihan game terbaru dan ruangan ber-AC.",
      "rating": "4.7",
      "reviews": "98",
      "facilities": "AC, WiFi, Snack, Parkir Luas",
      "open_hours": "09:00 - 22:00",
      "price": "Rp 12.000 / jam",
    },
    {
      "name": "Game Zone",
      "location": "Jl. Sudirman No. 22",
      "image": "assets/images/playzone.png",
      "description": "Game Zone dengan suasana santai dan harga terjangkau.",
      "rating": "4.6",
      "reviews": "75",
      "facilities": "AC, Snack, Area Merokok",
      "open_hours": "11:00 - 23:00",
      "price": "Rp 8.000 / jam",
    },
    {
      "name": "PSX Arena",
      "location": "Jl. Veteran No. 5",
      "image": "assets/images/psxarena.png",
      "description": "Arena PS dengan banyak turnamen dan komunitas aktif.",
      "rating": "4.9",
      "reviews": "210",
      "facilities": "AC, WiFi, Turnamen, Snack",
      "open_hours": "10:00 - 00:00",
      "price": "Rp 15.000 / jam",
    },
    {
      "name": "PlayZone",
      "location": "Jl. Diponegoro No. 8",
      "image": "assets/images/playzone.png",
      "description": "PlayZone dengan sofa empuk dan banyak pilihan minuman.",
      "rating": "4.5",
      "reviews": "60",
      "facilities": "AC, Minuman, Sofa, WiFi",
      "open_hours": "12:00 - 22:00",
      "price": "Rp 9.000 / jam",
    },
  ];

  final List<Map<String, String>> news = [
    {
      "title": "Promo Diskon Akhir Pekan!",
      "image": "assets/images/playzone.png",
    },
    {
      "title": "Turnamen FIFA 2025 Segera Dimulai",
      "image": "assets/images/psxarena.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildModernHeader(context),
            ),
            const SizedBox(height: 20),
            // Menu shortcut
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ShortcutMenu(
                    icon: Icons.sports_esports,
                    label: "Booking",
                    color: AppColors.pink,
                    onTap: () {
                      // Navigate to booking screen with the selected PlayStation data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => BookingScreen(
                                name: recommendations[0]["name"],
                                address: recommendations[0]["location"],
                                price:
                                    recommendations[0]["price"]?.split(' ')[1],
                              ),
                        ),
                      );
                    },
                  ),
                  ShortcutMenu(
                    icon: Icons.history,
                    label: "Riwayat",
                    color: AppColors.purple,
                    onTap: () => Navigator.pushNamed(context, '/history'),
                  ),
                  ShortcutMenu(
                    icon: Icons.article,
                    label: "Berita",
                    color: AppColors.dark,
                    onTap: () {}, // Nanti diarahkan ke halaman berita
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            // Rekomendasi Tempat (horizontal scroll)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SectionTitle("Rekomendasi Tempat"),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: recommendations.length,
                separatorBuilder: (context, _) => const SizedBox(width: 16),
                itemBuilder: (context, i) {
                  final rec = recommendations[i];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => DetailScreen(
                                name: rec["name"]!,
                                address: rec["location"]!,
                                image: rec["image"]!,
                                description: rec["description"]!,
                                rating:
                                    double.tryParse(rec["rating"] ?? "0") ?? 0,
                                reviews:
                                    int.tryParse(rec["reviews"] ?? "0") ?? 0,
                                facilities: (rec["facilities"] ?? "").split(
                                  ", ",
                                ),
                                price: rec["price"] ?? "-",
                              ),
                        ),
                      );
                    },
                    child: Container(
                      width: 260,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.purple.withOpacity(0.08),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            child: Image.asset(
                              rec["image"]!,
                              height: 110,
                              width: 260,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  rec["name"]!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.purple,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  rec["location"]!,
                                  style: TextStyle(
                                    color: AppColors.dark,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 28),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Cari PlayStation...",
                  prefixIcon: Icon(Icons.search, color: AppColors.purple),
                  filled: true,
                  fillColor: AppColors.lightPink.withAlpha(
                    (255 * 0.13).toInt(),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
            ),
            const SizedBox(height: 18),
            // Daftar PlayStation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SectionTitle("Semua PlayStation"),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children:
                    filteredPlaystations.isEmpty
                        ? [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Text(
                              "Tidak ada tempat ditemukan.",
                              style: TextStyle(
                                color: AppColors.dark.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ]
                        : filteredPlaystations
                            .map(
                              (ps) => Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: AppColors.lightPink.withAlpha(
                                    (255 * 0.12).toInt(),
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.purple.withAlpha(
                                        (255 * 0.05).toInt(),
                                      ),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      ps["image"]!,
                                      width: 56,
                                      height: 56,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(
                                    ps["name"]!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.purple,
                                    ),
                                  ),
                                  subtitle: Text(
                                    ps["location"]!,
                                    style: TextStyle(color: AppColors.dark),
                                  ),
                                  trailing: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.pink,
                                      foregroundColor: AppColors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text("Booking"),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/booking');
                                    },
                                  ),
                                ),
                              ),
                            )
                            .toList(),
              ),
            ),
            const SizedBox(height: 28),
            // Berita terbaru (horizontal scroll)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SectionTitle("Berita Terbaru"),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 110,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: news.length,
                separatorBuilder: (context, _) => const SizedBox(width: 14),
                itemBuilder: (context, i) {
                  final n = news[i];
                  return Container(
                    width: 180,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.purple.withOpacity(0.08),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(16),
                          ),
                          child: Image.asset(
                            n["image"]!,
                            width: 60,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              n["title"]!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.dark,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  // Custom modern header
  Widget _buildModernHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 12),
      child: Stack(
        children: [
          // Background container
          Container(
            height: 240,
            decoration: BoxDecoration(
              color: AppColors.purple,
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          // User avatar
          Positioned(
            right: 24,
            top: 28,
            child: CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.white,
              backgroundImage: NetworkImage(
                "https://randomuser.me/api/portraits/men/32.jpg",
              ),
            ),
          ),
          // Greeting and profile label
          Positioned(
            left: 28,
            top: 25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello, Diky",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Your Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Balance and Top Up button
          Positioned(
            left: 28,
            right: 28,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.purple.withValues(alpha: 0.10),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sisa saldo kamu",
                        style: TextStyle(
                          color: AppColors.dark.withOpacity(0.5),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Rp100.000",
                        style: TextStyle(
                          color: AppColors.purple,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      // TODO: aksi top up
                    },
                    child: const Text(
                      "Top up",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
