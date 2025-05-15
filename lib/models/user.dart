import 'dart:convert';

class User {
  final String name;
  final String email;
  final int age;

  User({required this.name, required this.email, required this.age});

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'age': age,
      };

  String toXml() {
    return '''
<usuario>
  <nombre>${htmlEscape.convert(name)}</nombre>
  <correo>${htmlEscape.convert(email)}</correo>
  <edad>$age</edad>
</usuario>
''';
  }
}
