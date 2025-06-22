import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../widgets/navigation_bar.dart';

class DetailScreen extends StatelessWidget {
  final String name;
  final String address;
  final String image;
  final String description;
  final double rating;
  final int reviews;
  final List<String> facilities;
  final String price;

  const DetailScreen({
    Key? key,
    required this.name,
    required this.address,
    required this.image,
    required this.description,
    required this.rating,
    required this.reviews,
    required this.facilities,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.purple,
        elevation: 0,
        title: Text(
          "Detail PlayStation",
          style: TextStyle(color: AppColors.white),
        ),
        iconTheme: IconThemeData(color: AppColors.white),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            // Gambar utama
            ClipRRect(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              child: Image.asset(
                image,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama & rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: AppColors.purple,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.pink.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: AppColors.pink, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              "$rating",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.pink,
                              ),
                            ),
                            Text(
                              " ($reviews)",
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
                  const SizedBox(height: 8),
                  // Alamat
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppColors.purple,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          address,
                          style: TextStyle(color: AppColors.dark, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.attach_money,
                        color: AppColors.pink,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        price,
                        style: TextStyle(
                          color: AppColors.pink,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Fasilitas
                  Text(
                    "Fasilitas",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.purple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children:
                        facilities
                            .map(
                              (f) => Chip(
                                label: Text(
                                  f,
                                  style: TextStyle(color: AppColors.purple),
                                ),
                                backgroundColor: AppColors.lightPink
                                    .withOpacity(0.16),
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 18),
                  // Deskripsi
                  Text(
                    "Deskripsi",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.purple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      color: AppColors.dark,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Tombol Booking
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.pink,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/booking');
                      },
                      child: Text("Booking Sekarang"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
