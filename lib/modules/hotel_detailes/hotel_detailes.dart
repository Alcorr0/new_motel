import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_motel/constants/api_urls.dart';
import 'package:new_motel/constants/localfiles.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/language/appLocalizations.dart';
import 'package:new_motel/models/data.dart';
import 'package:new_motel/models/requests.dart';
import 'package:new_motel/modules/hotel_detailes/rating_view.dart';
import 'package:new_motel/routes/route_names.dart';
import 'package:new_motel/widgets/common_button.dart';
import 'package:new_motel/widgets/common_card.dart';

class HotelDetailes extends StatefulWidget {
  final Hotel hotel = Hotel.hotel;

  @override
  _HotelDetailesState createState() => _HotelDetailesState();
}

class _HotelDetailesState extends State<HotelDetailes>
    with TickerProviderStateMixin {
  ScrollController scrollController = ScrollController(initialScrollOffset: 0);
  var hoteltext1 =
      "We invite you to enjoy our hotel «VIVA». Set in the heart of Kharkov, the hotel «VIVA» is ideal for business or pleasure. We are located at 10/2 Gagarina Avenue (only 15 minutes to the airport and 5 minutes to the main railroad station).";
  var hoteltext2 =
      "The Hotel «Viva» offers delicate European and traditional cuisine. Start the day off right with a complimentary hot breakfast buffet and fragrant coffee, while browsing through the daily newspaper, fresh off the press. Relax in our pleasant atmosphere while either meeting with your colleagues or just simple having a dinner.";
  bool isReadless = false;
  late AnimationController animationController;
  var imageHieght = 0.0;
  late AnimationController _animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    _animationController =
        AnimationController(duration: Duration(milliseconds: 0), vsync: this);
    animationController.forward();
    scrollController.addListener(() {
      if (mounted) {
        if (scrollController.offset < 0) {
          // we static set the just below half scrolling values
          _animationController.animateTo(0.0);
        } else if (scrollController.offset > 0.0 &&
            scrollController.offset < imageHieght) {
          // we need around half scrolling values
          if (scrollController.offset < ((imageHieght / 1.2))) {
            _animationController
                .animateTo((scrollController.offset / imageHieght));
          } else {
            // we static set the just above half scrolling values "around == 0.22"
            _animationController.animateTo((imageHieght / 1.2) / imageHieght);
          }
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    imageHieght = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },

      child: Scaffold(
        body: Stack(
          children: <Widget>[
            CommonCard(
              radius: 0,
              color: AppTheme.scaffoldBackgroundColor,
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.only(top: 24 + imageHieght),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    // Hotel title and animation view
                    child: getHotelDetails(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Divider(
                      height: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            AppLocalizations(context).of("summary"),
                            style: TextStyles(context).getBoldStyle().copyWith(
                                  fontSize: 14,
                                  letterSpacing: 0.5,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 24, right: 24, top: 4, bottom: 8),
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: !isReadless ? hoteltext1.substring(0, 21) : hoteltext1,
                            style: TextStyles(context)
                                .getDescriptionStyle()
                                .copyWith(
                                  fontSize: 14,
                                ),
                            recognizer: new TapGestureRecognizer()..onTap = () {},
                          ),
                          TextSpan(
                            text: !isReadless
                                ? AppLocalizations(context).of("read_more")
                                : AppLocalizations(context).of("less"),
                            style: TextStyles(context).getRegularStyle().copyWith(
                                color: AppTheme.primaryColor, fontSize: 14),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                setState(() {
                                  isReadless = !isReadless;
                                });
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 8,
                      bottom: 16,
                    ),
                    // overall rating view
                    child: RatingView(hotel: widget.hotel),
                  ),

                  SizedBox(
                    height: 16,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1.5,
                        child: Image.asset(
                          Localfiles.mapImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 34, right: 10),
                        child: CommonCard(
                          color: AppTheme.primaryColor,
                          radius: 36,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              FontAwesomeIcons.mapPin,
                              color: Theme.of(context).backgroundColor,
                              size: 28,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, bottom: 16, top: 16),
                    child: CommonButton(
                      buttonText: AppLocalizations(context).of("book_now"),
                      onTap: () {
                        NavigationServices(context).gotoRoomBookingScreen();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Hotel VIVA: Cafe-Bar", // L
                            style: TextStyles(context).getBoldStyle().copyWith(
                              fontSize: 14,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.only(left: 24, right: 24, top: 4, bottom: 8),
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: !isReadless ? hoteltext2.substring(0, 32) : hoteltext2,
                            style: TextStyles(context)
                                .getDescriptionStyle()
                                .copyWith(
                              fontSize: 14,
                            ),
                            recognizer: new TapGestureRecognizer()..onTap = () {},
                          ),
                          TextSpan(
                            text: !isReadless
                                ? AppLocalizations(context).of("read_more")
                                : AppLocalizations(context).of("less"),
                            style: TextStyles(context).getRegularStyle().copyWith(
                                color: AppTheme.primaryColor, fontSize: 14),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                setState(() {
                                  isReadless = !isReadless;
                                });
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1.5,
                        child: Image.asset(
                          Localfiles.barImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      top: 16
                    ),
                    child: CommonButton(
                      buttonText: "Cafe-Bar", //L
                      onTap: () {
                        NavigationServices(context).gotoDishesScreen();
                      }
                    ),
                  ),

                  SizedBox(
                    height: 32,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      top: 16
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            AppLocalizations(context).of("contact_us"),
                            style: TextStyles(context).getBoldStyle().copyWith(
                              fontSize: 14,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
                    child: Container(
                      height: AppBar().preferredSize.height,
                      child: _getContactButtons(
                        AppTheme.backgroundColor,
                        AppTheme.primaryColor
                      )
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom,
                  ),
                ],
              ),
            ),

            _backgroundImageUI(widget.hotel),

            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Container(
                height: AppBar().preferredSize.height,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(),
                    ),

                    _getButton(
                      AppTheme.backgroundColor,
                      FontAwesomeIcons.user,
                      AppTheme.primaryColor,
                      () {
                        NavigationServices(context).gotoProfileScreen();
                      }
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  Widget _getContactButtons(Color color, Color iconcolor) {
    return Container(
      height: AppBar().preferredSize.height,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 2, right: 2),
            child: _getButton(
              color,
              FontAwesomeIcons.facebook,
              iconcolor,
              () {
                Requests.open(ApiUrls.facebook);
              }
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 2, right: 2),
            child: _getButton(
              color,
              FontAwesomeIcons.viber,
              iconcolor,
              () {
                Requests.open(ApiUrls.viber);
              }
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 2, right: 2),
            child: _getButton(
              color,
              FontAwesomeIcons.telegram,
              iconcolor,
              () {
                Requests.open(ApiUrls.telegram);
              }
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 2, right: 2),
            child: RichText(
              text: TextSpan(
                text:
                  ApiUrls.contact_phone.substring(0, 3) +
                  "(" +
                  ApiUrls.contact_phone.substring(3, 6) +
                  ")" +
                  ApiUrls.contact_phone.substring(6, 9) +
                  "-" +
                  ApiUrls.contact_phone.substring(9, 11) +
                  "-" +
                  ApiUrls.contact_phone.substring(11),
                recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Requests.phone();
                },
                style: TextStyles(context).getBoldStyle().copyWith(
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getButton(Color color, IconData icon, Color iconcolor, VoidCallback onTap) {
    return SizedBox(
      height: AppBar().preferredSize.height,
      child: Container(
        width: AppBar().preferredSize.height - 8,
        height: AppBar().preferredSize.height - 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.all(
              Radius.circular(32.0),
            ),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(icon, color: iconcolor),
            ),
          ),
        ),
      ),
    );
  }

  Widget _backgroundImageUI(Hotel hotel) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? child) {
          var opecity = 1.0 -
              (_animationController.value >= ((imageHieght / 1.2) / imageHieght)
                  ? 1.0
                  : _animationController.value);
          return SizedBox(
            height: imageHieght * (1.0 - _animationController.value),
            child: Stack(
              children: <Widget>[
                IgnorePointer(
                  child: Container(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          top: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child:

                            // Image.network(
                            //   "http://via.placeholder.com/350x150",
                            // ),

                            // CachedNetworkImage(
                            //   imageUrl: "http://via.placeholder.com/350x150",
                            //   progressIndicatorBuilder: (context, url, downloadProgress) =>
                            //       CircularProgressIndicator(value: downloadProgress.progress),
                            //   // errorWidget: (context, url, error) => Icon(Icons.error),
                            // ),

                            Image.asset(
                              hotel.imagePath,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: opecity,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 24, right: 24),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                            child: new BackdropFilter(
                              filter: new ImageFilter.blur(
                                  sigmaX: 10.0, sigmaY: 10.0),
                              child: Container(
                                color: Colors.black12,
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 16, top: 8),
                                      child: getHotelDetails(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        bottom: 16,
                                        top: 16
                                      ),
                                      child: CommonButton(
                                        buttonText: AppLocalizations(context).of("book_now"),
                                        onTap: () {
                                          NavigationServices(context).gotoRoomBookingScreen();
                                        }
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget getHotelDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.hotel.titleTxt,
                textAlign: TextAlign.left,
                style: TextStyles(context).getBoldStyle().copyWith(
                  fontSize: 22,
                  color: AppTheme.fontcolor
                )
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              "€${widget.hotel.perNight}",
              textAlign: TextAlign.left,
              style: TextStyles(context).getBoldStyle().copyWith(
                fontSize: 22,
                color: Theme.of(context).textTheme.bodyText1!.color
              ),
            ),
            Text(
              AppLocalizations(context).of("per_night"),
              style: TextStyles(context).getRegularStyle().copyWith(
                fontSize: 14,
                color:Theme.of(context).disabledColor
              ),
            ),
          ],
        ),
      ],
    );
  }
}
