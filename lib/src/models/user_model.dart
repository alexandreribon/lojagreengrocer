import 'dart:convert';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? cpf;
  String? password;
  String? token;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.cpf,
    this.password,
    this.token,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'fullname': name});
    result.addAll({'email': email});
    result.addAll({'phone': phone});
    result.addAll({'cpf': cpf});
    result.addAll({'password': password});
    result.addAll({'token': token});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['fullname'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      cpf: map['cpf'] ?? '',
      password: map['password'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, phone: $phone, cpf: $cpf, token: $token)';
  }
}
