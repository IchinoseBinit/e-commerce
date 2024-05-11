import 'dart:convert';
import 'dart:io';

import 'package:e_commerce_app/screens/error_screen/error_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:e_commerce_app/shared_preferences.dart';

class ApiCalls {
  String? token;

  // The function fetches the products by calling the APIs
  // It takes the token stored in SharedPreferences then fetches the data
  Future<dynamic> fetchData({required url, context}) async {
    try {
      token = MySharedPreferences.sharedPreferences.getString('token');
      final response = await http.get(
          Uri.parse(
            url,
          ),
          headers: {
            'Authorization': 'Bearer $token',
            "Accept": "application/json",
            "content-type": "application/json"
          });
      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return null;
        }
        try {
          return json.decode(response.body);
        } catch (ex) {
          print((ex as HttpException).message);
        }
      }
      return response.statusCode;
    } catch (e) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => ErrorScreen(e, url)),
          (Route<dynamic> route) => true);
    }
  }

  postData(url, postData) async {
    print(json.encode(postData));
    token = MySharedPreferences.sharedPreferences.getString('token');
    final response = await http.post(
      Uri.parse(
        url,
      ),
      headers: {
        'Authorization': 'Bearer $token',
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: json.encode(postData),
    );
    print(response.statusCode);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 302) {
      print(response.body);

      try {
        return json.decode(response.body);
      } catch (ex) {
        print(ex);
        return {'success': 'True'};
      }
    }
  }

  postFormData(url, postData) async {
    token = MySharedPreferences.sharedPreferences.getString('token');
    final response = await http.post(
      Uri.parse(
        url,
      ),
      headers: {
        'Authorization': 'Bearer $token',
        "Accept": "multipart/form-data",
        "Content-type": "multipart/form-data"
      },
      body: json.encode(postData),
    );
    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    }
  }

  putData(url, putData) async {
    token = MySharedPreferences.sharedPreferences.getString('token');

    print(json.encode(putData));
    final response = await http.put(
      Uri.parse(
        url,
      ),
      headers: {
        'Authorization': 'Bearer $token',
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: json.encode(putData),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    }
    print(response.statusCode);
  }

  postDataWithNoToken(url, postData) async {
    print(json.encode(postData));
    print(url);

    final response = await http.post(
      Uri.parse(
        url,
      ),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: json.encode(postData),
    );
    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body.isEmpty) {
        return true;
      }
      return response.body;
    }
    return false;
  }
}
