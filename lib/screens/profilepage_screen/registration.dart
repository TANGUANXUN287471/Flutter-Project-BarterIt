import 'dart:convert';
import 'package:barter_it/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:barter_it/screens//profilepage_screen/login.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final TextEditingController _password2EditingController =
      TextEditingController();
  bool isChecked = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("User Registration"),
        backgroundColor: Colors.white60,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/registration.jpg"),
                  fit: BoxFit.fitHeight),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 250,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    elevation: 12,
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            "Registration Form",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  validator: (value) =>
                                      value!.isEmpty || (value.length < 5)
                                          ? "Name must longer than 5"
                                          : null,
                                  keyboardType: TextInputType.text,
                                  controller: _nameEditingController,
                                  decoration: const InputDecoration(
                                    labelText: "Name",
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.person),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  validator: (value) => value!.isEmpty ||
                                          (value.length < 10)
                                      ? "Phone Number must longer than or equal 10"
                                      : null,
                                  keyboardType: TextInputType.phone,
                                  controller: _phoneEditingController,
                                  decoration: const InputDecoration(
                                    labelText: "Phone",
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.phone),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  validator: (value) => value!.isEmpty ||
                                          !value.contains("@") ||
                                          !value.contains(".")
                                      ? "Please enter a valid Email"
                                      : null,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailEditingController,
                                  decoration: const InputDecoration(
                                    labelText: "E-mail",
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.email),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  validator: (value) =>
                                      value!.isEmpty || (value.length < 5)
                                          ? "Password must longer than 5"
                                          : null,
                                  obscureText: true,
                                  controller: _passwordEditingController,
                                  decoration: const InputDecoration(
                                    labelText: "Password",
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.lock),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  validator: (value) =>
                                      value!.isEmpty || (value.length < 5)
                                          ? "Password must longer than 5"
                                          : null,
                                  obscureText: true,
                                  controller: _password2EditingController,
                                  decoration: const InputDecoration(
                                    labelText: "Re-enter Password",
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.lock),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Checkbox(
                                        value: isChecked,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            isChecked = value!;
                                          });
                                        }),
                                    Flexible(
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: const Text(
                                          "Agree with Terms",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: onRegisterDialog,
                                        child: const Text("Register"),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const LoginScreen()));
                  },
                  child: const Text(
                    "Already Register? Login Here",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onRegisterDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your Input")));
      return;
    }
    if (!isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please agree with terms and conditions")));
      return;
    }
    String password = _passwordEditingController.text;
    String password2 = _password2EditingController.text;
    if (password2 != password) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your Password")));
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          title: const Text(
            "Register New Account?",
            style: TextStyle(),
          ),
          content: const Text("Confirm to create account"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                registerUser();
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

  void registerUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Please Wait..."),
          content: Text("Registration"),
        );
      },
    );
    String name = _nameEditingController.text;
    String phone = _phoneEditingController.text;
    String email = _emailEditingController.text;
    String password = _passwordEditingController.text;

    http.post(Uri.parse("${MyConfig().server}/barter_it/php/register_user.php"),
        body: {
          "name": name,
          "phone": phone,
          "email": email,
          "password": password,
        }).then((response) {
      debugPrint(response.body);

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);

        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Successful")));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Failed")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Registration Failed")));
        Navigator.pop(context);
      }
    });
  }
}
