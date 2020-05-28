class NewsModel {
  String title;
  String text;
  String uuid;
  DateTime date;
  DateTime eventDate;

  NewsModel({
    this.title,
    this.text,
    this.uuid,
    this.date,
    this.eventDate,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        title: json["title"],
        text: json["text"],
        uuid: json["uuid"],
        date: DateTime.fromMillisecondsSinceEpoch(json["date"] * 1000),
        eventDate: json["event_date"] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json["event_date"] * 1000),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "text": text,
        "uuid": uuid,
        "date": date == null ? null : date.millisecondsSinceEpoch / 1000,
        "event_date": eventDate == null ? null : eventDate.millisecondsSinceEpoch / 1000,
      };
}
