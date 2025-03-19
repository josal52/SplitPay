import 'package:flutter/material.dart';
import 'package:splitpay/services/split_controller.dart';

class EndView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            width: 400,
            height: 100,
            child: Center(
                child: ListView.builder(
              shrinkWrap: true,
              itemCount: splitController.userList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
                  child: Card(
                    color: Colors.lightBlue,
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                splitController.userList[index].name,
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                '${(splitController.userList[index].amountToPay).toStringAsFixed(2)}€',
                                style: TextStyle(fontSize: 14),
                              )
                            ]),
                      ),
                    ),
                  ),
                );
              },
            )))
      ],
    ));
  }
}
