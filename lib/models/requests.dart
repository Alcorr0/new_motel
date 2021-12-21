import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:new_motel/constants/api_urls.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Requests {
  static var result;

  static Future _send(String url, var body, RequestType requestType) async {
    var httpIO;
    if (!kIsWeb) {
      final ioc = new HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      httpIO = new IOClient(ioc);
    }

    var response;
    int i = url.indexOf('/');
    String root = url.substring(0, i);
    String path = url.substring(i, url.length);
    Uri uri;

    if (requestType == RequestType.Get) {
      uri = Uri.parse(Uri.https(root, path, body).toString());

      response = kIsWeb ?
        await http.get(uri) :
        await httpIO.get(uri);
    } else {
      uri = Uri.parse(Uri.https(root, path).toString());

      response = kIsWeb ?
        await http.post(uri, body : body) :
        await httpIO.post(uri, body : body);
    }

    print("request...");
    print(uri);
    print(body);
    print("response:");
    print(response.statusCode);
    print(response.body);
    print("-----");
    print("");

    if (response.statusCode != 200 || response.body == "")
      return;

    var json = jsonDecode(response.body);//utf8.decode(response.bodyBytes));

    if (json["status"] != "ok")
      return;

    result = jsonEncode(json);

    return response.statusCode;
  }

//before login
  static Future<String> register(String name, String surname, String email, String phone) async {
    await _send(
        ApiUrls.register,
        {
          "user_json": jsonEncode({
            "email" : email,
            "phone" : phone,
            "name" : name,
            "surname" : surname
          })
        },
        RequestType.Post
    );

    return result;
  }

  static Future<String> login(String email, String password) async {
    await _send(
      ApiUrls.user,
      {
        "user_json" : jsonEncode({
          "email" : email,
          "password" : password,
        })
      },
      RequestType.Post
    );

    return result;
  }

  static Future<String> passwordRecovery(String email) async {
    await _send(
        ApiUrls.user,
        {
          "user_json" : jsonEncode({
            "email" : email
          })
        },
        RequestType.Post
    );

    return result;
  }

  static Future<String> autorise(String token, String salt, String email) async {
    await _send(
      ApiUrls.user,
      {
        "user_json" : jsonEncode({
          "app_token" : token,
          "salt" : salt,
          "email" : email,
          "datetime" : datetime(),
          "hash" : hash(token, salt, email)
        })
      },
      RequestType.Get
    );

    return result;
  }


//after login
  static Future<String> services(String token, String salt, String email) async {
    await _send(
        ApiUrls.services,
        {
          "user_json" : jsonEncode({
            "app_token" : token,
            "salt" : salt,
            "email" : email,
            "datetime" : datetime(),
            "hash" : hash(token, salt, email)
          })
        },
        RequestType.Get
    );

    return result;
  }

  // Future<String> brn(String token, String salt, String email, List<Item> items) async {
  //
  //   Map data = {"order_list" : []};
  //   int sum = 0;
  //
  //   for (int i = 0; i < items.length; i++) {
  //     data["order_list"][i] = items[i].toJsonString();
  //     sum += items[i].sum;
  //   }
  //
  //   String orderList = jsonEncode(data["order_list"]);
  //
  //   await _send(
  //       ApiUrls.services,
  //       {
  //         "order_list" : orderList,
  //         "sum" : sum,
  //         "app_token" : token,
  //         "datetime" : datetime(),
  //         "hash" : hash(token, salt, email)
  //       },
  //       RequestType.Get
  //   );
  //
  //   return result;
  // }

//contacts
  static void phone() async {
    launch(ApiUrls.phone);
  }
  static void social(String url) async {
    launch(url);
  }


//hash
  static String hash(String token, String salt, String email) {
    return md5.convert(utf8.encode(
      token + "-" +
      salt  + "-" +
      email + "-" +
      salt  + "-" +
      datetime()
    )).toString();
  }
  static String datetime() {
    int secondsSinceEpoch = new DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond;
    return secondsSinceEpoch.toString();
  }
}

enum RequestType { Get, Post }