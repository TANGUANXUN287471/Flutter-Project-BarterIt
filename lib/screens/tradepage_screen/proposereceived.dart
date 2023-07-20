import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barter_it/models/user.dart';
import 'package:http/http.dart' as http;
import '../../models/propose.dart';
import '../../myconfig.dart';

class ProposeReceived extends StatefulWidget {
  const ProposeReceived({super.key, required this.user});
  final User user;
  @override
  State<ProposeReceived> createState() => _ProposeReceivedState();
}

class _ProposeReceivedState extends State<ProposeReceived> {
  List<Propose> proposeRec = <Propose>[];
  String name = '', phone = '', email = '', datereg = '';
  String dialog = "No Propose Received";
  String userCredit = '';
  @override
  void initState() {
    super.initState();
    loadPropose();
    fetchUserCredit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Propose"),
      ),
      body: Column(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  loadPropose();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Pending Review",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () {
                  loadProposeAccept();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.green[300],
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Accepted Propose",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 2, 2, 2),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Received Propose Trade (${proposeRec.length})",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          proposeRec.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 280, 8, 50),
                    child: Text(dialog,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black38)),
                  ),
                )
              : const SizedBox(height: 10),
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
                            "Pending Confirm:",
                            style: TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 13),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            " ${proposeRec[index].sellerItemName}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
                                  " Trade with: ${proposeRec[index].proposeItemName}"),
                              Text(" x${proposeRec[index].proposeItemQty}")
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                " RM ${proposeRec[index].sellerItemValue}",
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
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 4, 12, 4),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    "Quantity: ${proposeRec[index].sellerItemQty}",
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
                      onPressed: () {
                        setState(() {
                          showProposeDetails(index);
                        });
                      },
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemCount: proposeRec.length),
          ),
        ],
      ),
    );
  }

  void showProposeDetails(index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 740,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Close"),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 4, 4, 4),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text("Propose Details",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          elevation: 8,
                          child: InkWell(
                            onTap: () {},
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.person),
                                        title: Text("From: $name",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        subtitle: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    "Registered  $datereg")),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(8),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: CachedNetworkImage(
                                                height: 120,
                                                width: 180,
                                                fit: BoxFit.cover,
                                                imageUrl:
                                                    "${MyConfig().server}/barter_it/assets/items/${proposeRec[index].sellerItemId}_1.png",
                                                placeholder: (context, url) =>
                                                    const LinearProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    16, 0, 4, 0),
                                            title: Text(
                                                "${proposeRec[index].sellerItemName}",
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.none,
                                                )),
                                            subtitle: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      "${proposeRec[index].sellerItemDesc}"),
                                                ),
                                                const SizedBox(height: 10),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      "RM ${proposeRec[index].sellerItemValue}",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red,
                                                      )),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.all(4),
                                                    padding: const EdgeInsets
                                                        .fromLTRB(12, 4, 12, 4),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: Text(
                                                        "Quantity: ${proposeRec[index].sellerItemQty}"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Icon(Icons.arrow_upward_rounded, color: Colors.blue),
                        Text(
                          "BARTER WITH",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black45,
                          ),
                        ),
                        Icon(Icons.arrow_downward_rounded, color: Colors.blue),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          elevation: 8,
                          child: InkWell(
                            onTap: () {},
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.person),
                                        title: Text("To: ${widget.user.name}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        subtitle: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    "Registered  ${widget.user.datereg}")),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(8),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: CachedNetworkImage(
                                                height: 120,
                                                width: 180,
                                                fit: BoxFit.cover,
                                                imageUrl:
                                                    "${MyConfig().server}/barter_it/assets/items/${proposeRec[index].proposeItemId}_1.png",
                                                placeholder: (context, url) =>
                                                    const LinearProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    16, 0, 4, 0),
                                            title: Text(
                                                proposeRec[index]
                                                    .proposeItemName
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.none,
                                                )),
                                            subtitle: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(proposeRec[index]
                                                      .proposeItemDesc
                                                      .toString()),
                                                ),
                                                const SizedBox(height: 10),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      "RM ${proposeRec[index].proposeItemValue}",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red,
                                                      )),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.all(4),
                                                    padding: const EdgeInsets
                                                        .fromLTRB(12, 4, 12, 4),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: Text(
                                                        "Quantity: ${proposeRec[index].proposeItemQty}"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(16),
                          color: Colors.teal[300],
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onPressed: () {
                            accecptProposeDialog(index);
                          },
                          child: const Text(
                            "Accept",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        MaterialButton(
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(16),
                          color: Colors.red[300],
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onPressed: () {
                            _rejectPropose(index);
                          },
                          child: const Text(
                            "Reject",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void loadPropose() {
    if (widget.user.id == "N/A") {
      setState(() {
        proposeRec.clear();
        dialog = "Register/Login Account to Trade";
      });
      return;
    }

    http.post(Uri.parse("${MyConfig().server}/barter_it/php/loadreceived.php"),
        body: {
          "sellerid": widget.user.id,
        }).then((response) {
      log(response.body);
      proposeRec.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['propose'].forEach((v) {
            proposeRec.add(Propose.fromJson(v));
          });
          for (int i = 0; i < proposeRec.length; i++) {
            loadUser(i);
          }
        }
        setState(() {});
      }
    });
  }

  void loadProposeAccept() {
    if (widget.user.id == "N/A") {
      setState(() {
        proposeRec.clear();
        dialog = "Register/Login Account to Trade";
      });
      return;
    }

    http.post(Uri.parse("${MyConfig().server}/barter_it/php/loadreceivedaccept.php"),
        body: {
          "sellerid": widget.user.id,
        }).then((response) {
      log(response.body);
      proposeRec.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['propose'].forEach((v) {
            proposeRec.add(Propose.fromJson(v));
          });
          for (int i = 0; i < proposeRec.length; i++) {
            loadUser(i);
          }
        }
        setState(() {});
      }
    });
  }

  void loadUser(index) {
    http.post(Uri.parse("${MyConfig().server}/barter_it/php/load_user.php"),
        body: {
          "userid": proposeRec[index].buyerId.toString(),
        }).then((response) {
      debugPrint(response.body);

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData['status'] == 'success') {
          // Extract the user information from the response
          name = jsonData['data']['sellerinfo']['name'];
          phone = jsonData['data']['sellerinfo']['phone'];
          email = jsonData['data']['sellerinfo']['email'];
          datereg = jsonData['data']['sellerinfo']['datereg'];
        }
        setState(() {});
      }
    });
  }

  void accecptProposeDialog(index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Accept the Barter Offer?",
            style: TextStyle(),
          ),
          content: Text("Current Credit: $userCredit",
              style: const TextStyle(
                  fontWeight: FontWeight.w300, fontStyle: FontStyle.italic)),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                deductCredit(index);
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void deductCredit(index) {
    int credit = int.parse(userCredit);
    if (credit < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Insufficient credit, please topup")));
      Navigator.pop(context);
      return;
    }
    http.post(Uri.parse("${MyConfig().server}/barter_it/php/deductcredit.php"),
        body: {
          "userid": widget.user.id,
          "proposeid": proposeRec[index].proposeId,
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        debugPrint(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Barter Item Success")));
          fetchUserCredit();
          loadPropose();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed")));
        Navigator.pop(context);
      }
    });
  }

  void _rejectPropose(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Reject Proposed Item?",
            style: TextStyle(),
          ),
          content: const Text("Confirm to remove", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                http.post(
                    Uri.parse(
                        "${MyConfig().server}//barter_it/php/rejectpropose.php"),
                    body: {
                      "userid": widget.user.id.toString(),
                      "proposeid": proposeRec[index].proposeId.toString(),
                    }).then((response) {
                  if (response.statusCode == 200) {
                    var jsondata = jsonDecode(response.body);
                    if (jsondata['status'] == 'success') {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text("Reject Proposal", style: TextStyle())));
                      loadPropose();
                    }
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text("Failed")));
                  }
                });
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void fetchUserCredit() {
    http.post(
      Uri.parse("${MyConfig().server}//barter_it/php/updatecredit.php"),
      body: {"userid": widget.user.id.toString()},
    ).then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
          setState(() {
            userCredit = jsonData['data']['user_credit'];
          });
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed")));
      }
    });
  }
}
