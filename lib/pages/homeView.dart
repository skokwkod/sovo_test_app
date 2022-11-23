import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:sovo_test_app/models/users_points.dart';
import 'package:sovo_test_app/services/adMobServices.dart';
import '../widgets/snackBars.dart';
import 'loginView.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var db = FirebaseFirestore.instance;

  RewardedAd? _rewardedAd;

  final List<String> _todoList = <String>[];
  final TextEditingController _textFieldController = TextEditingController();

  // late AdmobReward rewardAd;

  int userPoints = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Witaj ${(auth.currentUser?.email).toString()}'),
        actions: [
          Text(
            'Twoje Punkty\n${userPoints}',
            textAlign: TextAlign.center,
          ),
          IconButton(
            onPressed: () {
              auth.signOut().then((value) => {
                    Navigator.pop(context,
                        MaterialPageRoute(builder: (context) => LoginView())),
                    showSnackBar(context, 'Zostałeś poprawnie wylogowany',
                        Colors.greenAccent)
                  });
            },
            icon: Icon(Icons.account_box_outlined),
          ),
          IconButton(
              onPressed: () {
                auth.signOut().then((value) => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginView())),
                      showSnackBar(context, 'Zostałeś poprawnie wylogowany',
                          Colors.greenAccent)
                    });
              },
              icon: Icon(Icons.exit_to_app_outlined)),
        ],
      ),
      body: FutureBuilder(builder: (context, snapshot) {
        if (_todoList.isEmpty) {
          return Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(28.0),
                      child: Text('Jeszcze nie dodałeś żadnego zadania...',
                          style: TextStyle(
                            fontSize: 30,
                            wordSpacing: 6,
                          )),
                    ),
                    CircleAvatar(
                      radius: 100,
                      backgroundImage: AssetImage('lib/assets/lazy_cat.jpg'),
                    )
                  ],
                ),
              ],
            ),
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  children: _getItems(),
                  padding: EdgeInsets.all(28.0),
                ),
              ),
            ],
          );
        }
      }),
      floatingActionButton: _getFloatingActionButton(),
    );
  }

  List<Widget> _getItems() {
    final List<Widget> _todoWidgets = <Widget>[];
    for (String title in _todoList) {
      _todoWidgets.add(_buildTodoItem(title));
    }
    return _todoWidgets;
  }

  Widget _buildTodoItem(String title) {
    return Card(
        child: ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          IconButton(onPressed: () => _deleteToDoItem(title), icon: Icon(Icons.delete))
        ],
      ),
      tileColor: Colors.redAccent,
    ));
  }

  Future<Future> _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Dodaj zadanie do swojej listy'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: 'Wprowadź zadanie'),
            ),
            actions: <Widget>[
              MaterialButton(
                child: const Text('Anuluj'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              MaterialButton(
                child: const Text('Dodaj zadanie'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _addTodoItem(_textFieldController.text);
                  _setPoints(auth.currentUser?.uid.toString(), userPoints - 1);
                },
              ),
            ],
          );
        });
  }

  void _addTodoItem(String title) {
    setState(() {
      _todoList.add(title);
    });
    _textFieldController.clear();
  }

  void _deleteToDoItem(String item){
    setState(() {
      _todoList.remove(item);
    });
  }
  void _updateToDoItem(String item){
    show
  }

  void _getPoints(String? uid) async {
    var snapshot = await db.collection("users_points").doc(uid).get();
    int data = int.parse(snapshot.get('points').toString());

    setState(() {
      userPoints = data;
    });
  }

  Future<void> _setPoints(String? uid, int newValue) async {
    await db.collection("users_points").doc(uid).update({'points': newValue});

    _getPoints(uid);
  }

  Widget _getFloatingActionButton() {
    print(userPoints);
    print(auth.currentUser?.uid.toString());
    if (userPoints > 0) {
      return FloatingActionButton.extended(
        onPressed: () => _displayDialog(context),
        label: Text('Dodaj Zadanie'),
        icon: Icon(Icons.add),
      );
    } else {
      return FloatingActionButton.extended(
        onPressed: () => _showRewardedAd(),
        label: Text('Dodaj punkty'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
      );
    }
  }

  void _createRewardedAdd() {
    print('createRewardedAdd');
    RewardedAd.load(
        adUnitId: AdMobService.rewardedAdUnitId!,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) => setState(() => _rewardedAd = ad),
          onAdFailedToLoad: (error) => setState(() => _rewardedAd = null),
        ));
    print (_rewardedAd);
  }

  void _showRewardedAd() {
    print("showRewarded");
    print(_rewardedAd);
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createRewardedAdd();
          print('ad:${ad}');
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createRewardedAdd();
          print('error: ${error}');
        },
      );
      _rewardedAd!.show(
          onUserEarnedReward: (ad, reward) => setState(() => userPoints + 3));
      _rewardedAd = null;
    }
  }

  @override
  void initState() {
    _getPoints(auth.currentUser?.uid.toString());
    _createRewardedAdd();
  }
}
