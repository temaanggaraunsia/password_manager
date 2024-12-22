import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../utils/encryption.dart';
import 'add_password_screen.dart';

class PasswordScreen extends StatefulWidget {
  final String username;

  const PasswordScreen({super.key, required this.username});

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final DBHelper _dbHelper = DBHelper();

  Future<void> _deletePassword(int id) async {
    await _dbHelper.deleteUser(id);
    setState(() {});
  }

  String _decryptPassword(String encryptedPassword) {
    final encryptionHelper = EncryptionHelper(widget.username);
    return encryptionHelper.decrypt(encryptedPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Passwords (${widget.username})'),
      ),
      body: FutureBuilder(
        future: _dbHelper.getPasswordsByUsername(widget.username),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final passwords = snapshot.data as List;

          return passwords.isEmpty
              ? Center(child: Text('No passwords added yet'))
              : ListView.builder(
                  itemCount: passwords.length,
                  itemBuilder: (context, index) {
                    final password = passwords[index];
                    final decryptedPassword =
                        _decryptPassword(password.password);

                    return ListTile(
                      title: Text(password.fullName),
                      subtitle: Text(decryptedPassword),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddPasswordScreen(
                                    username: widget.username,
                                    passwordData: password,
                                  ),
                                ),
                              );
                              setState(() {});
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deletePassword(password.userId!),
                          ),
                        ],
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddPasswordScreen(username: widget.username),
            ),
          );
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
