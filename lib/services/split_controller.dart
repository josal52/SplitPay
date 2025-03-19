import 'package:flutter/material.dart';
import 'package:splitpay/services/pdf_handler.dart';

class User {
  String name;
  double amountToPay = 0;

  User({required this.name});
}

class SplitController {
  static final SplitController _instance = SplitController._internal();

  factory SplitController() {
    return _instance;
  }

  SplitController._internal();

  final List<User> _userList = [];
  double _currentItemPrice = 69.70;
  String _currentItemName = 'Unable to get item name!';

  int splitState = 0; // 0 = none, 1 = 1/1
  int itemIterator = 0;

  List<User> get userList => _userList;
  double get currentItemPrice => _currentItemPrice;
  String get currentItemName => _currentItemName;

  void getCurrentItem() {
    double? price = pdfHandler.receiptList?[itemIterator].price;
    String? name = pdfHandler.receiptList?[itemIterator].name;
    if (price == null || name == null) return;
    _currentItemPrice = price;
    _currentItemName = name;
  }

  void getNextItem(BuildContext context) {
    itemIterator++;
    if (pdfHandler.receiptList != null &&
        itemIterator < pdfHandler.receiptList!.length) {
      getCurrentItem();
    } else {
      Navigator.pushNamed(context, '/end');
    }
  }

  void splitEven() {
    for (int i = 0; i < userList.length; i++) {
      userList[i].amountToPay += currentItemPrice / userList.length;
    }
  }

  void payFull(int index) {
    userList[index].amountToPay += currentItemPrice;
  }
}

SplitController splitController = SplitController();
