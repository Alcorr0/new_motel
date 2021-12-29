import 'dart:convert';
import 'dart:ui';
import 'package:new_motel/constants/localfiles.dart';
import 'package:new_motel/models/room_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Hotel {
  String imagePath;
  String titleTxt;
  String subTxt;
  DateText? date;
  String dateTxt;
  String roomSizeTxt;
  RoomData? roomData;
  double dist;
  double rating;
  int reviews;
  int perNight;
  bool isSelected;
  Offset? screenMapPin; // we used this screen Offset for adding on Map layer

  Hotel({
    this.imagePath = '',
    this.titleTxt = '',
    this.subTxt = "",
    this.dateTxt = "",
    this.roomSizeTxt = "",
    this.roomData,
    this.dist = 1.8,
    this.reviews = 80,
    this.rating = 4.5,
    this.perNight = 180,
    this.isSelected = false,
    this.date,
    this.screenMapPin,
  });

  static Hotel hotel =
  Hotel(
    imagePath: Localfiles.hotel_1,
    titleTxt: 'Hotel Viva',
    subTxt: 'Kharkiv',
    dist: 2.0,
    reviews: 80,
    rating: 4.4,
    perNight: 43,
    roomData: RoomData(1, 2),
    isSelected: true,
    date: DateText(1, 5),
  );
}

class UserData {
  String name = "user";
  String json = "";
  String defaultJson = jsonEncode({
    "user_data" : {
      "first_name" : "",
      "last_name"  : "",
      "mail"       : "", //sashaalex2002@ukr.net
      "phone"      : "",
      "salt"       : "", //61ae2400d199461ae2400d1995
      "app_token"  : ""  //8bb5b2a60c61b1b114506551400352
    },

    // 61ae2400d1992
    // sashaalex2002@ukr.net

    // 61ca3fe667367
    // nogibiv879@zherben.com

    "visible" : [
      "first_name",
      "last_name",
      "mail",
      "phone",
    ]
  });

  Future saveJson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String data = json;

    print("write user:");
    print(data);
    print("");

    await prefs.setString(name, data);
  }
  Future readJson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String data = (prefs.getString(name) ?? defaultJson);

    print("read user:");
    print(data);
    print("");

    json = data;
  }
}

class HotelData {
  String name = "hotel";
  String json = "";
  String defaultJson = jsonEncode({
    "services_list" : [],
    "busyparking" : null,
    "dishes_list" : [],
    "current_order" : {
      "id" : "",
      "status" : ""
    }
  });

  Future saveJson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String data = json;

    // print("write hotel:");
    // print(data);

    await prefs.setString(name, data);
  }
  Future readJson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String data = (prefs.getString(name) ?? defaultJson);

    // print("read hotel:");
    // print(data);

    json = data;
  }
}
// "services_list":
// [
//   {"id":"standard|1" ,"sum":43,   "foto":"https://hotel-viva.com.ua/sites/default/files/styles/quicktabs_images/public/standart.jpg","title":"1321 грн/сутки - Стандарт, одноместное проживание"},
//   {"id":"standard|2" ,"sum":52,   "foto":"https://hotel-viva.com.ua/sites/default/files/styles/quicktabs_images/public/standart.jpg","title":"1596 грн/сутки - Стандарт, двухместное проживание"},
//   {"id":"improved|1" ,"sum":49,   "foto":"https://hotel-viva.com.ua/sites/default/files/styles/quicktabs_images/public/si6.jpg",     "title":"1511 грн/сутки - Стандарт улучш., одноместное проживание"},
//   {"id":"improved|2" ,"sum":58,   "foto":"https://hotel-viva.com.ua/sites/default/files/styles/quicktabs_images/public/si6.jpg",     "title":"1786 грн/сутки - Стандарт улучш., двухместное проживание"},
//   {"id":"improved|3" ,"sum":67,   "foto":"https://hotel-viva.com.ua/sites/default/files/styles/quicktabs_images/public/si6.jpg",     "title":"2062 грн/сутки - Стандарт улучш., трехместное проживание"},
//   {"id":"suite|3"    ,"sum":79,   "foto":"https://hotel-viva.com.ua/sites/default/files/styles/quicktabs_images/public/lyuks_1.jpg", "title":"2442 грн/сутки - Люкс, трехместное проживание"},
//   {"id":"suite|4"    ,"sum":88,   "foto":"https://hotel-viva.com.ua/sites/default/files/styles/quicktabs_images/public/lyuks_1.jpg", "title":"2717 грн/сутки - Люкс, четырехместное проживание"},
//   {"id":"superior|1" ,"sum":71,   "foto":"https://hotel-viva.com.ua/sites/default/files/styles/quicktabs_images/public/deluxe2.jpg", "title":"2176 грн/сутки - Люкс улучш., одноместное проживание"},
//   {"id":"superior|2" ,"sum":80,   "foto":"https://hotel-viva.com.ua/sites/default/files/styles/quicktabs_images/public/deluxe2.jpg", "title":"2451 грн/сутки - Люкс улучш., двухместное проживание"},
//   {"id":"superior|3" ,"sum":89,   "foto":"https://hotel-viva.com.ua/sites/default/files/styles/quicktabs_images/public/deluxe2.jpg", "title":"2727 грн/сутки - Люкс улучш., четырехместное проживание"},
//   {"id":"superior|4" ,"sum":98,   "foto":"https://hotel-viva.com.ua/sites/default/files/styles/quicktabs_images/public/deluxe2.jpg", "title":"3002 грн/добу -  Люкс улучш., трехместное проживание"},
//   {"id":"OrderRano"  ,"sum":16,   "foto":"",                                                                                         "title":"490 грн, если у Вас ранний заезд (с 7:00 до 11:00), дополнительно оплата"},
//   {"id":"OrderPosdno","sum":16,   "foto":"",                                                                                         "title":"490 грн, если у Вас поздний выезд (с 13:00 до 17:00), дополнительно оплата"},
//   {"id":"parking"    ,"sum":"100",                                                                                                   "title":"Parking 1 place per day"},
//   {"id":"clean"      ,"sum":0,                                                                                                       "title":"Room service"}
// ],
// "busyparking":null,
// "dishes_list":
// [
//   {"id":"dish-245","title":"Test dish","price":{"value":"21"},"picture":"https://hotel-viva.com.ua/sites/default/files/styles/large/public/maxresdefault.jpg?itok=zUpldgEt","description":null},
//   {"id":"dish-246","title":"Test Dish 1","price":{"value":"100"},"picture":"https://hotel-viva.com.ua/sites/default/files/styles/large/public/maxresdefault_0.jpg?itok=Rmcux6cH","description":null}
// ]