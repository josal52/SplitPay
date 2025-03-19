import 'package:file_picker/file_picker.dart';
import 'package:flutter_pdf_text/flutter_pdf_text.dart';

class Item {
  String name = 'placeholder';
  double price = 0.00;

  Item(this.name, this.price);
}

class PdfHandler {
  static final PdfHandler _instance = PdfHandler._internal();

  bool _receiptParsed = false;
  bool _receiptImported = false;
  PDFDoc? _pdfDoc;
  List<Item>? _receiptList;

  factory PdfHandler() {
    return _instance;
  }

  PdfHandler._internal();

  bool get receiptImported => _receiptImported;
  bool get receiptParsed => _receiptParsed;
  List<Item>? get receiptList => _receiptList;

  List<String>? getRelevantLines(List<String> receiptLines) {
    List<String> newReceiptLines = [];

    // Trims the unrelevant lines from the top of the receipt
    bool startFound = false;
    for (int i = 0; i < receiptLines.length; i++) {
      if (startFound) {
        newReceiptLines.add(receiptLines[i]);
      } else if (receiptLines[i][0] == 'K') {
        startFound = true;
        i++;
      }
    }
    if (!startFound) return null;

    receiptLines.clear();

    // Trims the unrelevant lines from the end of the receipt.
    for (int i = 0; i < newReceiptLines.length; i++) {
      if (newReceiptLines[i].contains('YHTEENSÄ')) {
        receiptLines.removeLast();
        break;
      } else {
        receiptLines.add(newReceiptLines[i]);
      }
    }

    newReceiptLines.clear();

    // Trims the rest of the unrelevant lines from the receipt.
    for (int i = 0; i < receiptLines.length; i++) {
      String secondLastChar = receiptLines[i][receiptLines[i].length - 2];
      if (int.tryParse(secondLastChar) != null) {
        newReceiptLines.add(receiptLines[i]);
      }
    }

    return newReceiptLines.isNotEmpty ? newReceiptLines : null;
  }

  List<Item>? parseLineToItem(List<String> receiptLines) {
    List<Item> itemList = [];

    for (int i = 0; i < receiptLines.length; i++) {
      String itemName;
      double itemPrice;
      bool isDiscount;

      if (receiptLines[i][receiptLines[i].length - 1] == '-') {
        isDiscount = true;
      } else {
        isDiscount = false;
      }

      for (int j = receiptLines[i].length - 2; i >= 0; j--) {
        if (receiptLines[i][j] == ' ') {
          String itemPriceString =
              receiptLines[i].substring(j + 1, receiptLines[i].length - 1);
          itemPriceString = itemPriceString.replaceFirst(RegExp(r','), '.');
          if (isDiscount) {
            itemPriceString = '-$itemPriceString';
          }
          itemPrice = double.parse(itemPriceString);

          itemName = receiptLines[i].substring(0, j);
          itemName = itemName.trimRight();

          itemList.add(Item(itemName, itemPrice));
          break;
        }
      }
    }

    return itemList.isNotEmpty ? itemList : null;
  }

  List<Item> applyDiscounts(List<Item> itemList) {
    for (int i = 1; i < itemList.length; i++) {
      if (itemList[i].price < 0) {
        if (itemList[i - 1].name[0] != ' ') {
          itemList[i - 1].price += itemList[i].price;
        } else {
          List<int> itemsToDiscount = [i - 1];
          for (int j = 2; j < i; j++) {
            if (itemList[i - j].name[0] == ' ') {
              itemsToDiscount.add(i - j);
            } else {
              break;
            }
          }
          double discountPerItem = itemList[i].price / itemsToDiscount.length;
          discountPerItem = double.parse(discountPerItem.toStringAsFixed(2));
          for (int k = 0; k < itemsToDiscount.length; k++) {
            itemList[itemsToDiscount[k]].price =
                itemList[itemsToDiscount[k]].price + discountPerItem;
          }
        }
        itemList.removeAt(i);
      }
    }

    return itemList;
  }

  List<Item> applyDeposit(List<Item> itemList) {
    List<int> depositLines = [];
    for (int i = 0; i < itemList.length; i++) {
      if (itemList[i].name.contains('pantti')) {
        depositLines.add(i);
      } else if (depositLines.isNotEmpty) {
        int numberOfDeposits = depositLines.length;
        for (int j = 0; j < numberOfDeposits; j++) {
          itemList[depositLines[j] - numberOfDeposits].price =
              itemList[depositLines[j] - numberOfDeposits].price +
                  itemList[depositLines[j]].price;
        }

        for (int j = 0; j < numberOfDeposits; j++) {
          itemList.removeAt(depositLines[0]);
          i--;
        }

        depositLines.clear();
      }
    }

    return itemList;
  }

  Future<int> importPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) return 1;

    String filePath = result.files.single.path as String;

    PDFDoc pdfDoc = await PDFDoc.fromPath(filePath);

    _pdfDoc = pdfDoc;
    _receiptImported = true;
    return 0;
  }

  Future<int> parsePDF() async {
    String? receipt = await _pdfDoc?.text;

    List<String>? receiptLines = receipt?.split('\n');

    if (receiptLines == null) return 1;

    receiptLines = getRelevantLines(receiptLines);
    if (receiptLines == null) return 1;

    List<Item>? itemList = parseLineToItem(receiptLines);
    if (itemList == null) return 1;

    _receiptList = applyDiscounts(itemList);

    _receiptList = applyDeposit(itemList);

    _receiptParsed = true;

    return 0;
  }
}

PdfHandler pdfHandler = PdfHandler();
