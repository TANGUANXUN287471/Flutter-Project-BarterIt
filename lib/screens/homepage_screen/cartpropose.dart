import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barter_it/models/user.dart';
import 'package:barter_it/models/cart.dart';
import 'package:http/http.dart' as http;
import '../../myconfig.dart';

class ProposeTradeCart extends StatefulWidget {
  const ProposeTradeCart({super.key, required this.user});
  final User user;

  @override
  State<ProposeTradeCart> createState() => _ProposeTradeCartState();
}

class _ProposeTradeCartState extends State<ProposeTradeCart> {
  String title = "Propose Trade Cart";
  List<Cart> proposeList = <Cart>[];
  @override
  void initState() {
    super.initState();
    loadcart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView.separated(
            itemBuilder: (context, index) {
              return Card(
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            flex: 3,
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0,
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "${MyConfig().server}/barter_it/assets/items/${proposeList[index].itemId}_1.png",
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: proposeList.length));
  }

  void loadcart() {
    http.post(Uri.parse("${MyConfig().server}/barter_it/php/loadcart.php"),
        body: {
          "userid": widget.user.id,
        }).then((response) {
      log(response.body);
      proposeList.clear();

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['carts'].forEach((v) {
            proposeList.add(Cart.fromJson(v));
          });
        }

        setState(() {});
      }
    });
  }
}
