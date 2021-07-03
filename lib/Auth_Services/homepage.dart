import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('userData');

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('userData').snapshots();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool showData = false;
  dynamic height;

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    final dynamic userEmail = auth.currentUser!.email;
    print(userEmail);
    super.setState(fn);
  }



  @override
  void initState() {
    // TODO: implement initState
    final dynamic usermai = auth.currentUser!.email;
    print(usermai);
    height = 70.0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // ignore: file_names
      appBar: AppBar(
        title: const Text("User DashBoard"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(
                  "All Users Detail",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),

              Padding(
                padding: const EdgeInsets.only(
                    right: 25.0, bottom: 500.0, left: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade500,
                          spreadRadius: 0.0,
                          blurRadius: 10,
                          offset: const Offset(3.0, 3.0)),
                      BoxShadow(
                          color: Colors.grey.shade500,
                          spreadRadius: 0.0,
                          blurRadius: 10 / 2.0,
                          offset: const Offset(3.0, 3.0)),
                      const BoxShadow(
                          color: Colors.white,
                          spreadRadius: 2.0,
                          blurRadius: 10,
                          offset: Offset(-3.0, -3.0)),
                      const BoxShadow(
                          color: Colors.white,
                          spreadRadius: 2.0,
                          blurRadius: 10 / 2,
                          offset: Offset(-3.0, -3.0)),
                    ],
                  ),
                  height: size.height * 0.70,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _usersStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CupertinoActivityIndicator(
                            radius: 60,
                          ),
                        );
                      }

                      return ListView(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0,bottom: 8.0,left: 20.0,right: 20.0),
                            child: data['email'] != auth.currentUser!.email ? AnimatedContainer(
                              duration: const Duration(seconds: 4),
                              height: height,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.deepPurple[200]),
                              child:ListTile(
                                      title: Text(data['email']),
                                      subtitle: const Text("Email Address"),
                                    )
                                  ,
                            ): null,
                          );
                        }).toList(),
                      );
                    },
                  ),
                  // ignore: avoid_unnecessary_containers
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
