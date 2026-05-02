import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final int? id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String category;
  final String imageUrl;

  const ProductModel({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] ?? 0,
      category: json['category'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'category': category,
      'image_url': imageUrl,
    };
  }

  // 🔹 Mapping gambar dari assets sesuai kategori
  String get assetImage {
    final cat = category.toLowerCase();
    if (cat.contains('makanan')) {
      return 'assets/images/makanan_berat.png';
    } else if (cat.contains('minuman')) {
      return 'assets/images/minuman.png';
    } else if (cat.contains('dessert')) {
      return 'assets/images/dessert.png';
    } else if (cat.contains('snack')) {
      return 'assets/images/snack.png';
    } else {
      return 'assets/images/all.png';
    }
  }

  @override
  List<Object?> get props => [id, name, description, price, stock, category, imageUrl];
}
