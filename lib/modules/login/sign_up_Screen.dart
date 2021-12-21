import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/language/appLocalizations.dart';
import 'package:new_motel/models/requests.dart';
import 'package:new_motel/models/data.dart';
import 'package:new_motel/routes/route_names.dart';
import 'package:new_motel/utils/validator.dart';
import 'package:new_motel/widgets/common_appbar_view.dart';
import 'package:new_motel/widgets/common_button.dart';
import 'package:new_motel/widgets/common_text_field_view.dart';
import 'package:new_motel/widgets/remove_focuse.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _errorEmail = '';
  TextEditingController _emailController = TextEditingController();
  String _errorPhone = '';
  TextEditingController _phoneController = TextEditingController();
  String _errorFName = '';
  TextEditingController _fnameController = TextEditingController();
  String _errorLName = '';
  TextEditingController _lnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: RemoveFocuse(
          onClick: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _appBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      CommonTextFieldView(
                        controller: _fnameController,
                        errorText: _errorFName,
                        padding: const EdgeInsets.only(
                            bottom: 16, left: 24, right: 24),
                        titleText: AppLocalizations(context).of("first_name"),
                        hintText:
                            AppLocalizations(context).of("enter_first_name"),
                        keyboardType: TextInputType.name,
                        onChanged: (String txt) {},
                      ),
                      CommonTextFieldView(
                        controller: _lnameController,
                        errorText: _errorLName,
                        padding: const EdgeInsets.only(
                            bottom: 16, left: 24, right: 24),
                        titleText: AppLocalizations(context).of("last_name"),
                        hintText:
                            AppLocalizations(context).of("enter_last_name"),
                        keyboardType: TextInputType.name,
                        onChanged: (String txt) {},
                      ),
                      CommonTextFieldView(
                        controller: _emailController,
                        errorText: _errorEmail,
                        titleText: AppLocalizations(context).of("your_mail"),
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, bottom: 16),
                        hintText:
                            AppLocalizations(context).of("enter_your_email"),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (String txt) {},
                      ),
                      CommonTextFieldView(
                        titleText: AppLocalizations(context).of("phone"),
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, bottom: 24),
                        hintText: AppLocalizations(context).of('enter_your_phone'),
                        onChanged: (String txt) {},
                        errorText: _errorPhone,
                        controller: _phoneController,
                      ),
                      CommonButton(
                        padding:
                            EdgeInsets.only(left: 24, right: 24, bottom: 8),
                        buttonText: AppLocalizations(context).of("sign_up"),
                        onTap: () async {
                          if (_allValidation()) {
                            String r = await Requests.register(
                                _fnameController.text,
                                _lnameController.text,
                                _emailController.text,
                                _phoneController.text
                            );

                            if (r == null) {
                              NavigationServices(context).gotoSplashScreen();
                              return;
                            }

                            saveData(jsonDecode(r));

                            NavigationServices(context)
                                .gotoLoginScreen(); //NavigationServices(context).gotoSplashScreen();
                          }
                        }
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          AppLocalizations(context).of("terms_agreed"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            AppLocalizations(context)
                                .of("already_have_account"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            onTap: () {
                              NavigationServices(context).gotoLoginScreen();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                AppLocalizations(context).of("login"),
                                style: TextStyles(context)
                                    .getRegularStyle()
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryColor,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 24,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return CommonAppbarView(
      iconData: Icons.arrow_back,
      titleText: AppLocalizations(context).of("sign_up"),
      onBackClick: () {
        Navigator.pop(context);
      },
    );
  }

  bool _allValidation() {
    bool isValid = true;

    if (_fnameController.text.trim().isEmpty) {
      _errorFName = AppLocalizations(context).of('first_name_cannot_empty');
      isValid = false;
    } else {
      _errorFName = '';
    }

    if (_lnameController.text.trim().isEmpty) {
      _errorLName = AppLocalizations(context).of('last_name_cannot_empty');
      isValid = false;
    } else {
      _errorLName = '';
    }

    if (_emailController.text.trim().isEmpty) {
      _errorEmail = AppLocalizations(context).of('email_cannot_empty');
      isValid = false;
    } else if (!Validator.validateEmail(_emailController.text.trim())) {
      _errorEmail = AppLocalizations(context).of('enter_valid_email');
      isValid = false;
    } else {
      _errorEmail = '';
    }

    if (_phoneController.text.trim().isEmpty) {
      _errorPhone = AppLocalizations(context).of('phone_cannot_empty');
      isValid = false;
    } else {
      _errorPhone = '';
    }
    setState(() {});
    return isValid;
  }

  Future saveData(r) async {
    UserData userData = UserData();
    await userData.readJson();

    var data = jsonDecode(userData.json);

    data["user_data"]["salt"] = r["data"]["salt"];

    data["user_data"]["mail"]       = _emailController.text;
    data["user_data"]["phone"]      = _phoneController.text;
    data["user_data"]["first_name"] = _fnameController.text;
    data["user_data"]["last_name"]  = _lnameController.text;

    userData.json = jsonEncode(data);

    userData.saveJson();
  }
}