import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_motel/constants/helper.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/logic/providers/theme_provider.dart';
import 'package:new_motel/models/data.dart';
import 'package:new_motel/models/requests.dart';
import 'package:new_motel/widgets/common_appbar_view.dart';
import 'package:new_motel/widgets/common_card.dart';
import 'package:new_motel/widgets/remove_focuse.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with Helper {
  List orders = [];

  void initState() {
    super.initState();
    _getOrders().then((r) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, provider, child) {
      return Scaffold(
        body: RemoveFocuse(
          onClick: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CommonAppbarView(
                iconData: Icons.arrow_back,
                onBackClick: () {
                  Navigator.pop(context);
                },
                titleText: "Orders list", // L
              ),
              Expanded(
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
                                    "date",
                                    textAlign: TextAlign.left,
                                    style: TextStyles(context).getRegularStyle().copyWith(fontSize: 22),
                                  ),
                                ),
                                for (int index = 0; index < orders.length; index++)
                                  Container(
                                    height: 40,
                                    child: Center(
                                      child: Text(
                                        orders[index]["CheckInDate"],
                                        textAlign: TextAlign.left,
                                        style: TextStyles(context).getRegularStyle().copyWith(fontSize: 22),
                                      ),
                                    ),
                                  ),
                              ]
                            ),
                            Column(
                              children: [
                                for (int index = 0; index <= orders.length; index++)
                                  Container(
                                    child: Center(
                                      child: Container(
                                        width: 1,
                                        height: 35,
                                        color: Colors.grey.withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Column(
                              children: [
                                Center(
                                  child: Text(
                                    "status",
                                    textAlign: TextAlign.left,
                                    style: TextStyles(context).getRegularStyle().copyWith(fontSize: 22),
                                  ),
                                ),
                                for (int index = 0; index < orders.length; index++)
                                  Container(
                                    height: 40,
                                    child: Center(
                                      child: Text(
                                        orders[index]["status"],
                                        textAlign: TextAlign.left,
                                        style: TextStyles(context).getRegularStyle().copyWith(fontSize: 22),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Future _getOrders() async {
    UserData userData = UserData();
    await userData.readJson();
    var uData = jsonDecode(userData.json);

    print("123");

    String? r = await Requests.orders(
        uData["user_data"]["app_token"],
        uData["user_data"]["salt"],
        uData["user_data"]["mail"]
    );
    if (r == null)
      return;

    orders = jsonDecode(r)["data"]["order_list"];
  }
}
