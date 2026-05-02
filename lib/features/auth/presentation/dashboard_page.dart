import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_tangerang/providers/product_provider.dart';
import 'package:shopping_tangerang/providers/cart_provider.dart';
import 'package:shopping_tangerang/core/models/product_model.dart';
import 'package:shopping_tangerang/features/auth/presentation/cart_page.dart';
import 'package:shopping_tangerang/features/auth/presentation/profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final filtered = _filteredProducts(provider.products);

    Widget body;
    if (provider.status == ProductStatus.loading ||
        provider.status == ProductStatus.initial) {
      body = const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFFE91E63)),
            SizedBox(height: 12),
            Text('Memuat produk...'),
          ],
        ),
      );
    } else if (provider.status == ProductStatus.error) {
      body = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(provider.error ?? 'Terjadi kesalahan'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63),
              ),
              onPressed: () => provider.fetchProducts(),
            ),
          ],
        ),
      );
    } else if (filtered.isEmpty) {
      body = const Center(
        child: Text(
          'Tidak ada produk untuk kategori ini',
          style: TextStyle(fontSize: 16),
        ),
      );
    } else {
      body = RefreshIndicator(
        color: const Color(0xFFE91E63),
        onRefresh: () => provider.fetchProducts(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _SearchBar(controller: _searchCtrl)),
            SliverToBoxAdapter(child: _BannerCard()),
            SliverToBoxAdapter(
              child: _CategoryRow(
                selected: _selectedCategory,
                onSelected: (c) => setState(() => _selectedCategory = c),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "For you",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _ProductCard(product: filtered[i]),
                childCount: filtered.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Produk'),
        backgroundColor: const Color(0xFFE91E63),
      ),
      body: body,
      bottomNavigationBar: const _BottomNav(),
    );
  }

  List<ProductModel> _filteredProducts(List<ProductModel> products) {
    final query = _searchCtrl.text.toLowerCase();
    return products.where((p) {
      final matchCategory = _selectedCategory == 'All' ||
          p.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchSearch = query.isEmpty ||
          p.name.toLowerCase().contains(query) ||
          p.category.toLowerCase().contains(query);
      return matchCategory && matchSearch;
    }).toList();
  }
}

// 🔹 Widget SearchBar
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Cari produk...',
          prefixIcon: const Icon(Icons.search, color: Color(0xFFE91E63)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

// 🔹 Widget BannerCard
class _BannerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE91E63), Color(0xFFF48FB1)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Promo Spesial Cafe!',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}

// 🔹 Widget CategoryRow
class _CategoryRow extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;
  const _CategoryRow({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Makanan Berat', 'Minuman', 'Dessert', 'Snack'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: categories.map((c) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ChoiceChip(
            label: Text(c),
            selected: selected == c,
            selectedColor: const Color(0xFFF8BBD0),
            onSelected: (_) => onSelected(c),
          ),
        )).toList(),
      ),
    );
  }
}

// 🔹 Widget ProductCard
class _ProductCard extends StatelessWidget {
  final ProductModel product;
  const _ProductCard({required this.product});

  String _formatPrice(double price) {
    final str = price.toInt().toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
      count++;
    }
    return 'Rp. ${buffer.toString().split('').reversed.join()}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.asset(product.assetImage, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              _formatPrice(product.price),
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              product.category,
              style: const TextStyle(fontSize: 11, color: Color(0xFFE91E63)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add_shopping_cart, size: 16),
              label: const Text("Add to Cart"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63),
                minimumSize: const Size(double.infinity, 36),
              ),
              onPressed: () async {
                final cartProvider =
                    Provider.of<CartProvider>(context, listen: false);

                cartProvider.addToCart(product);
                await cartProvider.saveCartToServer(product);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${product.name} ditambahkan ke keranjang")),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 🔹 Widget BottomNav (diperbaiki: tambahkan navigasi ke ProfilePage)
class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: const Color(0xFFE91E63),
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CartPage()),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfilePage()),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
      ],
    );
  }
}
