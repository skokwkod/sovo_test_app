import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sovo_test_app/pages/homeView.dart';

import 'package:sovo_test_app/pages/registerView.dart';
import '../widgets/snackBars.dart';
import '../widgets/customTextField.dart';

class LoginView extends StatelessWidget {


  final TextEditingController controllerMail = TextEditingController();
  final TextEditingController controllerPass = TextEditingController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Row(
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
                'Zaloguj się',
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
                onPressed: () async {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                        email: controllerMail.text, password: controllerPass.text);


                    if (userCredential.user != null){
                      Navigator.pop(context, MaterialPageRoute(builder: (context) => HomeView()));
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'wrong-password') {
                      showSnackBar(context, "Podane hasło jest nieprawidłowe!",
                          Colors.redAccent);
                    } else if (e.code == 'invalid-email') {
                      showSnackBar(
                          context, "Podany email jest niewłaściwy", Colors.redAccent);
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                color: Colors.redAccent,
                minWidth: 200,
                child: Text("Zaloguj"),
              ),
              const SizedBox(height: 20),
              const Text('Nie masz jeszcze konta?'),
              MaterialButton(
                onPressed: ()  {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterView()));
                },

                color: Colors.greenAccent,
                minWidth: 200,
                child: const Text("Zarejestruj"),
              ),
            ],
    ),
          ),
        ],
      )
    );;
  }


}
