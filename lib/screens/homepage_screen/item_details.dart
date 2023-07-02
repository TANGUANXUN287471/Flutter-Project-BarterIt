import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barter_it/models/user.dart';
import 'package:barter_it/models/items.dart';
import 'package:http/http.dart' as http;
import '../../myconfig.dart';

class ItemDetails extends StatefulWidget {
  final User user;
  final Item itemIndex;
  const ItemDetails({super.key, required this.user, required this.itemIndex});

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  int num = 0;
  int maxQty = 0;
  int value = 0;
  int total = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    maxQty = int.parse(widget.itemIndex.itemQty.toString());
    value = int.parse(widget.itemIndex.itemValue.toString());
    total = value * num;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.itemIndex.itemName.toString()),
      ),
      body: SizedBox(
        height: 815,
        child: Column(
          children: [
            const SizedBox(height: 8),
            SizedBox(
              height: 230,
              width: 500,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  const SizedBox(width: 10),
                  Card(
                    elevation: 8,
                    child: CachedNetworkImage(
                      imageUrl:
                          "${MyConfig().server}/barter_it/assets/items/${widget.itemIndex.itemId}_1.png",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Card(
                    elevation: 8,
                    child: CachedNetworkImage(
                      imageUrl:
                          "${MyConfig().server}/barter_it/assets/items/${widget.itemIndex.itemId}_2.png",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Card(
                    elevation: 8,
                    child: CachedNetworkImage(
                      imageUrl:
                          "${MyConfig().server}/barter_it/assets/items/${widget.itemIndex.itemId}_3.png",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Card(
                    elevation: 8,
                    child: CachedNetworkImage(
                      imageUrl:
                          "${MyConfig().server}/barter_it/assets/items/${widget.itemIndex.itemId}_4.png",
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            Container(
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
                      leading: Text(widget.itemIndex.itemName.toString(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          )),
                      title: Text(
                          "# ${widget.itemIndex.itemQty.toString()} available"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.attach_money),
                      title:
                          Text("RM ${widget.itemIndex.itemValue.toString()}"),
                      contentPadding: const EdgeInsets.fromLTRB(16, 0, 4, 0),
                      minVerticalPadding: 0,
                    ),
                    ListTile(
                      leading: const Icon(Icons.type_specimen),
                      title: Text(widget.itemIndex.itemType.toString()),
                      contentPadding: const EdgeInsets.fromLTRB(16, 0, 4, 0),
                      minVerticalPadding: 0,
                      subtitle: Text(widget.itemIndex.itemDesc.toString()),
                    ),
                    ListTile(
                      leading: const Icon(Icons.document_scanner),
                      title: const Text("Conditions"),
                      subtitle: Text(widget.itemIndex.itemCondition.toString()),
                    ),
                    ListTile(
                      leading: const Icon(Icons.pin_drop),
                      title: const Text("Location"),
                      subtitle: Text(
                          "${widget.itemIndex.itemState.toString()}, ${widget.itemIndex.itemLocality.toString()}"),
                    ),
                    ListTile(
                      title: Center(
                          child: Text("Total:  RM $total",
                              style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 18,
                              ))),
                    ),
                    ListTile(
                      leading: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(
                            () {
                              if (num < maxQty) {
                                num += 1;
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Exceed maximum amount available")));
                              }
                            },
                          );
                        },
                      ),
                      title: Center(
                          child: Container(
                              width: 60,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(child: Text("$num")))),
                      contentPadding: const EdgeInsets.fromLTRB(90, 0, 90, 0),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (num <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text(" Reached Minimun Amount")));
                            } else {
                              num -= 1;
                            }
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            child: MaterialButton(
                              color: Colors.teal[300],
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              onPressed: () {
                                if (num <= 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Please add the amount")));
                                } else {
                                  addtocartdialog();
                                }
                              },
                              child: const Text(" Add Cart"),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: MaterialButton(
                                color: Colors.teal[300],
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                onPressed: () {
                                  if (num <= 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text("Please add the amount")));
                                  } else {
                                    addtocartdialog();
                                  }
                                },
                                child: const Text("Propose Trade")),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addtocartdialog() {
    if (widget.user.id.toString() == widget.itemIndex.userId.toString()) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User cannot add own item")));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Add to cart?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                addtocart();
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

  void addtocart() {
    http.post(Uri.parse("${MyConfig().server}/barter_it/php/addtocart.php"),
        body: {
          "item_id": widget.itemIndex.itemId.toString(),
          "cart_qty": num.toString(),
          "cart_price": total.toString(),
          "userid": widget.user.id,
          "sellerid": widget.itemIndex.userId
        }).then((response) {
      // print("$num $total");
      // print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Success")));
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
}
