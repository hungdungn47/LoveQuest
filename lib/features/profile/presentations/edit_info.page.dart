import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditFieldPage extends StatelessWidget {
  final String title;
  final String currentValue;

  EditFieldPage({required this.title, required this.currentValue});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = currentValue;

    return Scaffold(
      appBar: AppBar(title: Text("Edit $title")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (title == "Gender")
              DropdownButtonFormField<String>(
                value: currentValue,
                items: ["Male", "Female", "Other"]
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) _controller.text = val;
                },
                decoration: InputDecoration(labelText: "Select gender"),
              )
            else
              TextField(
                controller: _controller,
                decoration: InputDecoration(labelText: "Edit $title"),
                keyboardType: title == "Email" ? TextInputType.emailAddress : TextInputType.text,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.back(result: _controller.text);
              },
              child: Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}
