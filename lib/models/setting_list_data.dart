import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsListData {
  String titleTxt;
  String subTxt;
  IconData iconData;
  bool isSelected;

  SettingsListData({
    this.titleTxt = '',
    this.isSelected = false,
    this.subTxt = '',
    this.iconData = Icons.supervised_user_circle,
  });

  List<SettingsListData> getCountryListFromJson(Map<String, dynamic> json) {
    List<SettingsListData> countryList = [];
    if (json["countryList"] != null) {
      json["countryList"].forEach((v) {
        SettingsListData data = SettingsListData();
        data.titleTxt = v["name"];
        data.subTxt = v["code"];
        countryList.add(data);
      });
    }
    return countryList;
  }

  List<SettingsListData> getUserData(Map<String, dynamic> json) {
    List<SettingsListData> userData = [];
    if (json["user_data"] != null) {
      json["user_data"].forEach((k, v) {
        bool isVisible = false;
        json["visible"].forEach((f) {
          if (f == k) {
            isVisible = true;
            return;
          }
        });

        if (isVisible) {
          SettingsListData data = SettingsListData();
          data.titleTxt = k;
          data.subTxt = v;
          userData.add(data);
        }
      });
    }
    return userData;
  }

  static List<SettingsListData> settingsList = [
    SettingsListData(
      titleTxt: 'Notifications',
      isSelected: false,
      iconData: FontAwesomeIcons.solidBell,
    ),
    SettingsListData(
      titleTxt: 'Theme Mode',
      isSelected: false,
      iconData: FontAwesomeIcons.skyatlas,
    ),
    SettingsListData(
      titleTxt: 'Fonts',
      isSelected: false,
      iconData: FontAwesomeIcons.font,
    ),
    SettingsListData(
      titleTxt: 'Color',
      isSelected: false,
      iconData: Icons.color_lens,
    ),
    SettingsListData(
      titleTxt: 'Language',
      isSelected: false,
      iconData: Icons.translate_outlined,
    )
  ];
}
