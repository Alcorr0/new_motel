import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/models/data.dart';
import 'package:new_motel/modules/hotel_detailes/room_book_view.dart';

class RoomBookingScreen extends StatefulWidget {
  final String hotelName;

  const RoomBookingScreen({Key? key, required this.hotelName})
      : super(key: key);
  @override
  _RoomBookingScreenState createState() => _RoomBookingScreenState();
}

class _RoomBookingScreenState extends State<RoomBookingScreen> with TickerProviderStateMixin {
  List<Map> romeList = [];
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
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
              itemCount: romeList.length,
              itemBuilder: (context, index) {
                var count = romeList.length > 10 ? 10 : romeList.length;
                var animation = Tween(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: animationController,
                        curve: Interval((1 / count) * index, 1.0,
                            curve: Curves.fastOutSlowIn)));
                animationController.forward();
                //room book view and room data
                return RoomeBookView(
                  roomData: romeList[index],
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
                widget.hotelName,
                style: TextStyles(context).getTitleStyle(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.all(
                Radius.circular(32.0),
              ),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.favorite_border),
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
    var data = jsonDecode(hotelData.json)["services_list"];

    for (int i = 0; i < data.length; i++)
      if (data[i]["id"].contains("|"))
        romeList.add(data[i]);
  }
}
