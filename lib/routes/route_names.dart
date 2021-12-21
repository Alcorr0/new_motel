import 'package:flutter/material.dart';
import 'package:new_motel/modules/hotel_detailes/hotel_detailes.dart';
import 'package:new_motel/modules/hotel_detailes/room_booking_screen.dart';
import 'package:new_motel/modules/login/forgot_password.dart';
import 'package:new_motel/modules/login/login_screen.dart';
import 'package:new_motel/modules/login/sign_up_Screen.dart';
import 'package:new_motel/modules/profile/profile_screen.dart';
import 'package:new_motel/modules/profile/settings_screen.dart';
import 'package:new_motel/routes/routes.dart';

class NavigationServices {
  NavigationServices(this.context);

  final BuildContext context;

  Future<dynamic> _pushMaterialPageRoute(Widget widget,
      {bool fullscreenDialog: false}) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => widget, fullscreenDialog: fullscreenDialog),
    );
  }

  void gotoSplashScreen() {
    Navigator.pushNamedAndRemoveUntil(
        context, RoutesName.Splash, (Route<dynamic> route) => false);
  }

  Future<dynamic> gotoLoginScreen() async {
    return await _pushMaterialPageRoute(LoginScreen());
  }

  Future<dynamic> gotoSignScreen() async {
    return await _pushMaterialPageRoute(SignUpScreen());
  }

  Future<dynamic> gotoForgotPassword() async {
    return await _pushMaterialPageRoute(ForgotPasswordScreen());
  }

  Future<dynamic> gotoHotelDetailes() async {
    return await _pushMaterialPageRoute(HotelDetailes());
  }

  Future<dynamic> gotoRoomBookingScreen(String hotelname) async {
    return await _pushMaterialPageRoute(
        RoomBookingScreen(hotelName: hotelname));
  }

  Future<dynamic> gotoProfileScreen() async {
    return await _pushMaterialPageRoute(ProfileScreen());
  }

  Future<dynamic> gotoSettingsScreen() async {
    return await _pushMaterialPageRoute(SettingsScreen());
  }

//   void gotoHotelDetailesPage(String hotelname) async {
//     await _pushMaterialPageRoute(HotelDetailes(hotelName: hotelname));
//   }
}
