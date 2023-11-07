class TokenModel {
  int? exp;
  String? id;
  String? email;
  String? session_id;

  TokenModel(
      {required this.email,
      required this.exp,
      required this.id,
      required this.session_id});

  factory TokenModel.fromJson({required json}) {
    return TokenModel(
        email: json["email"],
        exp: json["exp"],
        id: json["sub"],
        session_id: json["session_id"]);
  }
}
