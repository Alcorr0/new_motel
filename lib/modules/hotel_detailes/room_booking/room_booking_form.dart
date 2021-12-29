import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_motel/common/common.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/models/data.dart';
import 'package:new_motel/models/requests.dart';
import 'package:new_motel/routes/route_names.dart';
import 'package:new_motel/widgets/common_button.dart';
import 'package:new_motel/widgets/common_card.dart';
import 'package:new_motel/widgets/remove_focuse.dart';
import 'package:new_motel/modules/hotel_detailes/room_book_view.dart' show Type;
import 'calendar_pop_up_view.dart';

class RoomBookingForm extends StatefulWidget {
  late Map data;
  late var type;
  late DateTime startDate;
  late DateTime endDate;
  late DateTime initStartDate;

  RoomBookingForm(data, type) {
    this.type = type;
    this.data = data;
    this.startDate = (type == Type.prolong) ? DateTime.parse(data["prolong"]) : DateTime.now();
    this.endDate   = this.startDate.add(Duration(days: 5));
    this.initStartDate = this.startDate;
  }

  @override
  _RoomBookingFormState createState() => _RoomBookingFormState();
}

class _RoomBookingFormState extends State<RoomBookingForm> with TickerProviderStateMixin {
  late AnimationController animationController;
  bool ch1 = false;
  bool ch2 = false;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // TimeDateView(),
                        if (widget.type != Type.business)
                          CalendarPopupView(
                            barrierDismissible: true,
                            isStaticStartDate: widget.type == Type.prolong,
                            minimumDate: widget.initStartDate,
                            maximumDate: widget.initStartDate.add(Duration(days: 30)),
                            initialEndDate: widget.endDate,
                            initialStartDate: widget.startDate,
                            onChangeClick: (DateTime startData,
                            DateTime endData) {
                              setState(() {
                                widget.startDate = startData;
                                widget.endDate = endData;
                              });
                            },
                          ),

