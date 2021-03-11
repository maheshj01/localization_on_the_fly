// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    Name.fromJson(json['name'] as Map<String, dynamic>),
    json['gender'] as String,
    json['email'] as String,
    Location.fromJson(json['location'] as Map<String, dynamic>),
    json['phone'] as String,
    Picture.fromJson(json['picture'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'name': instance.name,
      'gender': instance.gender,
      'email': instance.email,
      'location': instance.location,
      'phone': instance.phone,
      'picture': instance.picture,
    };

Location _$LocationFromJson(Map<String, dynamic> json) {
  return Location(
    Street.fromJson(json['street'] as Map<String, dynamic>),
    json['city'] as String,
    json['state'] as String,
    json['country'] as String,
    json['postcode'].toString(),
  );
}

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'street': instance.street,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'postcode': instance.postcode,
    };

Name _$NameFromJson(Map<String, dynamic> json) {
  return Name(
    json['first'] as String,
    json['last'] as String,
  );
}

Map<String, dynamic> _$NameToJson(Name instance) => <String, dynamic>{
      'first': instance.first,
      'last': instance.last,
    };

Street _$StreetFromJson(Map<String, dynamic> json) {
  return Street(
    json['number'] as int,
    json['name'] as String,
  );
}

Map<String, dynamic> _$StreetToJson(Street instance) => <String, dynamic>{
      'number': instance.number,
      'name': instance.name,
    };

Picture _$PictureFromJson(Map<String, dynamic> json) {
  return Picture(
    json['large'] as String,
    json['medium'] as String,
    json['thumbnail'] as String,
  );
}

Map<String, dynamic> _$PictureToJson(Picture instance) => <String, dynamic>{
      'large': instance.large,
      'medium': instance.medium,
      'thumbnail': instance.thumbnail,
    };
