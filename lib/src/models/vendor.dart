class Vendor {
  final String vendorId;
  final String name;
  final String imageUrl;
  final String description;

  Vendor({this.description, this.imageUrl, this.name, this.vendorId});

  Map<String, dynamic> toMap() {
    return {
      'vendorId': vendorId,
      'imageUrl': imageUrl,
      'name': name,
      'description': description,
    };
  }

  factory Vendor.fromFirestore(Map<String, dynamic> firestore) {
    if (firestore == null) return null;
    return Vendor(
        vendorId: firestore['vendorId'],
        description: firestore['description'],
        name: firestore['name'],
        imageUrl: firestore['imageUrl']);
  }
}
