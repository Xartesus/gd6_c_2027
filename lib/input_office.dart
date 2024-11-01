import 'package:flutter/material.dart';
import 'package:gd6_c_2027/database/sql_helper.dart';

class InputOffice extends StatefulWidget {
  const InputOffice(
      {super.key,
      required this.title,
      required this.id,
      required this.officeName,
      required this.officeEmail,
      required this.officeAddress});

  final String? title, officeName, officeEmail, officeAddress;
  final int? id;

  @override
  State<InputOffice> createState() => _InputOfficeState();
}

class _InputOfficeState extends State<InputOffice> {
  TextEditingController controllerOfficeName = TextEditingController();
  TextEditingController controllerOfficeEmail = TextEditingController();
  TextEditingController controllerOfficeAddress = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.id != null) {
      controllerOfficeName.text = widget.officeName!;
      controllerOfficeEmail.text = widget.officeEmail!;
      controllerOfficeAddress.text = widget.officeAddress!;
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("INPUT OFFICE"),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            TextField(
              controller: controllerOfficeName,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Office Name',
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controllerOfficeEmail,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Office Email',
              ),
            ),
            TextField(
              controller: controllerOfficeAddress,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Office Address',
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () async {
                if (widget.id == null) {
                  await addOffice();
                } else {
                  await editOffice(widget.id!);
                }
                Navigator.pop(context);
              },
            )
          ],
        ));
  }

  Future<void> addOffice() async {
    await SQLHelper.addOffice(controllerOfficeName.text,
        controllerOfficeEmail.text, controllerOfficeAddress.text);
  }

  Future<void> editOffice(int id) async {
    await SQLHelper.editOffice(id, controllerOfficeName.text,
        controllerOfficeEmail.text, controllerOfficeAddress.text);
  }
}
