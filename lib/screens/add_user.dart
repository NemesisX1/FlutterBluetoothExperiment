import 'package:Bustooth/models/user.dart';
import 'package:Bustooth/services/firebase.service.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

// <>
class AddUserView extends StatefulWidget {
  const AddUserView({Key? key}) : super(key: key);

  @override
  _AddUserViewState createState() => _AddUserViewState();
}

class _AddUserViewState extends State<AddUserView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _uuidController = TextEditingController();

  bool _isLoading = false;

  String? _commonValidator(String? value) {
    if (value!.isEmpty) return "Ne peut être null";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Ajouter un user"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  TextFormField(
                    controller: _lastnameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                    ),
                    validator: _commonValidator,
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Prénom',
                    ),
                    validator: _commonValidator,
                  ),
                  TextFormField(
                    controller: _uuidController,
                    decoration: const InputDecoration(
                      labelText: 'UUID',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return "Ne peut être null";

                      if (value.length != 17)
                        return "UUID doit être de 17 charactères";
                      if (":".allMatches(value).length != 5)
                        return "UUID doit contenir cing deux points :";
                      return null;
                    },
                  ),
                ],
              ),
            ),
            Gap(50),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _isLoading = true;
                    });

                    User user = User(
                      name: _nameController.text,
                      lastname: _lastnameController.text,
                      uuid: _uuidController.text,
                    );
                    await FirestoreService().addModelToCollection(
                      user,
                      Collection.users,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(user.toJson().toString())));

                    setState(() {
                      _isLoading = false;
                    });

                    _nameController.clear();
                    _lastnameController.clear();
                    _uuidController.clear();
                  }
                },
                child: _isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text("Envoyer"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
