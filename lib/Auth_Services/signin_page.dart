import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:user_dashboard/Auth_Services/login_page.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    PatternValidator(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
        errorText: 'Email must have correct Format')
  ]);

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'least one special character')
  ]);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: globalKey,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              width: size.width * 0.9,
              child: Center(
                child: Column(
                  children: <Widget>[
                    const Text(
                      "SignIn Your Account!",
                      style: TextStyle(fontSize: 45),
                    ),
                    const SizedBox(height: 70),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[200],
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          validator: emailValidator,
                          controller: _emailController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Your Email",
                            icon: Icon(Icons.email_rounded),
                          ),
                          onChanged: (value) {},
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[200],
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          validator: passwordValidator,
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Your Password",
                            icon: Icon(Icons.vpn_key),
                          ),
                          onChanged: (value) {},
                          obscureText: true,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 70.0,
                    ),
                    Container(
                      height: size.height * 0.08,
                      width: size.width * 0.3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: Colors.deepPurple),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        splashColor: Colors.deepPurple,
                        child: const Text(
                          "Sign In",
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        onPressed: () async {
                          if (globalKey.currentState!.validate()) {
                            try {
                              _firebaseAuth
                                  .createUserWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text,
                              ).then((value) {
                                FirebaseFirestore.instance
                                    .collection('userData')
                                    .doc(value.user!.uid)
                                    .set({"email": value.user!.email});
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        const CupertinoAlertDialog(
                                          title: Text("Create Account!!",style: TextStyle(fontSize: 25),),
                                          content: Text(
                                              "The Account Created Successfully!!\n"
                                              "you Can Login Now",style: TextStyle(fontSize: 15),),
                                        ));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Account Created Successfully!!'),
                                  ),
                                );
                              });
                              FirebaseAuth auth = FirebaseAuth.instance;
                              if (_firebaseAuth.currentUser != null) {
                                print(_firebaseAuth.currentUser!.uid);
                                print(_firebaseAuth.currentUser!.emailVerified);
                              }
                              if (_firebaseAuth.currentUser!.emailVerified ==
                                  false) {
                                await _firebaseAuth.currentUser!
                                    .sendEmailVerification();
                                print('email send');
                              }
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                print('The password provided is too weak.');

                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        const CupertinoAlertDialog(
                                          title:
                                              Text("Error to Create Account!!"),
                                          content: Text(
                                              "The password provided is too weak!! \n"
                                              "Try Again!!"),
                                        ));
                              } else if (e.code == 'email-already-in-use') {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        const CupertinoAlertDialog(
                                          title:
                                              Text("Error to Create Account!!"),
                                          content: Text(
                                              "The account already exists for that email.!!\n"
                                              "Try Again!!"),
                                        ));
                                print("work checkpont exist**");
                              }
                            } catch (e) {
                              print(e);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('$e'),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        const Text("Already have an Account! "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                          },
                          child: const Text(
                            "  LogIn",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
