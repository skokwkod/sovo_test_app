import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sovo_test_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sovo_test_app/pages/homeView.dart';

import 'package:sovo_test_app/pages/loginView.dart';
import '../widgets/snackBars.dart';
import '../widgets/customTextField.dart';

class RegisterView extends StatelessWidget {
  final TextEditingController controllerMail = TextEditingController();
  final TextEditingController controllerPass = TextEditingController();

  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Zarejestruj się',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 40,
                  ),
                ),
                const SizedBox(height: 50),
                CustomTextField(
                    controller: controllerMail,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    label: "E-Mail"),
                const SizedBox(height: 10),
                CustomTextField(
                    controller: controllerPass,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    label: "Hasło"),
                MaterialButton(
                  color: Colors.redAccent,
                  minWidth: 200,
                  onPressed: () async {
                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                              email: controllerMail.text,
                              password: controllerPass.text);

                      FirebaseAuth.instance.authStateChanges().listen(
                        (User? user) {
                          if (user != null) {
                            final userPoints = <String, dynamic>{
                              "uid": user?.uid,
                              "points": "3",
                            };
                            var db = FirebaseFirestore.instance;
                            db.collection("users_points").doc(userCredential.user?.uid).set(userPoints).onError((e, _) => print("Error writing document: $e"));

                            Navigator.pop(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyHomePage()));
                          }
                          ;
                        },
                      );
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        showSnackBar(context, "Podane hasło jest za proste!",
                            Colors.redAccent);
                      } else if (e.code == 'email-already-in-use') {
                        showSnackBar(context, "Podany email już istneje",
                            Colors.greenAccent);
                      } else if (e.code == 'invalid-email') {
                        showSnackBar(context, "Podany email jest niewłaściwy",
                            Colors.redAccent);
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text("Zarejestruj"),
                ),
                SizedBox(height: 20),
                Text('Masz już konto?'),
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context,
                        MaterialPageRoute(builder: (context) => LoginView()));
                  },
                  color: Colors.greenAccent,
                  minWidth: 200,
                  child: Text("Przejdź do logowania"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
