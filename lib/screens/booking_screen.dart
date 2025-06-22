import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme.dart';
import '../widgets/navigation_bar.dart';

class BookingScreen extends StatefulWidget {
  final String? name;
  final String? address;
  final String? price;

  const BookingScreen({
    Key? key,
    this.name,
    this.address,
    this.price,
  }) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String? selectedPS;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int durationHours = 1; // Default booking duration in hours
  late List<Map<String, String>> playstationData;

  @override
  void initState() {
    super.initState();
    playstationData = [
      {
        "name": "PS Galaxy",
        "address": "Jl. Merdeka No. 10",
        "price": "Rp 12.000 / jam",
      },
      {
        "name": "Game Zone",
        "address": "Jl. Sudirman No. 22",
        "price": "Rp 8.000 / jam",
      },
      {
        "name": "PSX Arena",
        "address": "Jl. Veteran No. 5",
        "price": "Rp 15.000 / jam",
      },
      {
        "name": "PlayZone",
        "address": "Jl. Diponegoro No. 8",
        "price": "Rp 9.000 / jam",
      },
      {
        "name": "Warzone PS",
        "address": "Jl. Gatot Subroto No. 15",
        "price": "Rp 10.000 / jam",
      },
    ];

    // If name and address are provided, pre-select the venue
    if (widget.name != null && widget.address != null) {
      selectedPS = '${widget.name} - ${widget.address}';
    }
  }

  // Get base price per hour
  int? get basePrice {
    if (widget.price != null) {
      // If price is passed from detail screen, use that
      try {
        // Extract numeric value from price string (e.g., "Rp 15.000" -> 15000)
        final priceStr = widget.price!.replaceAll(RegExp(r'[^0-9]'), '');
        return int.tryParse(priceStr);
      } catch (e) {
        return null;
      }
    }
    
    // Fallback to the existing logic if no price is passed
    if (selectedPS == null) return null;
    final venue = selectedPS!.split(' - ')[0];
    final data = playstationData.firstWhere(
      (ps) => ps["name"] == venue,
      orElse: () => {"price": "-"},
    );
    
    final priceStr = data["price"]?.split(' ').first;
    if (priceStr == null) return null;
    
    try {
      return int.tryParse(priceStr.replaceAll(RegExp(r'[^0-9]'), ''));
    } catch (e) {
      return null;
    }
  }
  
  // Get formatted price per hour
  String? get pricePerHour {
    if (basePrice == null) return null;
    return "Rp ${basePrice!.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    )} / jam";
  }
  
  // Calculate and get total price
  String? get totalPrice {
    if (basePrice == null) return null;
    final total = basePrice! * durationHours;
    return _formatPrice(total);
  }

  // Format price with thousand separators
  String _formatPrice(int price) {
    return "Rp ${price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    )}";
  }

  // Get formatted price per hour
  String? get formattedPricePerHour {
    if (basePrice == null) return null;
    return _formatPrice(basePrice!);
  }

