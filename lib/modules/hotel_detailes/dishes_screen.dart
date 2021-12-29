import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/models/data.dart';
import 'package:new_motel/widgets/common_button.dart';
import 'package:new_motel/widgets/common_card.dart';
import 'package:new_motel/widgets/remove_focuse.dart';

import 'dishes_view.dart';

class DishesScreen extends StatefulWidget {
  @override
  _DishesScreenScreenState createState() => _DishesScreenScreenState();
}

class _DishesScreenScreenState extends State<DishesScreen> with TickerProviderStateMixin {
  List data = [];
  List order = [];
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: Duration(milliseconds: 2000), vsync: this);
    _getDishesList().then((r) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          getAppBarUI(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(0.0),
              itemCount: data.length,
              itemBuilder: (context, index) {
                var count = data.length > 10 ? 10 : data.length;
                var animation = Tween(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: animationController,
                        curve: Interval((1 / count) * index, 1.0,
                            curve: Curves.fastOutSlowIn)));
                animationController.forward();

                return DishView(
                  dishData: data[index],
                  animation: animation,
                  animationController: animationController,
                  onClick : () {
                    int ci = -1;
                    for (int i = 0; i < order.length; i++)
                      if (order[i]["id"] == data[index]["id"]) {
                        ci = i;
                        break;
                      }

                    Map dish;
                    if (ci == -1) {
                      dish = data[index];
                      dish["count"] = 1;
                      order.add(dish);
                    } else {
                      order[ci]["count"] += 1;
                    }
                  }
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget getAppBarUI() {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: 16,
          right: 16,
          bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.all(
                Radius.circular(32.0),
              ),
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_back),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "Dishes", // L
                style: TextStyles(context).getTitleStyle(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Material(
            child: InkWell(
              borderRadius: BorderRadius.all(
                Radius.circular(32.0),
              ),
              highlightColor: AppTheme.primaryColor,
              onTap: () {
                _showCart();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.shopping_cart_outlined),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _getDishesList() async {
    HotelData hotelData = HotelData();
    await hotelData.readJson();
    data = jsonDecode(hotelData.json)["dishes_list"];
  }

  _showCart() {
    if (order.length != 0)
      showDialog(
        context: context,
        builder: (BuildContext context) => Scaffold(
          backgroundColor: Colors.transparent,
          body: AnimatedBuilder(
            animation: animationController,
            builder: (BuildContext context, Widget? child) {
              return AnimatedOpacity(
                duration: Duration(milliseconds: 100),
                opacity: animationController.value,
                child: RemoveFocuse(
                  onClick: () {
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: CommonCard(
                        color: AppTheme.backgroundColor,
                        radius: 24,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Center(
                                    child: Text(
                                      "sum",
                                      textAlign: TextAlign.left,
                                      style: TextStyles(context).getBoldStyle().copyWith(fontSize: 22),
                                    ),
                                  ),
                                  for (int index = 0; index < order.length; index++)
                                    Container(
                                      height: 40,
                                      child: Center(
                                        child: Text(
                                          "€${order[index]["price"]["value"]}",
                                          textAlign: TextAlign.left,
                                          style: TextStyles(context).getBoldStyle().copyWith(fontSize: 22),
                                        ),
                                      ),
                                    ),
                                ]
                              ),
                              Column(
                                children: [
                                  for (int index = 0; index <= order.length; index++)
                                    Center(
                                    child: Container(
                                      width: 1,
                                      height: 35,
                                      color: Colors.grey.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Center(
                                    child: Text(
                                      "title",
                                      textAlign: TextAlign.left,
                                      style: TextStyles(context).getBoldStyle().copyWith(fontSize: 22),
                                    ),
                                  ),
                                  for (int index = 0; index < order.length; index++)
                                    Container(
                                      height: 40,
                                      child: Center(
                                        child: Text(
                                          order[index]["title"],
                                          textAlign: TextAlign.left,
                                          style: TextStyles(context).getBoldStyle().copyWith(fontSize: 22),
                                        ),
                                      ),
                                    ),
                                ]
                              ),
                              Column(
                                children: [
                                  for (int index = 0; index <= order.length; index++)
                                    Center(
                                      child: Container(
                                        width: 1,
                                        height: 35,
                                        color: Colors.grey.withOpacity(0.8),
                                      ),
                                    ),
                                ],
                              ),
                              Column(
                                children: [
                                  Center(
                                    child: Text(
                                      "count",
                                      textAlign: TextAlign.left,
                                      style: TextStyles(context).getBoldStyle().copyWith(fontSize: 22),
                                    ),
                                  ),
                                  for (int index = 0; index < order.length; index++)
                                    Container(
                                      height: 40,
                                      child: Center(
                                        child: Text(
                                          order[index]["count"].toString(),
                                          textAlign: TextAlign.left,
                                          style: TextStyles(context).getBoldStyle().copyWith(fontSize: 22),
                                        ),
                                      ),
                                    ),
                                ]
                              ),
                              Column(
                                children: [
                                  for (int index = 0; index <= order.length; index++)
                                    Center(
                                      child: Container(
                                        width: 1,
                                        height: 35,
                                        color: Colors.grey.withOpacity(0.8),
                                      ),
                                    ),
                                ],
                              ),
                              Column(
                                children: [
                                  Center(
                                    child: Text(
                                      "remove",
                                      textAlign: TextAlign.left,
                                      style: TextStyles(context).getBoldStyle().copyWith(fontSize: 22),
                                    ),
                                  ),
                                  for (int index = 0; index < order.length; index++)
                                    Container(
                                      height: 40,
                                      child: InkWell(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(32.0),
                                        ),
                                        highlightColor: AppTheme.primaryColor,
                                        onTap: () {
                                          order.removeWhere((item) => item["id"] == order[index]["id"]);
                                          Navigator.pop(context);
                                          _showCart();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(Icons.remove_shopping_cart_outlined),
                                        ),
                                      ),
                                    ),
                                ]
                              ),

                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 16, top: 8
                                ),
                                child: CommonButton(
                                  buttonText: "Confirm",
                                  onTap: () async {



                                    Navigator.pop(context);
                                  },
                                ),
                              )
                            ]
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        )
      );
  }
}
