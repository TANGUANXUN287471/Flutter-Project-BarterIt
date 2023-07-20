import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:barter_it/models/user.dart';
import 'package:barter_it/models/propose.dart';
import 'package:http/http.dart' as http;

import '../../myconfig.dart';

class MyPropose extends StatefulWidget {
  const MyPropose({super.key, required this.user});
  final User user;
  @override
  State<MyPropose> createState() => _MyProposeState();
}

class _MyProposeState extends State<MyPropose> {
  List<Propose> myPropose = <Propose>[];

  String dialog = "No Data Available";
  @override
  void initState() {
    super.initState();
    loadPropose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Propose"),
      ),
      body: myPropose.isEmpty
          ? Center(
              child: Text(dialog),
            )
          : Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 7,
                          child: Row(
                            children: [
                              const CircleAvatar(
                                backgroundImage: AssetImage(
                                  "assets/images/profile.jpg",
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(
                                "Hello,  ${widget.user.name}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.notifications),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const Divider(),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 2, 2, 2),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:
                        Text("Your Current Propose Trade (${myPropose.length})",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          minVerticalPadding: 12,
                          leading: CircleAvatar(child: Text("${index + 1}")),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Pending Propose:",
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 13),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  " ${myPropose[index].sellerItemName}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Text(
                                        " Trade with: ${myPropose[index].proposeItemName}"),
                                    Text(" x${myPropose[index].proposeItemQty}")
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      " RM ${myPropose[index].sellerItemValue}",
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        margin: const EdgeInsets.all(4),
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 4, 12, 4),
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Text(
                                          "Quantity: ${myPropose[index].sellerItemQty}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios_rounded,
                                color: Colors.cyan),
                            onPressed: () {},
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemCount: myPropose.length),
                ),
              ],
            ),
    );
  }

  void loadPropose() {
    if (widget.user.id == "N/A") {
      setState(() {
        myPropose.clear();
        dialog = "Register/Login Account to Trade";
      });
      return;
    }

    http.post(Uri.parse("${MyConfig().server}/barter_it/php/loadpropose.php"),
        body: {
          "userid": widget.user.id,
        }).then((response) {
      log(response.body);
      myPropose.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['propose'].forEach((v) {
            myPropose.add(Propose.fromJson(v));
          });
        }
        setState(() {});
      }
    });
  }
  
}
