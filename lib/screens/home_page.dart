import 'dart:convert';
import 'dart:developer';
import 'package:barter_it/screens/homepage_screen/item_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barter_it/models/user.dart';
import 'package:http/http.dart' as http;
import '../models/items.dart';
import '../myconfig.dart';
import 'homepage_screen/showcart.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  List<Item> itemList = <Item>[];
  int numofpage = 1, curpage = 1;
  int numberofresult = 0;
  int cartqty = 0;
  var color;

  @override
  void initState() {
    super.initState();
    _loadItems(1);
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Colors.teal,
                Colors.cyan.shade300,
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: ListTile(
                  title: const Text(
                    "Home Page",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            showsearchDialog();
                          },
                          icon: const Icon(Icons.search)),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ShowCart(user: widget.user)));
                          },
                          icon: const Icon(Icons.shopping_cart))
                    ],
                  )),
            ),
          ),
        ),
      ),
      body: itemList.isEmpty
          ? const Center(child: Text("No Data Available"))
          : Column(
              children: [
                Container(
                  height: 24,
                  color: Colors.blueGrey,
                  alignment: Alignment.center,
                  child: Text(
                    "$numberofresult Items Found",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      return Future.delayed(const Duration(seconds: 1), () {});
                    },
                    child: GridView.count(
                      crossAxisCount: axiscount,
                      children: List.generate(
                        itemList.length,
                        (index) {
                          return GridTile(
                            header: GridTileBar(
                              backgroundColor: Colors.black26,
                              leading: const Icon(Icons.timer_sharp),
                              title: Text("${itemList[index].itemDate}"),
                            ),
                            child: Card(
                              child: InkWell(
                                onTap: () async {
                                  Item itemIndex =
                                      Item.fromJson(itemList[index].toJson());
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (content) => ItemDetails(
                                                user: widget.user,
                                                itemIndex: itemIndex,
                                              )));
                                  _loadItems(1);
                                },
                                child: Column(children: [
                                  CachedNetworkImage(
                                    width: screenWidth,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "${MyConfig().server}/barter_it/assets/items/${itemList[index].itemId}_1.png",
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
                                    "# ${itemList[index].itemQty} available",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ]),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                    color: Colors.transparent,
                    height: 40,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: numofpage,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          if ((curpage - 1) == index) {
                            color = Colors.red;
                          } else {
                            color = Colors.black;
                          }
                          return TextButton(
                              onPressed: () {
                                curpage = index + 1;
                                _loadItems(index + 1);
                              },
                              child: Text(
                                (index + 1).toString(),
                                style: TextStyle(color: color, fontSize: 18),
                              ));
                        }))
              ],
            ),
    );
  }

  void _loadItems(int pg) {
    http.post(Uri.parse("${MyConfig().server}/barter_it/php/load_items.php"),
        body: {
          "cartuserid": widget.user.id,
          "pageno": pg.toString(),
        }).then((response) {
      log(response.body);
      itemList.clear();

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          numofpage = int.parse(jsondata['numofpage']); 
          numberofresult = int.parse(jsondata['numberofresult']);

          var extractdata = jsondata['data'];
          cartqty = int.parse(jsondata['cartqty'].toString());
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
        }
        setState(() {});
      }
    });
  }

  void showsearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Search",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
                controller: searchController,
                decoration: const InputDecoration(
                    labelText: 'Enter search name...',
                    labelStyle: TextStyle(fontSize: 16),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0),
                    ))),
          ]),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  String search = searchController.text;
                  searchCatch(search);
                  Navigator.of(context).pop();
                },
                child: const Text("Search")),
            TextButton(
              child: const Text(
                "Close",
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

  void searchCatch(String search) {
    http.post(Uri.parse("${MyConfig().server}/barter_it/php/load_items.php"),
        body: {
          "cartuserid": widget.user.id,
          "search": search
        }).then((response) {
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
}
