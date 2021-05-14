import 'package:flutter/material.dart';

class Product {
  final String productName;
  final String unitType;
  final double unitPrice;
  final int availableUnits;
  final String vendorId;
  final String productId;
  final String imageUrl;
  final bool approved;
  final String note;

  Product({
    @required this.approved,
    @required this.availableUnits,
    this.imageUrl = "",
    this.note = "",
    @required this.productId,
    @required this.productName,
    @required this.unitPrice,
    @required this.unitType,
    @required this.vendorId,
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'unitType': unitType,
      'unitPrice': unitPrice,
      'availableUnits': availableUnits,
      'vendorId': vendorId,
      'productId': productId,
      'imageUrl': imageUrl,
      'approved': approved,
      'note': note,
    };
  }

  Product.fromFirestore(Map<String, dynamic> firestoreData)
      : this.productName = firestoreData['productName'],
        this.unitType = firestoreData['unitType'],
        this.unitPrice = firestoreData['unitPrice'],
        this.availableUnits = firestoreData['availableUnits'],
        this.vendorId = firestoreData['vendorId'],
        this.productId = firestoreData['productId'],
        this.imageUrl = firestoreData['imageUrl'],
        this.approved = firestoreData['approved'],
        this.note = firestoreData['note'];


        
}
