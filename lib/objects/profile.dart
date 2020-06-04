class Profile {
  int id;
  String email;
  String name;
  String avatarUrl;
  int permissionsLevel; //permissions_level

  Profile({this.id, this.email, this.name, this.avatarUrl, this.permissionsLevel});

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
      id: json["id"],
      email: json["email"],
      name: json["name"],
      avatarUrl: json["avatar_path"],
      permissionsLevel: json["permissions_level"] ?? 0);

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "avatar_path": avatarUrl,
        "permissions_level": permissionsLevel
      };
}
