import 'package:Bustooth/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:gap/gap.dart';

class UserCard extends StatefulWidget {
  const UserCard({
    Key? key,
    required this.user,
    this.scope = 10,
  }) : super(key: key);

  final User user;
  final double scope;
  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.user.name!,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            StreamBuilder<List<ScanResult>>(
              stream: FlutterBlue.instance.scanResults,
              builder: (_, snapshot) {
                if (!snapshot.hasData || snapshot.data!.length == 0)
                  return CircularProgressIndicator();
                else {
                  bool inside = false;
                  ScanResult? deviceInfos;
                  try {
                    deviceInfos = snapshot.data!.where((element) {
                      if (element.device.id.toString() == widget.user.uuid)
                        //log(element.device.name);
                        return true;
                      return false;
                    }).first;
                    if (deviceInfos != null &&
                        deviceInfos.rssi.abs() <= widget.scope.abs())
                      inside = true;
                    else {
                      inside = false;
                    }
                  } catch (e) {}

                  return Row(
                    children: [
                      Text(
                        deviceInfos == null
                            ? "(rssi: 0) "
                            : "(rssi: ${deviceInfos.rssi.abs().toString()}) ",
                      ),
                      ElevatedButton(
                        onPressed: null,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            inside ? Colors.green : Colors.red,
                          ),
                        ),
                        child: Text(
                          inside ? "In " : "Out",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
        childrenPadding: EdgeInsets.symmetric(horizontal: 10),
        children: [
          Row(
            children: [
              Text("Nom: "),
              Text(widget.user.name!),
            ],
          ),
          Row(
            children: [
              Text("Prénom: "),
              Text(widget.user.lastname!),
            ],
          ),
          Row(
            children: [
              Text("Prénom: "),
              Text(widget.user.uuid!),
            ],
          ),
          Gap(10),
          // StreamBuilder<List<ScanResult>>(
          //   stream: FlutterBlue.instance.scanResults,
          //   builder: (_, snapshot) {
          //     if (!snapshot.hasData || snapshot.data!.length == 0)
          //       return CircularProgressIndicator();
          //     else {
          //       log(snapshot.data!.length.toString());
          //       return Column(
          //         children: List<Text>.generate(
          //           snapshot.data!.length,
          //           (index) => Text(
          //             snapshot.data![index].toString(),
          //           ),
          //         ),
          //       );
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
