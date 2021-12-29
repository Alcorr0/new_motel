import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DishView extends StatefulWidget {
  final Map dishData;
  final AnimationController animationController;
  final Animation<double> animation;
  final VoidCallback onClick;

  const DishView({
    Key? key,
    required this.dishData,
    required this.animationController,
    required this.animation,
    required this.onClick
  }) : super(key: key);

  @override
  _DishViewState createState() => _DishViewState();
}

class _DishViewState extends State<DishView> {
  var pageController = PageController(initialPage: 0);
  bool isMoreDetails = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation,
          child: new Transform(
            transform: new Matrix4.translationValues(0.0, 40 * (1.0 - widget.animation.value), 0.0),
            child: Column(
              children: <Widget>[
                if (widget.dishData["picture"] != null)
                  kIsWeb ?
                  Image.asset(  //заглушка\
                    "assets/images/room_1.jpg",
                    fit: BoxFit.cover,
                  )
                  : CachedNetworkImage(
                    imageUrl: widget.dishData["picture"],
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
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.dishData["title"],
                            maxLines: 2,
                            textAlign: TextAlign.left,
                            style: TextStyles(context).getBoldStyle().copyWith(fontSize: 24),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(child: SizedBox()),
                          Material(
                            child: InkWell(
                              borderRadius: BorderRadius.all(
                                Radius.circular(32.0),
                              ),
                              highlightColor: AppTheme.primaryColor,
                              onTap: widget.onClick,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.add_shopping_cart_outlined),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "€${widget.dishData["price"]["value"]}",
                            textAlign: TextAlign.left,
                            style: TextStyles(context).getBoldStyle().copyWith(fontSize: 22),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    isMoreDetails ?
                                      "Less Details" : // T
                                      "More Details",
                                    style: TextStyles(context).getBoldStyle(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Icon(
                                      isMoreDetails ?
                                        Icons.keyboard_arrow_up :
                                        Icons.keyboard_arrow_down,
                                      size: 24,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                isMoreDetails = !isMoreDetails;
                              });
                            },
                          ),
                        ],
                      ),
                      if (isMoreDetails)
                        Padding(
                          padding : const EdgeInsets.only(left: 8, right: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  widget.dishData["description"],
                                  style: TextStyles(context).getDescriptionStyle(),
                                ),
                              ),
                            ],
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
}