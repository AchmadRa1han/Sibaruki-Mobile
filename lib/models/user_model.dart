class UserModel {
  final int id;
  final String username;
  final String roleName;
  final String roleScope;

  UserModel({
    required this.id,
    required this.username,
    required this.roleName,
    required this.roleScope,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      roleName: json['role_name'],
      roleScope: json['role_scope'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'role_name': roleName,
      'role_scope': roleScope,
    };
  }
}

class AuthResponse {
  final bool status;
  final String message;
  final String? token;
  final UserModel? user;
  final String? expiresAt;

  AuthResponse({
    required this.status,
    required this.message,
    this.token,
    this.user,
    this.expiresAt,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      status: json['status'],
      message: json['message'],
      token: json['data']?['token'],
      user: json['data']?['user'] != null 
          ? UserModel.fromJson(json['data']['user']) 
          : null,
      expiresAt: json['data']?['expires_at'],
    );
  }
}
