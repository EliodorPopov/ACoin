import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:acoin/data/database_helper.dart';
import 'package:acoin/Identity/User.dart';

class RestDatasource {
  DatabaseHelper _db = new DatabaseHelper();
  static final LOGIN_URL = "https://10.0.2.2:5696/Identity/Account/Login";
  String reqVerificationToken = '';
  String _cookie = '';

  Future<User> login(String username, String password) async {
    //Step 1: Get Antiforgery Tokens from Login Page
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest getCookiesRequest =
        await client.getUrl(Uri.parse(LOGIN_URL));
    HttpClientResponse getCookiesResponse = await getCookiesRequest.close();

    //Step 2: Extract verificationToken from body and from cookies
    var responseText = await getCookiesResponse.transform(utf8.decoder).join();
    reqVerificationToken = responseText.substring(responseText.indexOf(
            'name="__RequestVerificationToken" type="hidden" value="') +
        'name="__RequestVerificationToken" type="hidden" value="'.length);
    reqVerificationToken =
        reqVerificationToken.substring(0, reqVerificationToken.indexOf('"'));
    _cookie = getCookiesResponse.headers['set-cookie'][1];

    //Step 3: Send request for login to get permanent authToken
    HttpClient client2 = new HttpClient();
    client2.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest authentificateRequest =
        await client2.postUrl(Uri.parse(LOGIN_URL));
    authentificateRequest.headers
        .add("Content-Type", "application/x-www-form-urlencoded");
    authentificateRequest.headers.add("Cookie", _cookie);
    authentificateRequest.headers
        .add("RequestVerificationToken", reqVerificationToken);
    var body = "Input.Email=" +
        username +
        "&Input.Password=" +
        password +
        "&Input.RemeberMe=true";
    authentificateRequest.write(body);
    HttpClientResponse authentificateResponse =
        await authentificateRequest.close();

    //Step 4: Check if successful and create user
    if (authentificateResponse.headers == null) {
      return null;
    } else {
      try {
        String _authToken =
            authentificateResponse.headers['set-cookie'][0] + '; ' + _cookie;
        User user = new User(username, _authToken);
        await _db.saveUser(user);
        return user;
      } catch (e) {
        return null;
      }
    }
  }
}