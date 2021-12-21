import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/models/data.dart';
import 'package:new_motel/modules/hotel_detailes/room_booking/time_date_view.dart';
import 'package:new_motel/widgets/common_button.dart';
import 'package:new_motel/widgets/common_card.dart';
import 'package:new_motel/widgets/remove_focuse.dart';

class RoomBookingForm extends StatefulWidget {
  final Item roomData;

  const RoomBookingForm({
    Key? key,
    required this.roomData
  })
  : super(key: key);

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
                        TimeDateView(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
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
                                        padding: const EdgeInsets.only(
                                            left: 8, top: 8, bottom: 8, right: 8),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              ch1
                                                  ? Icons.check_box
                                                  : Icons.check_box_outline_blank,
                                              color: ch1
                                                  ? Theme.of(context).primaryColor
                                                  : Colors.grey.withOpacity(0.6)
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            FittedBox(
                                              fit: BoxFit.cover,
                                              child: Text(
                                                "Early check-in"
                                              )
                                            )
                                          ]
                                        )
                                      )
                                    )
                                  )
                                ]
                              )
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                      onTap: () {
                                        setState(() {
                                          ch2 = !ch2;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8, top: 8, bottom: 8, right: 8),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              ch2
                                                  ? Icons.check_box
                                                  : Icons.check_box_outline_blank,
                                              color: ch2
                                                  ? Theme.of(context).primaryColor
                                                  : Colors.grey.withOpacity(0.6)
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            FittedBox(
                                              fit: BoxFit.cover,
                                              child: Text(
                                                "Late check-out"
                                              )
                                            )
                                          ]
                                        )
                                      )
                                    )
                                  )
                                ]
                              )
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


                              int sum = widget.roomData.sum;
                              List<Item> list = [widget.roomData];

                              if (ch1 || ch2) {
                                HotelData hotelData = HotelData();
                                await hotelData.readJson();
                                var hData = jsonDecode(hotelData.json);

                                Item early = Item.empty();
                                Item late = Item.empty();

                                for (var i in hData["services_list"]) {
                                  if (i["id"] == "OrderRano")
                                    early = Item.fromJson(i);
                                  if (i["id"] == "OrderPosdno")
                                    late = Item.fromJson(i);
                                }

                                if (ch1) {
                                  sum += early.sum;
                                  list.add(early);
                                }
                                if (ch2) {
                                  sum += late.sum;
                                  list.add(late);
                                }
                              }
                              String order = Item.listToJsonString(list);

                              print(order);
                              print(sum);


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
          );
        },
      ),
    );
  }
}
/*
  Widget allAccommodationUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
          const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            AppLocalizations(context).of("type of accommodation"),
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery
                    .of(context)
                    .size
                    .width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
            children: getAccomodationListUI(),
          ),
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }
}

  List<Widget> getAccomodationListUI() {
    List<Widget> noList = [];
    for (var i = 0; i < accomodationListData.length; i++) {
      final date = accomodationListData[i];
      noList.add(
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            onTap: () {
              setState(() {
                checkAppPosition(i);
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      AppLocalizations(context).of(date.titleTxt),
                      // style: TextStyle(color: Colors.white),
                    ),
                  ),
                  CupertinoSwitch(
                    activeColor: date.isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey.withOpacity(0.6),
                    onChanged: (value) {
                      setState(() {
                        checkAppPosition(i);
                      });
                    },
                    value: date.isSelected,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      if (i == 0) {
        noList.add(Divider(
          height: 1,
        ));
      }
    }
    return noList;
  }

  void checkAppPosition(int index) {
    if (index == 0) {
      if (accomodationListData[0].isSelected) {
        accomodationListData.forEach((d) {
          d.isSelected = false;
        });
      } else {
        accomodationListData.forEach((d) {
          d.isSelected = true;
        });
      }
    } else {
      accomodationListData[index].isSelected =
      !accomodationListData[index].isSelected;

      var count = 0;
      for (var i = 0; i < accomodationListData.length; i++) {
        if (i != 0) {
          var data = accomodationListData[i];
          if (data.isSelected) {
            count += 1;
          }
        }
      }

      if (count == accomodationListData.length - 1) {
        accomodationListData[0].isSelected = true;
      } else {
        accomodationListData[0].isSelected = false;
      }
    }
  }

  Widget distanceViewUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
          const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            AppLocalizations(context).of("distance from city"),
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        SliderView(
          distValue: distValue,
          onChnagedistValue: (value) {
            distValue = value;
          },
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget popularFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
          const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            AppLocalizations(context).of("popular filter"),
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
            children: getPList(),
          ),
        ),
        SizedBox(
          height: 8,
        )
      ],
    );
  }

  List<Widget> getPList() {
    List<Widget> noList = [];
    var cout = 0;
    final columCount = 2;
    for (var i = 0; i < popularFilterListData.length / columCount; i++) {
      List<Widget> listUI = [];
      for (var i = 0; i < columCount; i++) {
        try {
          final date = popularFilterListData[cout];
          listUI.add(
            Expanded(
              child: Row(
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      onTap: () {
                        setState(() {
                          date.isSelected = !date.isSelected;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, top: 8, bottom: 8, right: 0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              date.isSelected
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: date.isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.withOpacity(0.6),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            FittedBox(
                              fit: BoxFit.cover,
                              child: Text(
                                AppLocalizations(context).of(date.titleTxt),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
          cout += 1;
        } catch (e) {
        }
      }
      noList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: listUI,
      ));
    }
    return noList;
  }

  Widget priceBarFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            AppLocalizations(context).of("price_text"),
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        RangeSliderView(
          values: _values,
          onChnageRangeValues: (values) {
            _values = values;
          },
        ),
        SizedBox(
          height: 8,
        )
      ],
    );
  }
*/