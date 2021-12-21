import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:new_motel/constants/localfiles.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/language/appLocalizations.dart';
import 'package:new_motel/logic/providers/theme_provider.dart';
import 'package:new_motel/models/data.dart';
import 'package:new_motel/models/requests.dart';
import 'package:new_motel/routes/route_names.dart';
import 'package:new_motel/widgets/common_button.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoadText = false;
  bool isRegister = false;

  @override
  void initState() {
    _checkLogin();
    _getServices();

    WidgetsBinding.instance!.addPostFrameCallback((_) =>
        _loadAppLocalizations()); // call after first frame receiver so we have context
    super.initState();
  }

  Future<void> _loadAppLocalizations() async {
    try {
      //load all text json file to allLanguageTextData(in common file)
      //   await AppLocalizations.init(context);
      setState(() {
        isLoadText = true;
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeProvider>(context);
    return Container(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              foregroundDecoration: !appTheme.isLightMode
                  ? BoxDecoration(
                      color: Theme.of(context).backgroundColor.withOpacity(0.4))
                  : null,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(Localfiles.introduction, fit: BoxFit.cover),
            ),
            Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Theme.of(context).dividerColor,
                            offset: Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      child: Image.asset(Localfiles.appIcon),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Hotel Viva",
                  textAlign: TextAlign.left,
                  style: TextStyles(context).getBoldStyle().copyWith(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                ),
                SizedBox(
                  height: 8,
                ),
                AnimatedOpacity(
                  opacity: isLoadText ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 420),
                  child: Text(
                    AppLocalizations(context).of("best_hotel_deals"),
                    textAlign: TextAlign.left,
                    style: TextStyles(context).getRegularStyle().copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: SizedBox(),
                ),

                if (isRegister)
                  CommonButton(
                    padding:
                    const EdgeInsets.only(left: 48, right: 48, bottom: 8, top: 32),
                    buttonText: AppLocalizations(context).of("login"),
                    onTap: () {
                      NavigationServices(context).gotoLoginScreen();
                    },
                  ),
                CommonButton(
                  padding:
                  const EdgeInsets.only(left: 48, right: 48, bottom: 32, top: 8),
                  buttonText: AppLocalizations(context).of("create_account"),
                  backgroundColor: AppTheme.backgroundColor,
                  textColor: AppTheme.primaryTextColor,
                  onTap: () {
                    NavigationServices(context).gotoSignScreen();
                  }
                )
              ]
            )
          ]
        )
      )
    );
  }

  Future _checkLogin() async {
    UserData userData = UserData();
    await userData.readJson();

    var data = jsonDecode(userData.json);

    if (
      data["user_data"]["salt"]       != "" &&
      data["user_data"]["mail"]       != "" &&
      data["user_data"]["phone"]      != "" &&
      data["user_data"]["first_name"] != "" &&
      data["user_data"]["last_name"]  != ""
    )
      isRegister = true;
    else
      return;

    String r = await Requests.autorise(
        data["user_data"]["app_token"],
        data["user_data"]["salt"],
        data["user_data"]["mail"]
    );
    if (r == null)
      return;

    var userJson = jsonDecode(r)["data"][0]["user_json"];

    data["user_data"]["first_name"] = userJson["name"];
    data["user_data"]["last_name"]  = userJson["surname"];
    data["user_data"]["phone"]      = userJson["phone"];

    NavigationServices(context).gotoHotelDetailes();

    userData.json = jsonEncode(data);
    userData.saveJson();
  }
  Future _getServices() async {

    UserData userData = UserData();
    await userData.readJson();
    var uData = jsonDecode(userData.json);

    String r = await Requests.services(
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
}
