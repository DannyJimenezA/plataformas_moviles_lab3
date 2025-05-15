import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../widgets/user_form.dart';
import '../utils/file_saver.dart';
import '../utils/local_storage.dart';

class UserFormPage extends StatefulWidget {
  @override
  _UserFormPageState createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();
  final List<User> _users = [];

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();

  String _output = '';
  String _currentFormat = ''; // 'json' o 'xml'

  @override
  void initState() {
    super.initState();
    _loadUsersFromLocalStorage();
  }

  void _loadUsersFromLocalStorage() {
    final data = loadFromLocalStorage('users');
    if (data != null) {
      final decoded = jsonDecode(data) as List<dynamic>;
      setState(() {
        _users.clear();
        _users.addAll(decoded.map((u) => User(
              name: u['name'],
              email: u['email'],
              age: u['age'],
            )));
      });
    }
  }

  void _saveUsersToLocalStorage() {
    final data = jsonEncode(_users.map((u) => u.toJson()).toList());
    saveToLocalStorage('users', data);
  }

  void _addUser() {
    if (_formKey.currentState!.validate()) {
      final user = User(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        age: int.parse(_ageController.text.trim()),
      );
      setState(() {
        _users.add(user);
        _nameController.clear();
        _emailController.clear();
        _ageController.clear();
      });
      _saveUsersToLocalStorage();
    }
  }

  void _showJSON() {
    final jsonOutput = jsonEncode(_users.map((u) => u.toJson()).toList());
    setState(() {
      _output = JsonEncoder.withIndent('  ').convert(json.decode(jsonOutput));
      _currentFormat = 'json';
    });
  }

  void _showXML() {
    final xmlOutput = '<?xml version="1.0" encoding="UTF-8"?>\n<usuarios>\n' +
        _users.map((u) => u.toXml()).join('\n') +
        '\n</usuarios>';
    setState(() {
      _output = xmlOutput;
      _currentFormat = 'xml';
    });
  }

  void _downloadCurrentOutput() {
    if (_output.isEmpty || _currentFormat.isEmpty) return;

    final filename = _currentFormat == 'json' ? 'usuarios.json' : 'usuarios.xml';
    final mime = _currentFormat == 'json' ? 'application/json' : 'application/xml';

    saveFile(filename, _output, mime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: UserForm(
                  formKey: _formKey,
                  nameController: _nameController,
                  emailController: _emailController,
                  ageController: _ageController,
                  onSubmit: _addUser,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showJSON,
                    icon: const Icon(Icons.code),
                    label: const Text('Mostrar JSON'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showXML,
                    icon: const Icon(Icons.code_off),
                    label: const Text('Mostrar XML'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Usuarios ingresados:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _users.isEmpty
                        ? const Center(child: Text('No hay usuarios aún.'))
                        : ListView.builder(
                            itemCount: _users.length,
                            itemBuilder: (context, index) {
                              final user = _users[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: Text(user.name[0].toUpperCase()),
                                  ),
                                  title: Text(user.name),
                                  subtitle: Text('${user.email} — Edad: ${user.age}'),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _users.removeAt(index);
                                      });
                                      _saveUsersToLocalStorage();
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Resultado (JSON/XML):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Container(
              height: 160,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  _output,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _output.isNotEmpty ? _downloadCurrentOutput : null,
                icon: const Icon(Icons.download),
                label: Text(
                  _currentFormat == 'json'
                      ? 'Descargar JSON'
                      : _currentFormat == 'xml'
                          ? 'Descargar XML'
                          : 'Descargar',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
