import 'package:json_annotation/json_annotation.dart';
// import 'education_model.dart';
part 'user_model.g.dart';
// part 'education_model.g.dart';

///
///
/// define a schema for your class and annotate
/// and then run
/// ```flutter pub run build_runner build ```
/// to watch the file changes and generate the outpur
/// ```flutter pub run build_runner watch ```
@JsonSerializable(nullable: false)
class UserModel {
  final Name name;
  final String gender;
  final String email;
  final Location location;
  final String phone;
  final Picture picture;

  UserModel(this.name, this.gender, this.email, this.location, this.phone,
      this.picture);

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable(nullable: false)
class Location {
  final Street street;
  final String city;
  final String state;
  final String country;
  final String postcode;

  Location(this.street, this.city, this.state, this.country, this.postcode);
  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

@JsonSerializable(nullable: false)
class Name {
  final String first;
  final String last;

  Name(this.first, this.last);

  factory Name.fromJson(Map<String, dynamic> json) => _$NameFromJson(json);
  Map<String, dynamic> toJson() => _$NameToJson(this);
}

@JsonSerializable(nullable: false)
class Street {
  final int number;
  final String name;

  Street(this.number, this.name);

  factory Street.fromJson(Map<String, dynamic> json) => _$StreetFromJson(json);
  Map<String, dynamic> toJson() => _$StreetToJson(this);
}

@JsonSerializable(nullable: false)
class Picture {
  final String large;
  final String medium;
  final String thumbnail;

  Picture(this.large, this.medium, this.thumbnail);

  factory Picture.fromJson(Map<String, dynamic> json) =>
      _$PictureFromJson(json);
  Map<String, dynamic> toJson() => _$PictureToJson(this);
}
