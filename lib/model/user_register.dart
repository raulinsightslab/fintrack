import 'dart:convert';

class Userregist {
  final int? id;
  final String nama;
  final String email;
  final String password;
  Userregist({
    this.id,
    required this.nama,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nama': nama,
      'email': email,
      'password': password,
    };
  }

  factory Userregist.fromMap(Map<String, dynamic> map) {
    return Userregist(
      nama: map['nama'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      id: map['id'] as int,
    );
  }

  String toJson() => json.encode(toMap());
  factory Userregist.fromJson(String source) =>
      Userregist.fromMap(json.decode(source) as Map<String, dynamic>);
}
