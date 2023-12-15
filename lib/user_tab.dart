import 'package:flutter/material.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UserTab extends StatefulWidget {
  const UserTab({
    super.key,
  });

  @override
  State<UserTab> createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {
  String loginUserName = '';
  String loginPassword = '';
  String registUserName = '';
  String registPassword = '';
  String registPasswordAgain = '';

  CollectionReference usersCollection = Firestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.isSignedIn) {
      // signed in
      return FutureBuilder(
        future: FirebaseAuth.instance.getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // todo: show user data
            return Center(
              child: OutlinedButton(
                child: const Text('Sign out'),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  setState(() {});
                },
              ),
            );
          } else {
            return const Center(
              child: SpinKitDancingSquare(
                color: Colors.white,
              ),
            );
          }
        },
      );
    } else {
      // not signed in
      return loginAndRegistForm(MediaQuery.of(context).size.height > MediaQuery.of(context).size.width);
    }
  }

  Widget loginAndRegistForm(bool isTaller) {
    var list = [
      Container(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Sign in', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextField(
                decoration: const InputDecoration(labelText: 'username'),
                onChanged: (value) => setState(() {
                      loginUserName = value;
                    })),
            TextField(
                obscureText: true,
                decoration: const InputDecoration(labelText: 'password'),
                onChanged: (value) => setState(() {
                      loginPassword = value;
                    })),
            const SizedBox(height: 20),
            OutlinedButton(
              child: const Text('Sign in'),
              onPressed: () async {
                await FirebaseAuth.instance.signIn('$loginUserName@qu2s.com', loginPassword);
                setState(() {});
              },
            ),
          ],
        ),
      ),
      const SizedBox(
        width: 40,
        height: 80,
      ),
      Container(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Regist', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextField(
                decoration: const InputDecoration(labelText: 'username'),
                onChanged: (value) => setState(() {
                      registUserName = value;
                    })),
            TextField(
                obscureText: true,
                decoration: const InputDecoration(labelText: 'password'),
                onChanged: (value) => setState(() {
                      registPassword = value;
                    })),
            TextField(
                obscureText: true,
                decoration: const InputDecoration(labelText: 'password again'),
                onChanged: (value) => setState(() {
                      registPasswordAgain = value;
                    })),
            const SizedBox(height: 20),
            OutlinedButton(
              child: const Text('Regist'),
              onPressed: () async {
                if (registPassword == registPasswordAgain) {
                  await FirebaseAuth.instance.signUp('$registUserName@qu2s.com', registPassword);
                }
                setState(() {});
              },
            ),
          ],
        ),
      ),
    ];

    if (isTaller) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: list,
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: list,
      );
    }
  }
}
