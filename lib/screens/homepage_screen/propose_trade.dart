import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:barter_it/myconfig.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barter_it/models/user.dart';
import 'package:barter_it/models/items.dart';

class ProposeTrade extends StatefulWidget {
  const ProposeTrade(
      {super.key,
      required this.user,
      required this.itemIndex,
      required this.num,
      required this.total});
  final User user;
  final Item itemIndex;
  final int num;
  final int total;
  @override
  State<ProposeTrade> createState() => _ProposeTradeState();
}

class _ProposeTradeState extends State<ProposeTrade> {
  String name = '', phone = '', email = '', datereg = '';
  List<Item> itemList = <Item>[];
  var _selectedItem;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTradeItems();
    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Propose Trade"),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 5,
            child: Padding(
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
                                title: Text(name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Registered  $datereg")),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        height: 120,
                                        width: 180,
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            "${MyConfig().server}/barter_it/assets/items/${widget.itemIndex.itemId}_1.png",
                                        placeholder: (context, url) =>
                                            const LinearProgressIndicator(),
                                        errorWidget: (context, url, error) =>
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(16, 0, 4, 0),
                                    title: Text(
                                        widget.itemIndex.itemName.toString(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.none,
                                        )),
                                    subtitle: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(widget.itemIndex.itemDesc
                                            .toString()),
                                        const SizedBox(height: 10),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text("RM ${widget.total}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                              )),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            margin: const EdgeInsets.all(4),
                                            padding: const EdgeInsets.fromLTRB(
                                                12, 4, 12, 4),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child:
                                                Text("Quantity: ${widget.num}"),
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
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
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
                            title: Text("Hi, ${widget.user.name}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                    DropdownButton<Item>(
                      value: _selectedItem,
                      hint: const Text('Select an item'),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedItem = newValue;
                        });
                      },
                      items: itemList.map((item) {
                        return DropdownMenuItem<Item>(
                          value: item,
                          child: Text(item.itemName.toString()),
                        );
                      }).toList(),
                    ),
                    if (_selectedItem != null) ...[
                      Row(
                        children: [
                          Flexible(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      height: 120,
                                      width: 180,
                                      fit: BoxFit.cover,
                                      imageUrl:
                                          "${MyConfig().server}/barter_it/assets/items/${_selectedItem.itemId}_1.png",
                                      placeholder: (context, url) =>
                                          const LinearProgressIndicator(),
                                      errorWidget: (context, url, error) =>
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(16, 0, 4, 0),
                                  title: Text(_selectedItem.itemName.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.none,
                                      )),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(_selectedItem.itemDesc
                                              .toString())),
                                      const SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            "RM ${_selectedItem.itemValue}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            )),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          margin: const EdgeInsets.all(4),
                                          padding: const EdgeInsets.fromLTRB(
                                              12, 4, 12, 4),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Text(
                                              "Quantity Available: ${_selectedItem.itemQty}"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius:
              const BorderRadius.vertical(top: Radius.elliptical(16, 12)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Quantity: ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 80,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0),
                      ),
                    ),
                    controller: _controller,
                    keyboardType: TextInputType.number,
                  ),
                )
              ],
            ),
            trailing: MaterialButton(
              textColor: Colors.white,
              padding: const EdgeInsets.all(16),
              color: Colors.teal[300],
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onPressed: () {
                setState(() {
                  if (int.parse(_controller.text) <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please Enter the Correct Amount !")));
                  } else if (int.parse(_controller.text) >
                      int.parse(_selectedItem.itemQty)) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Exceed Quantity Available !")));
                  } else {
                    uploadProposeDialog();
                  }
                });
              },
              child: const Text(
                "Propose Trade",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void loadUser() {
    http.post(Uri.parse("${MyConfig().server}/barter_it/php/load_user.php"),
        body: {
          "userid": widget.itemIndex.userId.toString(),
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

  void loadTradeItems() {
    http.post(Uri.parse("${MyConfig().server}/barter_it/php/load_items.php"),
        body: {
          "userid": widget.user.id.toString(),
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
          debugPrint(itemList[0].itemName);
        }
        setState(() {});
      }
    });
  }

  void uploadProposeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Propose Trade?",
            style: TextStyle(),
          ),
          content: const Text("Confirm to proceed", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                uploadPropose();
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

  void uploadPropose() {
    int qty = int.parse(_controller.text);
    int totalvalue = qty * int.parse(_selectedItem.itemValue);
    debugPrint("$totalvalue");

    http.post(Uri.parse("${MyConfig().server}/barter_it/php/uploadpropose.php"),
        body: {
          "seller_item_id": widget.itemIndex.itemId.toString(),
          "seller_item_name": widget.itemIndex.itemName.toString(),
          "seller_item_qty": widget.num.toString(),
          "seller_item_value": widget.total.toString(),
          "seller_item_desc": widget.itemIndex.itemDesc.toString(),
          "propose_item_id": _selectedItem.itemId.toString(),
          "propose_item_name": _selectedItem.itemName.toString(),
          "propose_item_qty": qty.toString(),
          "propose_item_value": totalvalue.toString(),
          "propose_item_desc": _selectedItem.itemDesc.toString(),
          "user_id": widget.user.id.toString(),
          "seller_id": widget.itemIndex.userId.toString(),
        }).then((response) {
      // print("$num $total");
      
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        debugPrint(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Propose Trade Success")));
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
