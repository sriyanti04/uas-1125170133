import 'package:flutter/material.dart';
import 'package:shopping_tangerang/core/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartProvider with ChangeNotifier {
  final List<ProductModel> _items = [];

  List<ProductModel> get items => _items;

  void addToCart(ProductModel product) {
    _items.add(product);
    notifyListeners();
  }

  void removeFromCart(ProductModel product) {
    _items.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  /// 🔹 Simpan item ke backend Go
  Future<void> saveCartToServer(ProductModel product) async {
    final url = Uri.parse("http://10.82.248.122:8080/cart");

    final body = jsonEncode({
      "product_id": product.id,
      "quantity": 1,
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      debugPrint("Produk berhasil disimpan ke server");
    } else {
      debugPrint("Gagal simpan ke server: ${response.body}");
    }
  }

  /// 🔹 Ambil isi keranjang dari backend
  Future<void> fetchCartFromServer() async {
    final url = Uri.parse("http://10.82.248.122:8080/cart");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      _items.clear();
      for (var item in data["items"]) {
        _items.add(ProductModel(
          id: item["product_id"],
          name: item["product"]["name"],
          description: item["product"]["description"] ?? "",
          price: (item["product"]["price"] as num).toDouble(),
          stock: item["quantity"] ?? 1, // gunakan quantity dari backend
          category: item["product"]["category"],
          imageUrl: item["product"]["image_url"] ?? "assets/images/snack.png",
        ));
      }
      notifyListeners();
    } else {
      debugPrint("Gagal ambil keranjang: ${response.body}");
    }
  }

  /// 🔹 Update jumlah item di backend
  Future<void> updateCartQuantity(ProductModel product, int newQty) async {
    final url = Uri.parse("http://10.82.248.122:8080/cart/${product.id}");

    final body = jsonEncode({
      "product_id": product.id,
      "quantity": newQty,
    });

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      debugPrint("Quantity produk berhasil diupdate di server");

      // update di lokal juga
      final index = _items.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _items[index] = ProductModel(
          id: product.id,
          name: product.name,
          description: product.description,
          price: product.price,
          stock: newQty, // simpan quantity di field stock
          category: product.category,
          imageUrl: product.imageUrl,
        );
        notifyListeners();
      }
    } else {
      debugPrint("Gagal update quantity: ${response.body}");
    }
  }

  /// 🔹 Checkout: kirim semua isi keranjang ke backend
  Future<void> checkoutCart() async {
    final url = Uri.parse("http://10.82.248.122:8080/checkout");

    final body = jsonEncode({
      "items": _items.map((p) => {
        "product_id": p.id,
        "quantity": p.stock, // stock dipakai sebagai quantity
      }).toList(),
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      debugPrint("Checkout berhasil, keranjang dikirim ke server");
      clearCart(); // kosongkan keranjang lokal
    } else {
      debugPrint("Checkout gagal: ${response.body}");
    }
  }
}
