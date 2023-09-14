import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_php/main.dart';
import 'package:http/http.dart' as http;

import '../utility/text_field.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final textKey = GlobalKey<FormState>();
  TextEditingController _username = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _password = TextEditingController();

  late bool status;
  late String message;

  @override
  void initState() {
    _username = TextEditingController();
    _email = TextEditingController();
    _phone = TextEditingController();
    _password = TextEditingController();

    status = false;
    message = '';

    super.initState();
  }

  Future submit() async {
    var url = "http://$iPAddress/registration.php";
    Map mapedData = {
      'username': _username.text,
      'email': _email.text,
      'phone': _phone.text,
      'password': _password.text,
    };

    http.Response response = await http.post(Uri.parse(url), body: mapedData);
    var data = jsonDecode(response.body);
    var responseMessage = data["message"];
    var responseError = data["error"];
    if (responseError) {
      setState(() {
        status = false;
        message = responseMessage;
      });
    } else {
      _username.clear();
      _password.clear();
      _email.clear();
      _phone.clear();
      setState(() {
        status = true;
        message = responseMessage;
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => LoginPage()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('R E G I S T R A T I O N'),
      ),
      body: Form(
        key: textKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTFF(
                controller: _username,
                hintText: 'USERNAME',
                validator: (value) {
                  if (value.isEmpty) {
                    return "Username cannot be empty";
                  }
                },
              ),
              CustomTFF(
                controller: _email,
                hintText: 'EMAIL',
                validator: (value) {
                  if (value.isEmpty) {
                    return "email cannot be empty";
                  }
                },
              ),
              CustomTFF(
                controller: _phone,
                hintText: 'PHONE',
                validator: (value) {
                  if (value.isEmpty) {
                    return "phone cannot be empty";
                  }
                },
              ),
              CustomTFF(
                controller: _password,
                hintText: 'PASSWORD',
                validator: (value) {
                  if (value.isEmpty) {
                    return "password cannot be empty";
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  if (textKey.currentState!.validate()) {
                    setState(() {
                      submit();
                    });
                  }
                },
                child: const Text('REGISTER'),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(status ? message : message),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                child: const Text('LOGIN'),
              )
            ],
          ),
        ),
      ),
    );
  }
}