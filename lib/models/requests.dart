import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:new_motel/constants/api_urls.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Requests {
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
      return null;

    var json = jsonDecode(response.body);//utf8.decode(response.bodyBytes));

    if (json["status"] != "ok")
      return null;

    return jsonEncode(json);
  }

//before login
  static Future register(String name, String surname, String email, String phone) async {
    return await _send(
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
  }

  static Future login(String email, String password) async {
    return await _send(
      ApiUrls.user,
      {
        "user_json" : jsonEncode({
          "email" : email,
          "password" : password,
        })
      },
      RequestType.Post
    );
  }

  static Future passwordRecovery(String email) async {
    return await _send(
      ApiUrls.user,
      {
        "user_json" : jsonEncode({
          "email" : email
        })
      },
      RequestType.Post
    );
  }

  static Future autorise(String token, String salt, String email) async {
    return await _send(
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
  }


//after login
  static Future services(String token, String salt, String email) async {
    return await _send(
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
  }

  static Future orders(String token, String salt, String email) async {
    return await _send(
        ApiUrls.orders,
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
  }

  static Future service(String token, String salt, String email, List<Map> items, DateTime dateTime) async {
    return await _send(
      ApiUrls.service,
      {
        "user_json" : jsonEncode({
          "app_token" : token,
          "salt"      : salt,
          "email"     : email,
          "datetime"  : datetime(),
          "hash"      : hash(token, salt, email)
        }),
        "order_list"  : jsonEncode(items),
        "CheckInDate" : (dateTime.millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond).toString(),
      },
        // 1637443691
        // 16531212312

        // 1640780982
        // 1640780978

      RequestType.Get
    );
  }

  static Future verify(String token, String salt, String email, String id) async {
    return await _send(
        ApiUrls.verify,
        {
          "user_json" : jsonEncode({
            "app_token" : token,
            "salt"      : salt,
            "email"     : email,
            "datetime"  : datetime(),
            "hash"      : hash(token, salt, email)
          }),
          "id" : id,
        },
        RequestType.Get
    );
  }

//contacts
  static void phone() async {
    launch(ApiUrls.phone);
  }
  static void open(String url) async {
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