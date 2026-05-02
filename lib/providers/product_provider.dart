import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_tangerang/core/models/product_model.dart';
import 'package:shopping_tangerang/core/services/product_service.dart';

enum ProductStatus { initial, loading, loaded, error }

class ProductProvider extends ChangeNotifier {
  final ProductService _service = ProductService();

  ProductStatus _status = ProductStatus.initial;
  List<ProductModel> _products = [];
  String? _error;

  ProductStatus get status => _status;
  List<ProductModel> get products => _products;
  String? get error => _error;

  Future<void> fetchProducts() async {
    _status = ProductStatus.loaded;
    notifyListeners();

    try {
      final List<ProductModel> data = await _service.fetchProducts();

      // ✅ kalau berhasil ambil data, update produk dan status
      _products = data;
      _status = ProductStatus.loaded;
      _error = null; // reset error
    } catch (e) {
      _error = e.toString();
      _status = ProductStatus.error;
    }

    notifyListeners(); // ✅ wajib supaya UI tahu ada perubahan
  }

  /// 🔹 Tambah produk baru ke backend
  Future<bool> addProduct(ProductModel product) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.82.248.122:8080/products'), // gunakan 10.0.2.2 kalau pakai emulator Android
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(product.toJson()), // langsung pakai toJson()
      );

      if (response.statusCode == 201) {
        await fetchProducts(); // refresh daftar produk
        return true;
      } else {
        _error = 'Gagal menambah produk: ${response.body}';
        _status = ProductStatus.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _status = ProductStatus.error;
      notifyListeners();
      return false;
    }
  }
}
