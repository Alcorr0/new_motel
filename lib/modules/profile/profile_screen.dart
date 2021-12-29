import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/language/appLocalizations.dart';
import 'package:new_motel/logic/providers/theme_provider.dart';
import 'package:new_motel/models/data.dart';
import 'package:new_motel/routes/route_names.dart';
import 'package:provider/provider.dart';
import '../../models/setting_list_data.dart';

class ProfileScreen extends StatefulWidget {
  // final AnimationController animationController;

  // const ProfileScreen({Key? key, required this.animationController})
  //     : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<SettingsListData> userInfoList = [];

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  void getUserData() async {
    UserData userData = await new UserData();

    await userData.readJson();

    userInfoList = SettingsListData().getUserData(jsonDecode(userData.json));

    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Consumer<ThemeProvider>(
        builder: (context, provider, child) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Header
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[


                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: Container(
                    height: AppBar().preferredSize.height,
                    child: Row(
                      children: <Widget>[
                        //Back
                        SizedBox(
                          height: AppBar().preferredSize.height,
                          child: Padding(
                            padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                            child: Container(
                              width: AppBar().preferredSize.height - 8,
                              height: AppBar().preferredSize.height - 8,
                              child: Material(
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
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: AppTheme.primaryTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: SizedBox(),
                        ),

                        //Settings
                        SizedBox(
                          height: AppBar().preferredSize.height,
                          child: Padding(
                            padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                            child: Container(
                              width: AppBar().preferredSize.height - 8,
                              height: AppBar().preferredSize.height - 8,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(32.0),
                                  ),
                                  onTap: () {
                                    NavigationServices(context).gotoOrdersScreen();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.align_horizontal_left ,//assignment_outlined
                                      color: AppTheme.primaryTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        //Settings
                        SizedBox(
                          height: AppBar().preferredSize.height,
                          child: Padding(
                            padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                            child: Container(
                              width: AppBar().preferredSize.height - 8,
                              height: AppBar().preferredSize.height - 8,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(32.0),
                                  ),
                                  onTap: () {
                                    NavigationServices(context).gotoSettingsScreen();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.settings,//FontAwesomeIcons.cog
                                      color: AppTheme.primaryTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //Title
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 24, right: 24),
                  child: Text(
                    AppLocalizations(context).of("profile"),
                    style: TextStyles(context).getTitleStyle()
                  ),
                ),
              ],
            ),
            //User data
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(
                    bottom: 16 + MediaQuery.of(context).padding.bottom),
                itemCount: userInfoList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {},
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 8, right: 16),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, bottom: 16, top: 16),
                                  child: Text(
                                    AppLocalizations(context).of(userInfoList[index].titleTxt),
                                    style: TextStyles(context)
                                        .getDescriptionStyle()
                                        .copyWith(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 16.0, bottom: 16, top: 16),
                                child: Container(
                                  child: Text(
                                    userInfoList[index].subTxt,
                                    style: TextStyles(context)
                                        .getRegularStyle()
                                        .copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16),
                          child: Divider(
                            height: 1,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}
