import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/models/data.dart';
import 'package:new_motel/modules/hotel_detailes/room_book_view.dart';

class RoomBookingScreen extends StatefulWidget {
  @override
  _RoomBookingScreenState createState() => _RoomBookingScreenState();
}

class _RoomBookingScreenState extends State<RoomBookingScreen> with TickerProviderStateMixin {
  bool isBooking = false;
  List data = [];
  var busyparking;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: Duration(milliseconds: 2000), vsync: this);
    _getRomeList().then((r) {
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
                    curve: Interval(
                      (1 / count) * index,
                      1.0,
                      curve: Curves.fastOutSlowIn
                    )
                  )
                );
                animationController.forward();

                return RoomeBookView(
                  data: data[index],
                  animation: animation,
                  animationController: animationController,
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
                Hotel.hotel.titleTxt,
                style: TextStyles(context).getTitleStyle(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _getRomeList() async {
    HotelData hotelData = HotelData();
    await hotelData.readJson();
    var dat = jsonDecode(hotelData.json);

    busyparking = dat["busyparking"];
    dat = dat["services_list"];

    List<Map> list = [];

    for (int i = 0; i < dat.length; i++)
      if (dat[i]["id"].toString().contains("|"))
        list.add(dat[i]);

    if (list.length == 1) {
      isBooking = true;
      data = dat;
    } else {
      data = list;
    }
  }
}
