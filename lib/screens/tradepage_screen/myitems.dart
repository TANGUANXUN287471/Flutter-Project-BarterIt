import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barter_it/models/user.dart';
import '../../models/items.dart';
import '../../myconfig.dart';
import 'package:http/http.dart' as http;

class MyItems extends StatefulWidget {
  final User user;
  const MyItems({super.key, required this.user});

  @override
  State<MyItems> createState() => _MyItemsState();
}

class _MyItemsState extends State<MyItems> {
  List<Item> listItems = <Item>[];
  String dialog = "No Data Available";
  String cname = "";
  String cqty = "";
  String cvalue = "";
  String ctype = "";
  String cdesc = "";
  String ccons = "";

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage My Items"),
      ),
      body: listItems.isEmpty
          ? Center(
              child: Text(dialog),
            )
          : ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  minVerticalPadding: 18,
                  leading: CachedNetworkImage(
                      imageUrl:
                          "${MyConfig().server}/barter_it/assets/items/${listItems[index].itemId}_1.png"),
                  title: Text("${listItems[index].itemName}"),
                  subtitle: Text("${listItems[index].itemDesc}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.cyan),
                    onPressed: () {
                      _showDetails(index);
                    },
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: listItems.length),
    );
  }

  void loadItems() {
    if (widget.user.id == "N/A") {
      setState(() {
        listItems.clear();
        dialog = "Register/Login Account to Trade";
      });
      return;
    }

    http.post(Uri.parse("${MyConfig().server}/barter_it/php/load_items.php"),
        body: {
          "userid": widget.user.id,
        }).then((response) {
      log(response.body);
      listItems.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            listItems.add(Item.fromJson(v));
          });
        }
        setState(() {});
      }
    });
  }

  void _showDetails(index) {
    showModalBottomSheet(
      elevation: 20,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 700,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        onDeleteDialog(index);
                      },
                      child: const Text("Delete",
                          style: TextStyle(color: Colors.red))),
                  TextButton(
                      onPressed: () {
                        onSaveDialog(index);
                      },
                      child: const Text(
                        "Save",
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Close")),
                ],
              ),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    const SizedBox(width: 10),
                    Card(
                      elevation: 8,
                      child: CachedNetworkImage(
                        imageUrl:
                            "${MyConfig().server}/barter_it/assets/items/${listItems[index].itemId}_1.png",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Card(
                      elevation: 8,
                      child: CachedNetworkImage(
                        imageUrl:
                            "${MyConfig().server}/barter_it/assets/items/${listItems[index].itemId}_2.png",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Card(
                      elevation: 8,
                      child: CachedNetworkImage(
                        imageUrl:
                            "${MyConfig().server}/barter_it/assets/items/${listItems[index].itemId}_3.png",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Card(
                      elevation: 8,
                      child: CachedNetworkImage(
                        imageUrl:
                            "${MyConfig().server}/barter_it/assets/items/${listItems[index].itemId}_4.png",
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  )),
                  child: Card(
                    elevation: 8,
                    child: Column(
                      children: [
                        ListTile(
                          leading: SizedBox(
                            width: 200,
                            child: TextFormField(
                              initialValue:
                                  listItems[index].itemName.toString(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                              onChanged: (newValue) {
                                cname = newValue.isNotEmpty
                                    ? newValue
                                    : listItems[index].itemName.toString();
                              },
                            ),
                          ),
                          title: TextFormField(
                            initialValue: listItems[index].itemQty.toString(),
                            onChanged: (newValue) {
                              cqty = newValue.isNotEmpty
                                  ? newValue
                                  : listItems[index].itemQty.toString();
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide()),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.attach_money),
                          title: TextFormField(
                            initialValue: listItems[index].itemValue.toString(),
                            keyboardType: TextInputType.number,
                            onChanged: (newValue) {
                              cvalue = newValue.isNotEmpty
                                  ? newValue
                                  : listItems[index].itemValue.toString();
                            },
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide()),
                            ),
                          ),
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 0, 24, 0),
                          minVerticalPadding: 0,
                        ),
                        ListTile(
                          leading: const Icon(Icons.type_specimen),
                          title: TextFormField(
                            initialValue: listItems[index].itemType.toString(),
                            onChanged: (newValue) {
                              ctype = newValue.isNotEmpty
                                  ? newValue
                                  : listItems[index].itemType.toString();
                            },
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide()),
                            ),
                          ),
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 0, 24, 0),
                          minVerticalPadding: 0,
                          subtitle: TextFormField(
                            initialValue: listItems[index].itemDesc.toString(),
                            onChanged: (newValue) {
                              cdesc = newValue.isNotEmpty
                                  ? newValue
                                  : listItems[index].itemDesc.toString();
                            },
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide()),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ListTile(
                          leading: const Icon(Icons.document_scanner),
                          title: const Text("Conditions"),
                          subtitle: TextFormField(
                            initialValue:
                                listItems[index].itemCondition.toString(),
                            onChanged: (newValue) {
                              ccons = newValue.isNotEmpty
                                  ? newValue
                                  : listItems[index].itemCondition.toString();
                            },
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide()),
                            ),
                          ),
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 0, 24, 0),
                        ),
                        ListTile(
                          leading: const Icon(Icons.pin_drop),
                          title: const Text("Location"),
                          subtitle: Text(
                            "${listItems[index].itemState.toString()}, ${listItems[index].itemLocality.toString()}",
                          ),
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 0, 24, 0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void onDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Delete ${listItems[index].itemName}?",
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                deleteItem(index);
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

  void deleteItem(int index) {
    http.post(Uri.parse("${MyConfig().server}/barter_it/php/delete_item.php"),
        body: {
          "userid": widget.user.id,
          "itemid": listItems[index].itemId
        }).then(
      (response) {
        debugPrint(response.body);
        //itemList.clear();
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == "success") {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Delete Success")));
            loadItems();
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Failed")));
          }
        }
      },
    );
  }

  void onSaveDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Save Changes for ${listItems[index].itemName}?",
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                saveItem(index);
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

  void saveItem(int index) {
    http.post(Uri.parse("${MyConfig().server}/barter_it/php/update_items.php"),
        body: {
          "itemId": listItems[index].itemId.toString(),
          "itemName":
              cname.isNotEmpty ? cname : listItems[index].itemName.toString(),
          "itemQty":
              cqty.isNotEmpty ? cqty : listItems[index].itemQty.toString(),
          "itemValue": cvalue.isNotEmpty
              ? cvalue
              : listItems[index].itemValue.toString(),
          "type":
              ctype.isNotEmpty ? ctype : listItems[index].itemType.toString(),
          "itemDesc":
              cdesc.isNotEmpty ? cdesc : listItems[index].itemDesc.toString(),
          "condition": ccons.isNotEmpty
              ? ccons
              : listItems[index].itemCondition.toString(),
        }).then((response) {
      debugPrint(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Failed")));
        }
        setState(() {
          Navigator.pop(context);
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Update Failed")));
        Navigator.pop(context);
      }
    });
  }
}
