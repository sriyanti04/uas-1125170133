import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/product_model.dart';

class ProductService {
  final Dio dio = Dio();

  Future<List<ProductModel>> fetchProducts() async {
    try {
      // Gunakan IP laptop kamu (untuk device fisik) atau 10.0.2.2 untuk emulator
      final response = await dio.get('http://10.82.248.122:8080/products');


      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        // Pastikan data di-decode kalau masih berupa String
        final body = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        // Ambil list produk dari key 'data'
        final List<dynamic> data = body['data'];

        // Konversi ke model
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil data produk (status: ${response.statusCode})');
      }
    } catch (e) {
      print('Error saat fetchProducts: $e');
      throw Exception('Error saat mengambil produk: $e');
    }
  }
}