                        if (widget.type == Type.book)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Row(
                                  children: <Widget>[
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                        onTap: () {
                                          setState(() {
                                            ch1 = !ch1;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets
                                              .only(
                                              left: 8,
                                              top: 8,
                                              bottom: 8,
                                              right: 8),
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                ch1 ?
                                                  Icons.check_box :
                                                  Icons.check_box_outline_blank,
                                                color: ch1 ?
                                                  Theme.of(context).primaryColor :
                                                  Colors.grey.withOpacity(0.6)
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              FittedBox(
                                                fit: BoxFit.cover,
                                                child: Text("Early check-in")
                                              )
                                            ]
                                          )
                                        )
                                      )
                                    )
                                  ]
                                )
                              ),
                              Container(
                                height: 1,
                                width: 10,
                                color: Colors.transparent,
                              ),
                              Center(
                                child: Row(
                                  children: <Widget>[
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius
                                            .all(
                                            Radius.circular(4.0)),
                                        onTap: () {
                                          setState(() {
                                            ch2 = !ch2;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets
                                              .only(
                                              left: 8,
                                              top: 8,
                                              bottom: 8,
                                              right: 8),
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                ch2 ?
                                                  Icons.check_box :
                                                  Icons.check_box_outline_blank,
                                                color: ch2 ?
                                                  Theme.of(context).primaryColor :
                                                  Colors.grey.withOpacity(0.6)
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              FittedBox(
                                                fit: BoxFit.cover,
                                                child: Text("Late check-out")
                                              )
                                            ]
                                          )
                                        )
                                      )
                                    )
                                  ]
                                )
                              )
                            ]
                          ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 16, top: 8
                          ),
                          child: CommonButton(
                            buttonText: "Confirm",
                            onTap: () async {
                              Map room = {
                                "title": widget.data["title"],
                                "type": widget.data["id"].substring(
                                    widget.data["id"].indexOf("|") + 1),
                                "quant": widget.endDate
                                    .difference(widget.startDate)
                                    .inDays
                              };

                              List<Map> list = [room];

                              if (ch1 || ch2) {
                                HotelData hotelData = HotelData();
                                await hotelData.readJson();
                                var hData = jsonDecode(hotelData.json);

                                Map early = {};
                                Map late = {};

                                for (var i in hData["services_list"]) {
                                  if (i["id"] == "OrderRano")
                                    early = {
                                      "title" : i["title"],
                                      "type"  : "OrderRano",
                                      "quant" : 1
                                    };
                                  if (i["id"] == "OrderPosdno")
                                    late = {
                                      "title" : i["title"],
                                      "type"  : "OrderPosdno",
                                      "quant" : 1
                                    };
                                }

                                if (ch1)
                                  list.add(early);
                                if (ch2)
                                  list.add(late);
                              }

                              await _send(list);

                              Navigator.pop(context);
                              NavigationServices(context).gotoHotelDetailes();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _send(List<Map> order) async {
    UserData userData = UserData();
    await userData.readJson();
    var uData = jsonDecode(userData.json);

    String? r = await Requests.service(
        uData["user_data"]["app_token"],
        uData["user_data"]["salt"],
        uData["user_data"]["mail"],
        order,
        widget.startDate
    );
    if (r == null)
      return;
    var data = jsonDecode(r)["data"];

    HotelData hotelData = HotelData();
    await hotelData.readJson();
    var hData = jsonDecode(hotelData.json);

    hData["current_order"]["id"] = data["orderid"];
    hData["current_order"]["status"] = "verification";

    hotelData.json = jsonEncode(hData);
    hotelData.saveJson();

    Requests.open(data["payurl"]);

    Function _startVeryfying = () async {
      HotelData hotelData = HotelData();
      await hotelData.readJson();
      var hData = jsonDecode(hotelData.json);

      hData["current_order"]["id"] = data["orderid"];
      hData["current_order"]["status"] = "verification";

      hotelData.json = jsonEncode(hData);
      hotelData.saveJson();

      for (int i = 0; i < 30; i++) { // 5 minutes, 10 sec
        await Future.delayed(const Duration(milliseconds: 10000));
        var re = await Requests.verify(
            uData["user_data"]["app_token"],
            uData["user_data"]["salt"],
            uData["user_data"]["mail"],
            data["orderid"]
        );
        if (re != null) {
          showVerify(true);

          hData["current_order"]["status"] = "success";
          hotelData.json = jsonEncode(hData);
          hotelData.saveJson();

          _getServices();

          return;
        }
      }
      showVerify(false);

      hData["current_order"]["status"] = "fail";
      hotelData.json = jsonEncode(hData);
      hotelData.saveJson();
    };

    _startVeryfying();
  }
}
showVerify(bool isSuccess) async {
  showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: RemoveFocuse(
          onClick: () {
            Navigator.pop(context);
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: CommonCard(
                color: AppTheme.backgroundColor,
                radius: 24,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 16, top: 8
                        ),
                        child: Center(
                            child:Text(
                                isSuccess ?
                                "Successful payment!" : // L
                                "Payment failed!"
                            )
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16, top: 8
                      ),
                      child: CommonButton(
                        buttonText: "Ok",
                        onTap: () async {
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      )
  );
}
Future _getServices() async {
  UserData userData = UserData();
  await userData.readJson();
  var uData = jsonDecode(userData.json);

  String? r = await Requests.services(
      uData["user_data"]["app_token"],
      uData["user_data"]["salt"],
      uData["user_data"]["mail"]
  );
  if (r == null)
    return;
  var hotelJson = jsonDecode(r)["data"];

  HotelData hotelData = HotelData();
  await hotelData.readJson();
  var hData = jsonDecode(hotelData.json);

  hData["services_list"] = hotelJson["services_list"];
  hData["busyparking"] = hotelJson["busyparking"];
  hData["dishes_list"] = hotelJson["dishes_list"];

  hotelData.json = jsonEncode(hData);
  hotelData.saveJson();
}