
class RegistrationModel {
  final String name;
  final String phone;
  final String email;
  final String password;

  RegistrationModel(
      {required this.name,
      required this.email,
      required this.password,
      required this.phone});

  factory RegistrationModel.fromJS({required Map json}) {
    return RegistrationModel(
        email: json['email'],
        name: json['name'],
        password: json['password'],
        phone: json['phone']);
  }
}
