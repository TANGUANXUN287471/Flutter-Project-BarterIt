import 'dart:async';
import 'dart:convert';
import 'package:barter_it/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:barter_it/screens/profilepage_screen/registration.dart';
import 'package:barter_it/screens/mainscreen.dart';
import 'package:barter_it/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();
  bool _isChecked = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/login.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                height: 370,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  elevation: 8,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                    child: Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _emailEditingController,
                                validator: (val) => val!.isEmpty ||
                                        !val.contains("@") ||
                                        !val.contains(".")
                                    ? "enter a valid email"
                                    : null,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.email),
                                  labelText: "Email",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ),
                                ),
                              ),
                              TextFormField(
                                controller: _passwordEditingController,
                                validator: (val) =>
                                    val!.isEmpty || (val.length < 5)
                                        ? "password must be longer than 5"
                                        : null,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.lock),
                                  labelText: "Password",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Checkbox(
                                    value: _isChecked,
                                    onChanged: (bool? value) {
                                      saveremovepref(value!);
                                      setState(() {
                                        _isChecked = value;
                                      });
                                    },
                                  ),
                                  Flexible(
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: const Text(
                                        "Remember Me",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: MaterialButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      height: 45,
                                      elevation: 10,
                                      onPressed: onLogin,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      textColor:
                                          Theme.of(context).colorScheme.onError,
                                      child: const Text("Login"),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const RegistrationScreen()));
                },
                child: const Text(
                  "New User?",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Forget Password?",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void onLogin() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }

    String email = _emailEditingController.text;
    String password = _passwordEditingController.text;

    try {
      http.post(Uri.parse("${MyConfig().server}/barter_it/php/login_user.php"),
          body: {
            "email": email,
            "password": password,
          }).then((response) {
        debugPrint(response.body);
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == 'success') {
            User user = User.fromJson(jsondata['data']);
            debugPrint(user.name);
            debugPrint(user.email);
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Login Success")));
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (content) => MainScreen(user: user)));
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Login Failed")));
          }
        }
      }).timeout(const Duration(seconds: 5), onTimeout: () {
        // Time has run out, do what you wanted to do.
      });
    } on TimeoutException catch (_) {
      debugPrint("Time out");
    }
  }

  void saveremovepref(bool value) async {
    FocusScope.of(context).requestFocus(FocusNode());
    String email = _emailEditingController.text;
    String password = _passwordEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //if bool = true, then save preferences
    if (value) {
      if (!_formKey.currentState!.validate()) {
        _isChecked = false;
        return;
      }

      await prefs.setString('email', email);
      await prefs.setString('password', password);
      await prefs.setBool("checkbox", value);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Preferences Stored"),
      ));
    } else {
      //if bool != true, then remove from preferences
      await prefs.setString('email', '');
      await prefs.setString('password', '');
      await prefs.setBool("checkbox", false);
      setState(() {
        _emailEditingController.text = '';
        _passwordEditingController.text = '';
        _isChecked = false;
      });
    }
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('password')) ?? '';
    _isChecked = (prefs.getBool('checkbox')) ?? false;

    if(_isChecked) {
      setState(() {
        _emailEditingController.text = email;
        _passwordEditingController.text = password;
      });
    }
  }
}
