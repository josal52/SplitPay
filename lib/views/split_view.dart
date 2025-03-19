import 'package:splitpay/services/split_controller.dart';
import 'package:flutter/material.dart';

class UserCards extends StatelessWidget {
  final VoidCallback onItemUpdate;

  final List<User> userList;

  const UserCards(
      {Key? key, required this.onItemUpdate, required this.userList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 400,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: userList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    if (splitController.splitState == 1) {
                      splitController.splitState = 0;
                      splitController.payFull(index);
                      onItemUpdate();
                    }
                  },
                  child: Padding(
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
                                  userList[index].name,
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  '${(userList[index].amountToPay).toStringAsFixed(2)}€',
                                  style: TextStyle(fontSize: 14),
                                )
                              ]),
                        ),
                      ),
                    ),
                  ));
            },
          ),
        ),
      ),
    );
  }
}

class SplitView extends StatefulWidget {
  const SplitView({super.key});
  @override
  SplitViewState createState() => SplitViewState();
}

class SplitViewState extends State {
  void updateNewItem() {
    setState(() {
      splitController.getNextItem(context);
    });
  }

  @override
  void initState() {
    super.initState();
    splitController.getCurrentItem();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        title: Text(
          'SplitPay',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 60,
              width: 400,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(
                  child: Text(
                    splitController.currentItemName,
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 100,
              width: 100,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(
                  child: Text(
                    '${(splitController.currentItemPrice).toStringAsFixed(2)}€',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            UserCards(
                onItemUpdate: updateNewItem,
                userList: splitController.userList),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                      onPressed: () => splitController.splitState = 1,
                      child: Text('1/1'),
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          splitController.splitEven();
                          splitController.getNextItem(context);
                        });
                      },
                      child: Text('1/${splitController.userList.length}'),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
