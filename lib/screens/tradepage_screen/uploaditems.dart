import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:barter_it/myconfig.dart';
import 'package:barter_it/models/user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class UploadItems extends StatefulWidget {
  final User user;
  const UploadItems({super.key, required this.user});

  @override
  State<UploadItems> createState() => _UploadItemsState();
}

class _UploadItemsState extends State<UploadItems> {
  File? _image;
  File? _image2;
  File? _image3;
  File? _image4;
  var pathAsset = "assets/images/upload2.jpg";
  var pathAsset2 = "assets/images/add.png";
  final _formKey = GlobalKey<FormState>();
  final ImagePicker imgpicker = ImagePicker();

  final TextEditingController _itemNameEditingController =
      TextEditingController();
  final TextEditingController _itemDescEditingController =
      TextEditingController();
  final TextEditingController _itemValueEditingController =
      TextEditingController();
  final TextEditingController _itemQuantityEditingController =
      TextEditingController();
  final TextEditingController _stateEditingController = TextEditingController();
  final TextEditingController _localEditingController = TextEditingController();

  String selectedType = "Electronic Devices";
  List<String> itemsList = [
    "Electronic Devices",
    "Car Accessories",
    "Computer & Tech",
    "Food & Drinks",
    "Toys",
    "Furniture",
    "HealthCare ",
    "Entertainment",
    "Sport Equipment",
    "Daily Use",
    "Others"
  ];

  String conditionsType = "New";
  List<String> conditions = [
    "New",
    "Used",
  ];

  late Position _currentPosition;

  String curaddress = "";
  String curstate = "";
  String prlat = "";
  String prlong = "";

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Items"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 5),
          const Text(
            "Tap to upload photos.",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
          Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 10,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _selectAndCropImage(1);
                      },
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: _image == null
                                ? AssetImage(pathAsset)
                                : FileImage(_image!) as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        _selectAndCropImage(2);
                      },
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: _image2 == null
                                ? AssetImage(pathAsset)
                                : FileImage(_image2!) as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        _selectAndCropImage(3);
                      },
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: _image3 == null
                                ? AssetImage(pathAsset)
                                : FileImage(_image3!) as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        _selectAndCropImage(4);
                      },
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: _image4 == null
                                ? AssetImage(pathAsset)
                                : FileImage(_image4!) as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("About the Item",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.type_specimen),
                          const SizedBox(width: 16),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.black38, width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 30, right: 30),
                              child: DropdownButton(
                                value: selectedType,
                                items: itemsList.map((selectedType) {
                                  return DropdownMenuItem(
                                    value: selectedType,
                                    child: Text(selectedType),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedType = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.black38, width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 30, right: 30),
                              child: DropdownButton(
                                value: conditionsType,
                                items: conditions.map((conditionsType) {
                                  return DropdownMenuItem(
                                    value: conditionsType,
                                    child: Text(conditionsType),
                                  );
                                }).toList(),
                                onChanged: (value1) {
                                  setState(() {
                                    conditionsType = value1!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          validator: (val) => val!.isEmpty || (val.length < 3)
                              ? "Item name must be longer than 3"
                              : null,
                          onFieldSubmitted: (val) {},
                          controller: _itemNameEditingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'Item Name',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.abc),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (val) => val!.isEmpty
                            ? "Item description must be longer than 10"
                            : null,
                        onFieldSubmitted: (v) {},
                        maxLines: 4,
                        controller: _itemDescEditingController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Item Description',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(),
                            icon: Icon(
                              Icons.description,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            )),
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                validator: (val) => val!.isEmpty
                                    ? "Product price must contain value"
                                    : null,
                                onFieldSubmitted: (v) {},
                                controller: _itemValueEditingController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: "Item Value",
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.attach_money),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ))),
                          ),
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) => val!.isEmpty
                                  ? "Quantity should be more than 0"
                                  : null,
                              controller: _itemQuantityEditingController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Item Quantity',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.numbers),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 80,
                        child: Row(children: [
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                validator: (val) =>
                                    val!.isEmpty || (val.length < 3)
                                        ? "Current State"
                                        : null,
                                enabled: false,
                                controller: _stateEditingController,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    labelText: 'Current State',
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.flag),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ))),
                          ),
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                enabled: false,
                                validator: (val) =>
                                    val!.isEmpty || (val.length < 3)
                                        ? "Current Locality"
                                        : null,
                                controller: _localEditingController,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    labelText: 'Current Locality',
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.map),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ))),
                          ),
                        ]),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () {
                              insertDialog();
                            },
                            child: const Text("Upload Item")),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _selectAndCropImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1200,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      await _cropImage(image, index);
    } else {
      debugPrint('No image selected.');
    }
  }

  Future<void> _cropImage(File image, int index) async {
    // ignore: unnecessary_null_comparison
    if (image != null) {
      CroppedFile? cropped = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop',
            cropGridColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(title: 'Crop'),
        ],
      );

      if (cropped != null) {
        setState(() {
          switch (index) {
            case 1:
              _image = File(cropped.path);
              break;
            case 2:
              _image2 = File(cropped.path);
              break;
            case 3:
              _image3 = File(cropped.path);
              break;
            case 4:
              _image4 = File(cropped.path);
              break;
          }
        });
      }
    }
  }

  void insertDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }
    if (_image == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please take picture")));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Upload your Item?",
            style: TextStyle(),
          ),
          content: const Text("Confirm to upload", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                passItem();
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

  void passItem() {
    String itemName = _itemNameEditingController.text;
    String itemDesc = _itemDescEditingController.text;
    String itemValue = _itemValueEditingController.text;
    String itemQty = _itemQuantityEditingController.text;
    String state = _stateEditingController.text;
    String locality = _localEditingController.text;
    String base64Image = base64Encode(_image!.readAsBytesSync());
    String base64Image2 = base64Encode(_image2!.readAsBytesSync());
    String base64Image3 = base64Encode(_image3!.readAsBytesSync());
    String base64Image4 = base64Encode(_image4!.readAsBytesSync());

    http.post(Uri.parse("${MyConfig().server}/barter_it/php/upload_item.php"),
        body: {
          "userid": widget.user.id.toString(),
          "itemName": itemName,
          "itemDesc": itemDesc,
          "itemValue": itemValue,
          "itemQty": itemQty,
          "type": selectedType,
          "condition": conditionsType,
          "latitude": prlat,
          "longitude": prlong,
          "state": state,
          "locality": locality,
          "image": base64Image,
          "image2": base64Image2,
          "image3": base64Image3,
          "image4": base64Image4,
        }).then((response) {
      debugPrint(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Upload Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Upload Failed")));
        }
        setState(() {
          Navigator.pop(context);
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Upload Failed")));
        Navigator.pop(context);
      }
    });
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    _currentPosition = await Geolocator.getCurrentPosition();

    _getAddress(_currentPosition);
    //return await Geolocator.getCurrentPosition();
  }

  _getAddress(Position pos) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks.isEmpty) {
      _localEditingController.text = "Changlun";
      _stateEditingController.text = "Kedah";
      prlat = "6.443455345";
      prlong = "100.05488449";
    } else {
      _localEditingController.text = placemarks[0].locality.toString();
      _stateEditingController.text =
          placemarks[0].administrativeArea.toString();
      prlat = _currentPosition.latitude.toString();
      prlong = _currentPosition.longitude.toString();
    }
  }
}
