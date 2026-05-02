import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Saya"),
        backgroundColor: const Color(0xFFE91E63),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Foto profil
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/images/profile.png"),
            ),
            const SizedBox(height: 16),

            // Nama user
            const Text(
              "Sri",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Email user
            const Text(
              "sriy49063@gmail.com",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Info tambahan
            Card(
              child: ListTile(
                leading: const Icon(Icons.phone, color: Colors.pink),
                title: const Text("Nomor HP"),
                subtitle: const Text("+62 858-8212-7993"),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on, color: Colors.pink),
                title: const Text("Alamat"),
                subtitle: const Text("Pasar Kemis, Tangerang"),
              ),
            ),
            const SizedBox(height: 24),

            // Tombol edit profil
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63),
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Fitur edit profil belum tersedia")),
                );
              },
              child: const Text("Edit Profil"),
            ),
            const SizedBox(height: 12),

            // Tombol logout
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Logout berhasil")),
                );
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
