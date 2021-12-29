import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/language/appLocalizations.dart';
import 'package:new_motel/modules/hotel_detailes/room_booking/room_booking_form.dart';
import 'package:new_motel/widgets/common_button.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class RoomeBookView extends StatefulWidget {
  final Map data;
  final AnimationController animationController;
  final Animation<double> animation;

  const RoomeBookView({
    Key? key,
    required this.data,
    required this.animationController,
    required this.animation
  })
  : super(key: key);

  @override
  _RoomeBookViewState createState() => _RoomeBookViewState();
}

class _RoomeBookViewState extends State<RoomeBookView> {
  var pageController = PageController(initialPage: 0);
  var type = Type.book;

  @override
  Widget build(BuildContext context) {
    // List<String> images = widget.roomData.imagePath.split(" ");

    if (widget.data["title"] == null) {
      widget.data["title"] = "Renew booking";
      type = Type.prolong;
    } else if (widget.data["id"] == "parking") {
      type = Type.parking;
    } else if (widget.data["id"] == "clean") {
      type = Type.clean;
    }

    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation,
          child: new Transform(
            transform: new Matrix4.translationValues(0.0, 40 * (1.0 - widget.animation.value), 0.0),
            child: Column(
              children: <Widget>[
                if (widget.data["foto"] != null)
                  kIsWeb ?
                    Image.asset(  //заглушка
                      "assets/images/room_1.jpg",
                      fit: BoxFit.cover,
                    )
                    : CachedNetworkImage(
                      imageUrl: widget.data["foto"],
                      fit: BoxFit.cover,
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          Center(
                            child: SizedBox(
                              width: 40.0,
                              height: 40.0,
                              child: new CircularProgressIndicator(value: downloadProgress.progress),
                            ),
                          ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, bottom: 16, top: 16),
                  child: Column(
                    children: <Widget>[
                      if (type != Type.clean)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                widget.data["title"].substring(widget.data["title"].indexOf(' - ') == -1 ? 0 : widget.data["title"].indexOf(' - ') + 3),
                                maxLines: 2,
                                textAlign: TextAlign.left,
                                style: TextStyles(context)
                                    .getBoldStyle()
                                    .copyWith(fontSize: 24),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      if (type != Type.clean)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "€${widget.data["sum"]}",
                              textAlign: TextAlign.left,
                              style: TextStyles(context).getBoldStyle().copyWith(fontSize: 22)//, fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0),
                              child: Text(
                                (type == Type.parking) ?
                                  "/per day" :
                                  "/per night", //L
                                style: TextStyles(context).getRegularStyle().copyWith(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      SizedBox(
                        height: 38,
                        child: CommonButton(
                          buttonTextWidget: Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, top: 4, bottom: 4
                            ),
                            child: Text(
                              (type == Type.clean) ?
                                widget.data["title"] :
                                AppLocalizations(context).of("book_now"),
                              textAlign: TextAlign.center,
                              style: TextStyles(context).getRegularStyle(),
                            ),
                          ),
                          onTap: () {
                            _showPopUp();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPopUp() {//Navigator.push(context, route).then(onGoBack);
    showDialog(
      context: context,
      builder: (BuildContext context) => RoomBookingForm(widget.data, type)//DateTime.parse(widget.roomData["prolong"]
    );
  }
}
enum Type {
  book,
  prolong,
  parking,
  business,
  clean
}