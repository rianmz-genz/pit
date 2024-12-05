import 'package:flutter/material.dart';
import 'package:pit/helpers/app_helper.dart';

class SettingsPageUrl extends StatelessWidget {
  final TextEditingController _urlController =
      TextEditingController(text: AppConfig().getBaseUrl());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Base URL',
                hintText: 'Enter API Base URL',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                AppConfig().setBaseUrl(_urlController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Base URL updated!')),
                );
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
