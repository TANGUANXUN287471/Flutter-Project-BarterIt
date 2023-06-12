import 'dart:convert';
import 'dart:developer';
import 'package:barter_it/screens/tradepage_screen/edititems.dart';
import 'package:barter_it/screens/tradepage_screen/myitems.dart';
import 'package:barter_it/screens/tradepage_screen/uploaditems.dart';
import 'package:flutter/material.dart';
import 'package:barter_it/models/user.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:barter_it/models/items.dart';
import 'package:barter_it/myconfig.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

class TradePage extends StatefulWidget {
  final User user;
  const TradePage({super.key, required this.user});

  @override
  State<TradePage> createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  late List<Widget> tabchildren;
  String maintitle = "Seller";
  List<Item> itemList = <Item>[];
  @override
  void initState() {
    super.initState();
    loadTradeItems();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
      floatingActionButton: SpeedDial(
        icon: Icons.menu,
        activeIcon: Icons.close,
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
        activeBackgroundColor: Colors.deepPurpleAccent,
        activeForegroundColor: Colors.white,
        childrenButtonSize: const Size.fromRadius(40.0),
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () async {
          /*if (widget.user.id != "N/A") {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => UploadItems(
                            user: widget.user,
                          )));
              loadTradeItems();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Please login/register an account")));
            }*/
          debugPrint('OPENING DIAL');
        },
        onClose: () {
          debugPrint('DIAL CLOSED');
        },
        elevation: 8.0,
        shape: const CircleBorder(),
        childPadding: const EdgeInsets.all(8),
        children: [
          SpeedDialChild(
            child: const Icon(Icons.upload),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            label: 'Upload Items',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      UploadItems(user: widget.user)));
            },
            onLongPress: () {},
          ),
          SpeedDialChild(
            child: const Icon(Icons.edit_document),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            label: 'Manage My Items',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => const MyItems()));
            },
            onLongPress: () {},
          ),
        ],
      ),
      body: itemList.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : Column(children: [
              Container(
                height: 24,
                color: Theme.of(context).colorScheme.primary,
                alignment: Alignment.center,
                child: Text(
                  "${itemList.length} Items Found",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: axiscount,
                      children: List.generate(
                        itemList.length,
                        (index) {
                          return Card(
                            child: InkWell(
                              onLongPress: () {
                                onDeleteDialog(index);
                              },
                              onTap: () async {
                                Item singleitem =
                                    Item.fromJson(itemList[index].toJson());
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) => EditItemScreen(
                                              user: widget.user,
                                              item: singleitem,
                                            )));
                                loadTradeItems();
                              },
                              child: Column(children: [
                                CachedNetworkImage(
                                  width: screenWidth,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      "${MyConfig().server}/barter_it/assets/items/${itemList[index].itemId}.png",
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                Text(
                                  itemList[index].itemName.toString(),
                                  style: const TextStyle(fontSize: 20),
                                ),
                                Text(
                                  "RM ${itemList[index].itemValue.toString()}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  "${itemList[index].itemQty} available",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ]),
                            ),
                          );
                        },
                      )))
            ]),
    );
  }

  void loadTradeItems() {
    if (widget.user.id == "na") {
      setState(() {
        // titlecenter = "Unregistered User";
      });
      return;
    }

    http.post(Uri.parse("${MyConfig().server}/barter_it/php/load_items.php"),
        body: {"userid": widget.user.id}).then((response) {
      //print(response.body);
      log(response.body);
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
          print(itemList[0].itemName);
        }
        setState(() {});
      }
    });
  }

  void onDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Delete ${itemList[index].itemName}?",
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                deleteCatch(index);
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

  void deleteCatch(int index) {
    http.post(Uri.parse("${MyConfig().server}/barter_it/php/delete_item.php"),
        body: {
          "userid": widget.user.id,
          "itemid": itemList[index].itemId
        }).then((response) {
      print(response.body);
      //itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Success")));
          loadTradeItems();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
        }
      }
    });
  }
}
