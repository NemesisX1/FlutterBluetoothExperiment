import 'dart:developer';
import 'package:Bustooth/models/user.dart';
import 'package:Bustooth/screens/add_user.dart';
import 'package:Bustooth/screens/user_card.dart';
import 'package:Bustooth/services/firebase.service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isScanning = false;
  double _scopeValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Utilisateurs: (portée max: $_scopeValue)"),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text("Portée à considérer"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Quitter"),
                  )
                ],
                content: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _scopeValue = double.parse(value);
                    });
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            icon: Icon(Icons.settings),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _isScanning
            ? () async {}
            : () async {
                log('refresh');
                setState(() {
                  _isScanning = true;
                });
                await FlutterBlue.instance
                    .startScan(timeout: Duration(seconds: 4))
                    .then((value) {
                  setState(() {
                    _isScanning = false;
                  });
                });
              },
        child: StreamBuilder<QuerySnapshot>(
          stream: FirestoreService().getCollectionAsStream(Collection.users),
          builder: (_, AsyncSnapshot snapshot) {
            if (snapshot.hasError) return ErrorWidget(snapshot.hasError);
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              List<User> users = List<User>.generate(
                snapshot.data.docs.length,
                (index) {
                  final data = snapshot.data.docs[index].data();
                  print(data);
                  return User.fromJson(data);
                },
              );

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (_, index) {
                  return UserCard(
                    user: users[index],
                    scope: _scopeValue,
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => AddUserView()),
        ),
      ),
    );
  }
}
