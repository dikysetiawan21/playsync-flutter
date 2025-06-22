import 'package:flutter/material.dart';
import 'dart:convert';
import '../core/theme.dart';
import '../widgets/navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, String>> histories = [];

  @override
  void initState() {
    super.initState();
    _loadHistories();
  }

  Future<void> _loadHistories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> historyList = prefs.getStringList('booking_history') ?? [];
    List<Map<String, String>> loaded = [];
    for (String entry in historyList) {
      try {
        final map = Map<String, String>.from(jsonDecode(entry));
        loaded.add(map);
      } catch (e) {
        // ignore invalid entries
      }
    }
    setState(() {
      histories = loaded.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.purple,
        title: const Text('Riwayat Booking'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: histories.length,
        separatorBuilder: (context, _) => const SizedBox(height: 14),
        itemBuilder: (context, i) {
          final history = histories[i];
          return Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.purple.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: history["image"] != null && history["image"]!.startsWith('assets/')
                    ? Image.asset(
                        history["image"]!,
                        width: 54,
                        height: 54,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        history["image"] ?? '',
                        width: 54,
                        height: 54,
                        fit: BoxFit.cover,
                      ),
              ),
              title: Text(
                history["venue"]!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.purple,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${history["date"]!} | ${history["time"]!}",
                    style: TextStyle(color: AppColors.dark, fontSize: 13),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    history["status"]!,
                    style: TextStyle(
                      color:
                          history["status"] == "Selesai"
                              ? Colors.green
                              : Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              trailing: Icon(Icons.chevron_right, color: AppColors.purple),
              onTap: () {}, // Bisa diarahkan ke detail riwayat jika ingin
            ),
          );
        },
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) Navigator.pushNamed(context, '/booking');
          if (index == 2) Navigator.pushNamed(context, '/profile');
        },
      ),
    );
  }
}
