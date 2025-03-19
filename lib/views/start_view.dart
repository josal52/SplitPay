import 'package:splitpay/services/split_controller.dart';
import 'package:splitpay/models/user_preview.dart';
import 'package:splitpay/services/pdf_handler.dart';
import 'package:splitpay/models/receipt_preview.dart';
import 'package:flutter/material.dart';

class StartView extends StatefulWidget {
  const StartView({super.key});
  @override
  StartViewState createState() => StartViewState();
}

class StartViewState extends State {
  void showUserSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('No users added! Add users to proceed.'),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final receiptPreviewBox = SizedBox(
        width: 400,
        height: null,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 300),
          child:
              Scrollbar(child: SingleChildScrollView(child: ReceiptPreview())),
        ));

    final noReceiptText = Padding(
        padding: EdgeInsets.all(10), child: Text('No receipt imported'));

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: null,
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              )),
          centerTitle: true,
          backgroundColor: Colors.lightBlue,
          title: Text(
            'SplitPay',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
            color: Colors.grey,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UserPreview(),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Receipt Preview',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: PdfHandler().receiptImported
                          ? receiptPreviewBox
                          : noReceiptText),
                  SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await PdfHandler().importPdf();
                        await PdfHandler().parsePDF();
                        setState(() {});
                      },
                      child: Text('Import receipt')),
                  SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                      onPressed: PdfHandler().receiptParsed
                          ? () {
                              if (splitController.userList.length >= 2) {
                                Navigator.pushNamed(context, '/split');
                              } else {
                                showUserSnackBar(context);
                              }
                            }
                          : null,
                      child: Text('Split')),
                ],
              ),
            )));
  }
}
