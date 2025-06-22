import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../widgets/navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.purple,
        elevation: 0,
        title: Text('Profil Saya', style: TextStyle(color: AppColors.white)),
        iconTheme: IconThemeData(color: AppColors.white),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Header User
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: AppColors.lightPink,
                    backgroundImage: NetworkImage(
                      "https://randomuser.me/api/portraits/men/32.jpg", // Ganti dengan foto user asli jika ada
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    "User PlaySync",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.purple,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "user@email.com",
                    style: TextStyle(
                      color: AppColors.dark.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            // Info Saldo
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: AppColors.purple,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.purple.withOpacity(0.07),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    color: AppColors.white,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Saldo",
                        style: TextStyle(
                          color: AppColors.lightPink,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Rp 100.000",
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Menu Aksi
            ProfileMenuItem(
              icon: Icons.edit,
              label: "Edit Profil",
              color: AppColors.purple,
              onTap: () {
                // TODO: Navigasi ke halaman edit profil
              },
            ),
            ProfileMenuItem(
              icon: Icons.history,
              label: "Riwayat Booking",
              color: AppColors.pink,
              onTap: () {
                Navigator.pushNamed(context, '/history');
              },
            ),
            ProfileMenuItem(
              icon: Icons.bug_report,
              label: "Debug SharedPrefs",
              color: Colors.blue,
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                final keys = prefs.getKeys();
                for (var key in keys) {
                  print('$key: [33m${prefs.get(key)}[0m');
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Cek log console untuk hasilnya!')),
                );
              },
            ),
            ProfileMenuItem(
              icon: Icons.logout,
              label: "Logout",
              color: AppColors.dark,
              onTap: () {
                // TODO: Logout logic
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text("Logout"),
                        content: Text("Yakin ingin keluar dari akun?"),
                        actions: [
                          TextButton(
                            child: Text(
                              "Batal",
                              style: TextStyle(color: AppColors.purple),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: Text(
                              "Logout",
                              style: TextStyle(color: AppColors.pink),
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setBool('is_logged_in', false);
                              // (Opsional) Hapus data user jika ingin
                              // await prefs.remove('user_email');
                              // await prefs.remove('user_password');
                              // await prefs.remove('user_name');
                              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                            },
                          ),
                        ],
                      ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) Navigator.pushNamed(context, '/home');
          if (index == 1) Navigator.pushNamed(context, '/booking');
        },
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.13),
        child: Icon(icon, color: color),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.dark,
          fontSize: 16,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppColors.lightPink,
        size: 18,
      ),
      onTap: onTap,
    );
  }
}
