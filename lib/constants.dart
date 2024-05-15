import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

get baseUrl => 'http://ec2-13-58-62-11.us-east-2.compute.amazonaws.com:80';
//get baseUrl => 'http://localhost:8081';


bool platformIsIos(BuildContext context) {
  return Theme.of(context).platform == TargetPlatform.iOS;
}

const String KEY_USERLOGIN = "userlogin";
const String KEY_USERPASSWORD = "passwordlogin";
const String KEY_USERID = "useridlogin";
const String KEY_EXPIRYDATE = "expirylogin";
const String KEY_EXPIRYTOKENDATE = "expirytoken";
const String KEY_TOKEN = "tokenlogin";
