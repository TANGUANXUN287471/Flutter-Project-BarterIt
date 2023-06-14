import 'package:flutter/material.dart';
import 'package:barter_it/models/user.dart';
import 'package:barter_it/models/items.dart';

class EditItemScreen extends StatefulWidget {
  final User user; final Item item;
  const EditItemScreen({super.key,required this.user, required this.item});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}