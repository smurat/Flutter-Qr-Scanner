import 'dart:convert';

List<UsersDataModel> usersDataModelFromJson(String str) =>
    List<UsersDataModel>.from(
        json.decode(str).map((x) => UsersDataModel.fromJson(x)));

String usersDataModelToJson(List<UsersDataModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UsersDataModel {
  UsersDataModel({
    this.id,
    this.index,
    this.guid,
    this.isActive,
    this.balance,
    this.picture,
    this.age,
    this.eyeColor,
    this.name,
    this.gender,
    this.company,
    this.email,
    this.phone,
    this.address,
    this.about,
    this.registered,
    this.latitude,
    this.longitude,
    this.tags,
    this.friends,
    this.greeting,
    this.favoriteFruit,
  });

  String id;
  int index;
  String guid;
  bool isActive;
  String balance;
  String picture;
  int age;
  String eyeColor;
  String name;
  String gender;
  String company;
  String email;
  String phone;
  String address;
  String about;
  String registered;
  double latitude;
  double longitude;
  List<String> tags;
  List<Friend> friends;
  String greeting;
  String favoriteFruit;

  factory UsersDataModel.fromJson(Map<String, dynamic> json) => UsersDataModel(
        id: json["_id"],
        index: json["index"],
        guid: json["guid"],
        isActive: json["isActive"],
        balance: json["balance"],
        picture: json["picture"],
        age: json["age"],
        eyeColor: json["eyeColor"],
        name: json["name"],
        gender: json["gender"],
        company: json["company"],
        email: json["email"],
        phone: json["phone"],
        address: json["address"],
        about: json["about"],
        registered: json["registered"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        tags: List<String>.from(json["tags"].map((x) => x)),
        friends:
            List<Friend>.from(json["friends"].map((x) => Friend.fromJson(x))),
        greeting: json["greeting"],
        favoriteFruit: json["favoriteFruit"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "index": index,
        "guid": guid,
        "isActive": isActive,
        "balance": balance,
        "picture": picture,
        "age": age,
        "eyeColor": eyeColor,
        "name": name,
        "gender": gender,
        "company": company,
        "email": email,
        "phone": phone,
        "address": address,
        "about": about,
        "registered": registered,
        "latitude": latitude,
        "longitude": longitude,
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "friends": List<dynamic>.from(friends.map((x) => x.toJson())),
        "greeting": greeting,
        "favoriteFruit": favoriteFruit,
      };
}

class Friend {
  Friend({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Friend.fromJson(Map<String, dynamic> json) => Friend(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
