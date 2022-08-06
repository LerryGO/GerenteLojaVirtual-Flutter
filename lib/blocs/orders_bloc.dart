// ignore_for_file: constant_identifier_names

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

enum SortCriteria { READY_FIRST, READY_LAST }

class OrdersBloc extends BlocBase {
  final _ordersController = BehaviorSubject<List>();

  final List<DocumentSnapshot> _orders = [];

   SortCriteria? _criteria;

  Stream<List> get outOrders => _ordersController.stream;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  OrdersBloc() {
    _addOrdersListener();
  }

  void _addOrdersListener() {
    _firestore.collection("orders").snapshots().listen((snapshot) {
      //snapshot.docChanges.forEach((change) {
      for (var change in snapshot.docChanges) {
        String oid = change.doc.id;

        switch (change.type) {
          case DocumentChangeType.added:
            _orders.add(change.doc);
            break;
          case DocumentChangeType.modified:
            _orders.removeWhere((order) => order.id == oid);
            _orders.add(change.doc);
            break;
          case DocumentChangeType.removed:
            _orders.removeWhere((order) => order.id == oid);
            break;
        }
      }
      _sort();
    });
  }

  void setOrderCriteria(SortCriteria criteria) {
    _criteria = criteria;
    _sort();
  }

  void _sort() {
    switch (_criteria) {
      case SortCriteria.READY_FIRST:
        _orders.sort((a, b) {
          int sa = a["status"];
          int sb = b["status"];

          if (sa < sb) {
            return 1;
          } else if (sa > sb) {
            return -1;
          } else {
            return 0;
          }
        });
        break;
      case SortCriteria.READY_LAST:
        _orders.sort((a, b) {
          int sa = a["status"];
          int sb = b["status"];

          if (sa > sb) {
            return 1;
          } else if (sa < sb) {
            return -1;
          } else {
            return 0;
          }
        });
        break;
      default:
        break;
    }

    _ordersController.add(_orders);
  }

  @override
  void dispose() {
    _ordersController.close();
    super.dispose();
  }
}
