import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:user_dashboard/Auth_Services/homepage.dart';
import 'package:user_dashboard/Auth_Services/signin_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    PatternValidator(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
        errorText: 'Email must have correct Format')
  ]);

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: 'least one special character')
  ]);


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title:const Text("Log In to DashBoard"),),

      body: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: globalKey,
          child: Center(
            child: Container( padding:const EdgeInsets.all(10),width: size.width * 0.9,
              child: Center(
                child: Column(

                  children: <Widget>
                  [

                   const Padding(
                      padding: EdgeInsets.only(top:20.0),
                      child: Text("Login Your Account!",style: TextStyle(fontSize: 30),),
                    ),
                    const SizedBox(height: 60),

                    Container( decoration: BoxDecoration(color: Colors.deepPurple[200],
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

                          onChanged: (value){},

                          keyboardType: TextInputType.emailAddress,

                        ),
                      ),
                    ),

                    const SizedBox(height: 30.0,),


                    Container( decoration: BoxDecoration(color: Colors.deepPurple[200],
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

                          onChanged: (value){},
                          obscureText: true,

                          keyboardType: TextInputType.text,

                        ),
                      ),
                    ),

                    const SizedBox(height: 60.0,),


                    Container(
                      height: size.height * 0.075,
                      width: size.width * 0.48,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(32),color: Colors.deepPurple),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                        splashColor: Colors.deepPurple,
                        child:const Text("Log in",style: TextStyle(color: Colors.white,fontSize: 25),),
                        onPressed: ()async{
                          // UserCredential userCredential =await FirebaseAuth.instance.signInWithEmailAndPassword(
                          //     email: _emailController.text, password: _passwordController.text);
                          if(globalKey.currentState!.validate()) {
                            try {
                              UserCredential userCredential = await FirebaseAuth
                                  .instance.signInWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                print('No user found for that email.');
                              } else if (e.code == 'wrong-password') {
                                print('Wrong password provided for that user.');
                              }
                            }
                          }

                        },
                      ),
                    ),

                    const SizedBox(height: 25.0,),

                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        const Text(" Create An Account!   "),

                        GestureDetector(onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context)=> const SigninPage()));
                        },
                            child: const Text("Sign IN",style: TextStyle(color: Colors.blue,decoration: TextDecoration.underline),),
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
