import 'package:splitpay/services/split_controller.dart';
import 'package:flutter/material.dart';

class UserCards extends StatefulWidget {
  final List<User> userList;

  const UserCards({Key? key, required this.userList});

  @override
  State<UserCards> createState() => _UserCardsState();
}

class _UserCardsState extends State<UserCards> {
  @override
  Widget build(BuildContext context) {
    return widget.userList.isNotEmpty
        ? SizedBox(
            height: 65,
            width: 400,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.userList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.userList.removeAt(index);
                          });
                        },
                        child: Card(
                            child: Center(
                                child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            widget.userList[index].name,
                            style: TextStyle(fontSize: 14),
                          ),
                        ))));
                  },
                )))
        : SizedBox(
            height: 0,
          );
  }
}

class UserPreview extends StatefulWidget {
  @override
  UserPreviewState createState() => UserPreviewState();
}

class UserPreviewState extends State {
  TextEditingController userAddFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          UserCards(userList: splitController.userList),
          SizedBox(
            height: 10,
          ),
          Container(
              margin: EdgeInsetsDirectional.symmetric(horizontal: 30),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: const Color.fromARGB(32, 0, 0, 0),
                    offset: Offset.zero,
                    blurRadius: 20,
                    spreadRadius: 0)
              ]),
              child: TextField(
                  controller: userAddFieldController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none),
                    filled: true,
                    prefixIcon: IconButton(
                        onPressed: () {
                          if (userAddFieldController.text.isNotEmpty) {
                            setState(() {
                              splitController.userList
                                  .add(User(name: userAddFieldController.text));
                              userAddFieldController.clear();
                            });
                          }
                        },
                        icon: Icon(Icons.add_box_outlined)),
                    fillColor: Colors.white,
                    hintText: 'Input username',
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.50),
                      fontSize: 14,
                    ),
                    contentPadding: EdgeInsets.all(0),
                  ))),
        ],
      ),
    );
  }
}
