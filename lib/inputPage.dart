import 'package:flutter/material.dart';
import 'package:gd6_c_2027/database/sql_helper.dart';

class InputPage extends StatefulWidget {
  const InputPage(
      {super.key,
      required this.title,
      required this.id,
      required this.name,
      required this.email});

  final String? title, name, email;
  final int? id;

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.id != null) {
      controllerName.text = widget.name!;
      controllerEmail.text = widget.email!;
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("INPUT EMPLOYEE"),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            TextField(
              controller: controllerName,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Name',
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controllerEmail,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () async {
                if (widget.id == null) {
                  await addEmployee();
                } else {
                  await editEmployee(widget.id!);
                }
                Navigator.pop(context);
              },
            )
          ],
        ));
  }

  Future<void> addEmployee() async {
    await SQLHelper.addEmployee(controllerName.text, controllerEmail.text);
  }

  Future<void> editEmployee(int id) async {
    await SQLHelper.editEmployee(id, controllerName.text, controllerEmail.text);
  }
}
