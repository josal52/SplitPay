import 'package:splitpay/services/pdf_handler.dart';
import 'package:flutter/material.dart';

class ReceiptPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Item> receiptList = PdfHandler().receiptList as List<Item>;

    return Column(
        children: receiptList.map((item) {
      return Text('${item.name}, ${(item.price).toStringAsFixed(2)}€');
    }).toList());
  }
}