  final List<String> playstationList = [
    "PS Galaxy - Jl. Merdeka No. 10",
    "Game Zone - Jl. Sudirman No. 22",
    "PSX Arena - Jl. Veteran No. 5",
    "PlayZone - Jl. Diponegoro No. 8",
    "Warzone PS - Jl. Gatot Subroto No. 15",
  ];

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year, now.month + 2),
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.purple,
                onPrimary: AppColors.white,
                surface: AppColors.white,
              ),
            ),
            child: child!,
          ),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.purple,
                onPrimary: AppColors.white,
                surface: AppColors.white,
              ),
            ),
            child: child!,
          ),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }


  Future<void> _confirmBooking() async {
    if (selectedPS == null || selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lengkapi semua data booking!"),
          backgroundColor: AppColors.pink,
        ),
      );
      return;
    }

    // Simpan ke histori booking
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> historyList = prefs.getStringList('booking_history') ?? [];
    final venue = selectedPS!.split(' - ')[0];
    final address = selectedPS!.split(' - ').length > 1 ? selectedPS!.split(' - ')[1] : '';
    final date = "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";
    final time = selectedTime!.format(context);

    // Pilih gambar sesuai venue (harus sama dengan yang ada di home_screen.dart)
    String image = '';
    if (venue == 'PS Galaxy') image = 'assets/images/gamehub.png';
    else if (venue == 'Game Zone') image = 'assets/images/playzone.png';
    else if (venue == 'PSX Arena') image = 'assets/images/psxarena.png';
    else if (venue == 'PlayZone') image = 'assets/images/playzone.png';
    else image = 'assets/images/gamehub.png';

    final Map<String, String> newHistory = {
      "venue": venue,
      "address": address,
      "date": date,
      "time": time,
      "image": image,
      "duration": durationHours.toString(),
      "status": "Selesai",
    };
    historyList.add(jsonEncode(newHistory));
    await prefs.setStringList('booking_history', historyList);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Booking Berhasil!"),
        content: Text(
          "Booking untuk $selectedPS pada $date jam $time telah dikonfirmasi.",
        ),
        actions: [
          TextButton(
            child: Text("OK", style: TextStyle(color: AppColors.purple)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.purple,
        title: Text(
          "Booking PlayStation",
          style: TextStyle(color: AppColors.white),
        ),
        iconTheme: IconThemeData(color: AppColors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Pilih PlayStation
            Text(
              "Pilih Tempat",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.purple,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField(
              value: selectedPS,
              hint: const Text("Pilih PlayStation"),
              decoration: InputDecoration(
                fillColor: AppColors.lightPink.withAlpha(36),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                isDense: true,
              ),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black, // Set text color to black
                overflow: TextOverflow.ellipsis,
              ),
              isExpanded: true,
              items: playstationList
                  .map((ps) => DropdownMenuItem(
                        value: ps,
                        child: Text(
                          ps,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedPS = value;
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            if (selectedPS != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.attach_money, color: AppColors.pink, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        pricePerHour ?? '-',
                        style: const TextStyle(
                          color: AppColors.pink,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "/ jam",
                        style: TextStyle(
                          color: AppColors.dark,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Durasi Booking",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.purple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: TextEditingController(text: '1'),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      fillColor: AppColors.lightPink.withAlpha(36),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      hintText: "Masukkan durasi (jam)",
                      suffixText: "jam",
                    ),
                    onChanged: (value) {
                      final hours = int.tryParse(value) ?? 1;
                      setState(() {
                        durationHours = hours > 0 ? hours : 1;
                      });
                    },
                  ),
                ],
              ),

            const SizedBox(height: 24),
            // Pilih Tanggal
            Text(
              "Pilih Tanggal",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.purple,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightPink.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: AppColors.purple),
                    const SizedBox(width: 12),
                    Text(
                      selectedDate == null
                          ? "Pilih tanggal booking"
                          : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Pilih Jam
            Text(
              "Pilih Jam",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.purple,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickTime,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightPink.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: AppColors.purple),
                    const SizedBox(width: 12),
                    Text(
                      selectedTime == null
                          ? "Pilih jam booking"
                          : selectedTime!.format(context),
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 36),
            // Total Price Section
            if (selectedPS != null && durationHours > 0)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.lightPink.withAlpha(36),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedPS?.split(' - ')[0] ?? 'Pilih PlayStation',
                          style: TextStyle(
                            color: selectedPS == null
                                ? Colors.grey[400]
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (selectedPS != null && formattedPricePerHour != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            '$formattedPricePerHour / jam',
                            style: TextStyle(
                              color: AppColors.pink,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (selectedPS != null && totalPrice != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            totalPrice ?? '-',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: AppColors.pink,
                            ),
                          ),
                          Text(
                            '$durationHours ${durationHours > 1 ? 'jam' : 'jam'} × $formattedPricePerHour/jam',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      )
                    else
                      const Text(
                        'Pilih PS dulu',
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  ],
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
                onPressed: _confirmBooking,
                child: Text("Booking Sekarang"),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: 1,
        onTap: (int index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/profile');
          }
        },
      ),
    );
  }
}
