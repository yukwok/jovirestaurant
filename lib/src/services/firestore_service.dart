import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jovirestaurant/src/models/application_user.dart';
import 'package:jovirestaurant/src/models/market.dart';
import 'package:jovirestaurant/src/models/product.dart';
import 'package:jovirestaurant/src/models/vendor.dart';
// import 'package:jovirestaurant/src/screens/vendor.dart';

class FirestoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addUser(ApplicationUser user) {
    // test the connection //
    _db
        .collection('dummycollection')
        .doc('dummyId')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
      } else {
        print('Document does not exist on the database');
      }
    });

    return _db.collection('users').doc(user.userId).set(user.toMap());
  }

  Future<ApplicationUser> fetchUser(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .get()
        .then((snapshot) => ApplicationUser.fromFirestore(snapshot.data()));
  }

  //
  Stream<List<String>> fetchUnitTypes() {
    print('fetchUnitTypes:${_db.collection('types').toString()}');

    return _db
        .collection('types')
        .doc('units')
        .snapshots() //stream of one document
        .map((snapshot) => snapshot
            .data()['production']
            .map<String>((type) => type.toString())
            .toList());
  }

  Future<void> setProduct(Product product) {
    // print('Product details:');
    // print('product.approved. ${product.approved}');
    // print('product.availableUnits ${product.availableUnits}');
    // print('product.imageUrl ${product.imageUrl}');
    // print('product.note ${product.note}');
    // print('product.productId ${product.productId}');
    // print('product.productName ${product.productName}');
    // print('product.unitPrice ${product.unitPrice}');
    // print('product.unitType ${product.unitType}');
    // print('product.vendorId ${product.vendorId}');
    // print('- end -');
    //
    var options = SetOptions(merge: true);

    return _db
        .collection('products')
        .doc(product.productId)
        // .set(product.toMap(), options);
        .set(product.toMap(), options);
  }

  Future<Product> fetchProduct(String productId) {
    return _db
        .collection('products')
        .doc(productId)
        .get()
        .then((snapshot) => Product.fromFirestore(snapshot.data()));
  }

  Stream<List<Product>> fetchProductByVendorId(String vendorId) {
    return _db //////  need to study the map.map.amp.where.snapshot.....
        .collection('products')
        .where('vendorId', isEqualTo: vendorId)
        .snapshots()
        .map((query) => query.docs)
        .map((snapshot) => snapshot
            .map((document) => Product.fromFirestore(document.data()))
            .toList());
  }

  Stream<List<Market>> fetchUpcomingMarkets() {
    return _db //////  need to study the map.map.amp.where.snapshot.....
        .collection('markets')
        .where('dateEnd', isGreaterThan: DateTime.now().toIso8601String())
        .snapshots()
        .map((query) => query.docs)
        .map((snapshot) => snapshot
            .map((document) => Market.fromFirestore(document.data()))
            .toList());
  }

  Stream<List<Product>> fetchAvailableProducts() {
    return _db
        .collection('products')
        .where('availableUnits', isGreaterThan: 0)
        .snapshots()
        .map((query) => query.docs)
        .map((snapshot) => snapshot
            .map((document) => Product.fromFirestore(document.data()))
            .toList());
  }

  Future<Vendor> fetchVendor(String vendorId) {
    return _db
        .collection('users')
        .doc(vendorId)
        .get()
        .then((snapshot) => Vendor.fromFirestore(snapshot.data()));
  }

  Future<void> setVendor(Vendor vendor) {
    var options = SetOptions(merge: true);
    return _db
        .collection('vendors')
        .doc(vendor.vendorId)
        .set(vendor.toMap(), options);
  }
}
