import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_tangerang/providers/cart_provider.dart';
import 'package:shopping_tangerang/core/models/product_model.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Keranjang"),
        backgroundColor: const Color(0xFFE91E63),
      ),
      body: cart.items.isEmpty
          ? const Center(
              child: Text(
                "Keranjang masih kosong",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, i) {
                final ProductModel product = cart.items[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Image.asset(product.assetImage, width: 50, height: 50),
                    title: Text(product.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Rp ${product.price.toInt()}"),
                        Text("Jumlah: ${product.stock}"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () {
                            if (product.stock > 1) {
                              cart.updateCartQuantity(product, product.stock - 1);
                            }
                          },
                        ),
                        Text("${product.stock}"),
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: Colors.green),
                          onPressed: () {
                            cart.updateCartQuantity(product, product.stock + 1);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () async {
                  await cart.checkoutCart();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Checkout berhasil, keranjang dikosongkan")),
                  );
                },
                child: const Text("Checkout"),
              ),
            ),
    );
  }
}
