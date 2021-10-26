import 'package:Bustooth/models/base_model.dart';

class User extends BaseModel {
  final String? name;
  final String? uuid;
  final String? lastname;

  User({
    required this.name,
    required this.lastname,
    required this.uuid,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lastname': lastname,
      'uuid': uuid,
    };
  }

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      lastname: map['lastname'],
      uuid: map['uuid'],
    );
  }
}
