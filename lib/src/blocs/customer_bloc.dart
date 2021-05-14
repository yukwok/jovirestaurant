import 'package:jovirestaurant/src/models/market.dart';
import 'package:jovirestaurant/src/models/product.dart';
import 'package:jovirestaurant/src/services/firestore_service.dart';

class CustomerBloc {
  //customer information
  final db = FirestoreService();

  Stream<List<Market>> get fetchUpcomingMarkets => db.fetchUpcomingMarkets();
  Stream<List<Product>> get fetchAvailableProducts =>
      db.fetchAvailableProducts();

  dispose() {}
}
