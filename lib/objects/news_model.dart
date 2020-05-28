import 'package:flutter/material.dart';

class NewsModel {
  String title;
  String text;
  String uuid;
  DateTime eventDate;

  NewsModel({@required this.title, @required this.text, @required this.uuid, this.eventDate});
}
