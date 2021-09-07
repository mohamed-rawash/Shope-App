import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shop/models/http_exception.dart';
import 'package:real_shop/providers/auth.dart';
import '../models/http_exception.dart';

class AuthScreen extends StatelessWidget {
  static const String routName = "/auth";

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.blue.withOpacity(.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [1, 2],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              width: deviceSize.width,
              height: deviceSize.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      child: Text(
                        "My Shop",
                        style: TextStyle(
                          fontSize: 50,
                          fontFamily: "Anton",
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

enum AuthMode{Login, signUp}

class _AuthCardState extends State<AuthCard> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    "email":"",
    "password":"",
  };
  bool _isLoding = false;
  final _passwordController = TextEditingController();
  AnimationController _animationController;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -0.15),
      end:Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));

    _opacityAnimation = Tween<double>(
      begin:0.0,
      end:1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
  }

  @override
  void dispose() {
    super.dispose();

    _animationController.dispose();
  }

  Future<void> _submit() async {
    if(! _formKey.currentState.validate()){
      return ;
    }
    FocusScope.of(context).unfocus();
    _formKey.currentState.save();
    setState(() {
      _isLoding = true;
    });

    try{
      if (_authMode == AuthMode.Login){
        Provider.of<Auth>(context, listen: false).login(_authData["email"], _authData["password"]);
      } else{
        Provider.of<Auth>(context, listen: false).signUp(_authData["email"], _authData["password"]);
      }
    } on HttpException catch(e){
      String errorMessage = "Authentication failed";
      if(e.toString().contains("EMAIL_EXISTS")){
        errorMessage = "This email address is already in use.";
      } else if(e.toString().contains("INVALID_EMAIL")){
        errorMessage = "This is not a valid email address.";
      } else if(e.toString().contains("WEAK_PASSWORD")){
        errorMessage = "This password is too weak.";
      } else if(e.toString().contains("EMAIL_NOT_FOUND")){
        errorMessage = "Can't find this user.";
      } else if(e.toString().contains("INVALID_PASSWORD")){
        errorMessage = "Wrong password.";
      }
      _showErrorDialog(errorMessage);
    }catch(e){
      const errorMessage = "Wrong email or password, please try again later.";
      _showErrorDialog(errorMessage);
      print("ddfdfd");
    }

    setState(() {
      _isLoding = false;
    });
  }

  void _switchAuthMode(){
    if( _authMode == AuthMode.Login){
      setState(() {
        _authMode = AuthMode.signUp;
      });
      _animationController.forward();
    }else{
      setState(() {
        _authMode = AuthMode.Login;
      });
      _animationController.reverse();
    }
  }

  void _showErrorDialog(String message) {

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("An Error Occurred"),
        content: Text(message),
        actions: [
          FlatButton(
            child:Text("Okay!") ,
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 12,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.signUp?deviceSize.height * 0.5:deviceSize.height * 0.3,
        constraints: BoxConstraints(minHeight: _authMode == AuthMode.signUp?deviceSize.height * 0.47:deviceSize.height * 0.37),
        width: deviceSize.width * 0.92,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "E-Mail",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.mail, color: Colors.white, size: 24,),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value){
                    if(value.isEmpty || !value.contains("@")){
                      return "valide e-mail";
                    }return null;
                  },
                  onSaved: (value){
                    _authData["email"] = value;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.remove_red_eye, color: Colors.white, size: 24,),
                  ),
                  controller: _passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value){
                    if(value.isEmpty || value.length <= 8 ){
                      return "password is too short";
                    }return null;
                  },
                  onSaved: (value){
                    _authData["password"] = value;
                  },
                ),
                SizedBox(height: 10),
                AnimatedContainer(
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.signUp? 60:0,
                    maxHeight: _authMode == AuthMode.signUp? 60:0,
                  ),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.remove_red_eye, color: Colors.white, size: 24,),
                        ),
                        obscureText: true,
                        enabled: _authMode == AuthMode.signUp,
                        keyboardType: TextInputType.emailAddress,
                        validator: _authMode == AuthMode.signUp? (value){
                          if(value != _passwordController.text ){
                            return "password do not match";
                          }return null;
                        }:null,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if(_isLoding) CircularProgressIndicator(),
                RaisedButton(
                  child: Text(_authMode == AuthMode.signUp? "SignUp" : "Login"),
                  onPressed: _submit,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.all(10),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                ),
                SizedBox(height: 5),
                FlatButton(
                  child: Text("${_authMode == AuthMode.Login? "SignUp" : "Login"} Instead?"),
                  padding: EdgeInsets.all(8),
                  textColor: Colors.purple,
                  onPressed: _switchAuthMode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
