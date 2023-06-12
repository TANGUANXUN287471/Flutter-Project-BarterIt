import 'package:flutter/material.dart';
import 'profilepage_screen/login.dart';
import 'profilepage_screen/registration.dart';
import 'package:barter_it/models/user.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late double screenHeight, screenWidth, cardwitdh;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              /// -- IMAGE
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const Image(
                            image: AssetImage("assets/images/profile.jpg"))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.teal[200]),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(widget.user.name.toString(),
                  style: Theme.of(context).textTheme.headline5),
              Text(widget.user.email.toString()),
              Text("Phone: ${widget.user.phone.toString()}"),
              Text(widget.user.datereg.toString()),
              const SizedBox(height: 20),

              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => const LoginScreen(),
                  style: ElevatedButton.styleFrom(
                      side: BorderSide.none, shape: const StadiumBorder()),
                  child: const Text("Edit Profile", style: TextStyle()),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black38, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => const LoginScreen(),
                      ),
                    );
                  },
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.teal,
                    ),
                    child: const Icon(Icons.settings, color: Colors.amber),
                  ),
                  title: const Text("Login",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  trailing: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: const Icon(Icons.arrow_right_alt_sharp,
                        size: 18.0, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black38, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => const RegistrationScreen(),
                      ),
                    );
                  },
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.teal,
                    ),
                    child: const Icon(Icons.settings, color: Colors.amber),
                  ),
                  title: const Text("Registration",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  trailing: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: const Icon(Icons.arrow_right_alt_sharp,
                        size: 18.0, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black38, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  onTap: () {},
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.teal,
                    ),
                    child: const Icon(Icons.settings, color: Colors.amber),
                  ),
                  title: const Text("Settings",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  trailing: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: const Icon(Icons.arrow_right_alt_sharp,
                        size: 18.0, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
