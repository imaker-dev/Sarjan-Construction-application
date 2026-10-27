import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role;
  final List<String> permissions;

  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.permissions = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'permissions': permissions,
      };

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        role: json['role'] as String,
        permissions: (json['permissions'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
      );

  @override
  List<Object?> get props => [id, name, email, role];
}
