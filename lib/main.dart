// import 'dart:convert';
// import 'dart:html' as html;

// import 'package:flutter/material.dart';

// void main() => runApp(UserApp());

// class User {
//   final String name;
//   final String email;
//   final int age;

//   User({required this.name, required this.email, required this.age});

//   Map<String, dynamic> toJson() => {
//         'name': name,
//         'email': email,
//         'age': age,
//       };

//   String toXml() {
//     return '''
// <usuario>
//   <nombre>${htmlEscape.convert(name)}</nombre>
//   <correo>${htmlEscape.convert(email)}</correo>
//   <edad>$age</edad>
// </usuario>
// ''';
//   }
// }

// class UserApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Gestión de Usuarios',
//       home: UserFormPage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class UserFormPage extends StatefulWidget {
//   @override
//   _UserFormPageState createState() => _UserFormPageState();
// }

// class _UserFormPageState extends State<UserFormPage> {
//   final _formKey = GlobalKey<FormState>();
//   final List<User> _users = [];

//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _ageController = TextEditingController();

//   String _output = '';

//   void _addUser() {
//     if (_formKey.currentState!.validate()) {
//       final user = User(
//         name: _nameController.text.trim(),
//         email: _emailController.text.trim(),
//         age: int.parse(_ageController.text.trim()),
//       );
//       setState(() {
//         _users.add(user);
//         _nameController.clear();
//         _emailController.clear();
//         _ageController.clear();
//       });
//     }
//   }

//   void _generateJSON() {
//     final jsonOutput = jsonEncode(_users.map((u) => u.toJson()).toList());
//     setState(() {
//       _output = JsonEncoder.withIndent('  ').convert(json.decode(jsonOutput));
//     });
//     _downloadFile('usuarios.json', _output, 'application/json');
//   }

//   void _generateXML() {
//     final xmlOutput = '<?xml version="1.0" encoding="UTF-8"?>\n<usuarios>\n' +
//         _users.map((u) => u.toXml()).join('\n') +
//         '\n</usuarios>';
//     setState(() {
//       _output = xmlOutput;
//     });
//     _downloadFile('usuarios.xml', _output, 'application/xml');
//   }

//   void _downloadFile(String filename, String content, String type) {
//     final blob = html.Blob([content], type);
//     final url = html.Url.createObjectUrlFromBlob(blob);
//     final anchor = html.AnchorElement(href: url)
//       ..setAttribute("download", filename)
//       ..click();
//     html.Url.revokeObjectUrl(url);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Gestión de Usuarios')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Form(
//               key: _formKey,
//               child: Column(children: [
//                 TextFormField(
//                   controller: _nameController,
//                   decoration: InputDecoration(labelText: 'Nombre'),
//                   validator: (value) =>
//                       value == null || value.trim().isEmpty ? 'Requerido' : null,
//                 ),
//                 TextFormField(
//                   controller: _emailController,
//                   decoration: InputDecoration(labelText: 'Correo'),
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) =>
//                       value != null && value.contains('@') ? null : 'Correo inválido',
//                 ),
//                 TextFormField(
//                   controller: _ageController,
//                   decoration: InputDecoration(labelText: 'Edad'),
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     final age = int.tryParse(value ?? '');
//                     return age != null && age > 0 ? null : 'Edad inválida';
//                   },
//                 ),
//                 SizedBox(height: 12),
//                 ElevatedButton(onPressed: _addUser, child: Text('Agregar Usuario')),
//               ]),
//             ),
//             SizedBox(height: 16),
//             Row(
//               children: [
//                 ElevatedButton(onPressed: _generateJSON, child: Text('Generar JSON')),
//                 SizedBox(width: 10),
//                 ElevatedButton(onPressed: _generateXML, child: Text('Generar XML')),
//               ],
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: SelectableText(
//                   _output,
//                   style: TextStyle(fontFamily: 'monospace'),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'pages/user_form_page.dart';

void main() => runApp(UserApp());

class UserApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Usuarios',
      home: UserFormPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
