import 'package:flutter/material.dart';

class Product {
  final String name;
  final double price;
  final int quantity;

  const Product(
      {@required this.name, @required this.price, @required this.quantity});
}
