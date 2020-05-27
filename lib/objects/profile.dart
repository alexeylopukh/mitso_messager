class Profile {
  int id;
  String email;
  String name;
  String avatarUrl;

  Profile({this.id, this.email, this.name, this.avatarUrl});

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        email: json["email"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
      };
}
