import 'package:flutter/material.dart';

class UserForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController ageController;
  final VoidCallback onSubmit;

  const UserForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.ageController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(children: [
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'Nombre'),
          validator: (value) =>
              value == null || value.trim().isEmpty ? 'Requerido' : null,
        ),
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(labelText: 'Correo'),
          keyboardType: TextInputType.emailAddress,
          validator: (value) =>
              value != null && value.contains('@') ? null : 'Correo inválido',
        ),
        TextFormField(
          controller: ageController,
          decoration: InputDecoration(labelText: 'Edad'),
          keyboardType: TextInputType.number,
          validator: (value) {
            final age = int.tryParse(value ?? '');
            return age != null && age > 0 ? null : 'Edad inválida';
          },
        ),
        SizedBox(height: 12),
        ElevatedButton(onPressed: onSubmit, child: Text('Agregar Usuario')),
      ]),
    );
  }
}
