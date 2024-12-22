import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/user.dart';
import '../utils/encryption.dart';

class AddPasswordScreen extends StatefulWidget {
  final String username;
  final User? passwordData;

  const AddPasswordScreen(
      {super.key, required this.username, this.passwordData});

  @override
  _AddPasswordScreenState createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends State<AddPasswordScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    if (widget.passwordData != null) {
      _fullNameController.text = widget.passwordData!.fullName;
      _passwordController.text =
          _decryptPassword(widget.passwordData!.password);
    }
  }

  String _decryptPassword(String encryptedPassword) {
    final encryptionHelper = EncryptionHelper(widget.username);
    return encryptionHelper.decrypt(encryptedPassword);
  }

  Future<void> _savePassword() async {
    final fullName = _fullNameController.text.trim();
    final password = _passwordController.text.trim();

    if (fullName.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    final encryptionHelper = EncryptionHelper(widget.username);
    final encryptedPassword = encryptionHelper.encrypt(password);

    final newUserPassword = User(
      userId: widget.passwordData?.userId,
      username: widget.username,
      fullName: fullName,
      password: encryptedPassword,
    );

    if (widget.passwordData == null) {
      await _dbHelper.insertUser(newUserPassword);
    } else {
      await _dbHelper.updateUser(newUserPassword);
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.passwordData == null ? 'Add Password' : 'Edit Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePassword,
              child: Text(widget.passwordData == null ? 'Add' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }
}
