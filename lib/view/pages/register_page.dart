import 'package:another_flushbar/flushbar.dart';
import 'package:bill_app/global/constants.dart';
import 'package:bill_app/model/core/customer.dart';
import 'package:bill_app/provider/auth_provider.dart';
import 'package:bill_app/provider/customer_provider.dart';
import 'package:bill_app/view/widgets/login_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = new GlobalKey<FormState>();

  String? _name, _phoneNumber, _avatar, _address, _password;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final usernameField = TextFormField(
      autofocus: false,
      validator: (value) =>
          value != null && value.isEmpty ? "Please enter your name" : null,
      onSaved: (value) => _name = value,
      decoration: buildInputDecoration("Your username", Icons.person),
    );

    final avatarField = TextFormField(
      autofocus: false,
      validator: (value) =>
          value != null && value.isEmpty ? "Please enter avatar" : null,
      onSaved: (value) => _avatar = value,
      decoration: buildInputDecoration("Your avatar", Icons.image),
    );

    final addressField = TextFormField(
      autofocus: false,
      validator: (value) =>
          value != null && value.isEmpty ? "Please enter address" : null,
      onSaved: (value) => _address = value,
      decoration: buildInputDecoration("Your address", Icons.location_city),
    );

    final phoneNumberField = TextFormField(
      autofocus: false,
      validator: (value) =>
          value != null && value.isEmpty ? "Please enter your phone" : null,
      onSaved: (value) => _phoneNumber = value,
      decoration: buildInputDecoration("Your phone number", Icons.phone),
    );

    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) =>
          value != null && value.isEmpty ? "Please enter password" : null,
      onSaved: (value) => _password = value,
      decoration: buildInputDecoration("Confirm password", Icons.lock),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Registering ... Please wait")
      ],
    );

    var doRegister = () {
      final form = formKey.currentState!;
      if (form.validate()) {
        form.save();
        auth
            .register(_name, _phoneNumber, _avatar, _address, _password)
            .then((response) async {
          if (response['status']) {
            print("=============status true======");
            Customer customer = response['data'];
            print("==============customer" + customer.customerId.toString());
            await Provider.of<CustomerProvider>(context, listen: false)
                .setCustomer(customer);
            print("==============set Customer pref done===========");
            Navigator.pushNamed(context, mainRoute);
            print("==============Navigate===========");
          } else {
            Flushbar(
              title: "Registration Failed",
              message: response.toString(),
              duration: Duration(seconds: 10),
            ).show(context);
          }
        });
      } else {
        Flushbar(
          title: "Invalid form",
          message: "Please Complete the form properly",
          duration: Duration(seconds: 10),
        ).show(context);
      }
    };

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.0),
                  label("User name"),
                  SizedBox(height: 5.0),
                  usernameField,
                  SizedBox(height: 15.0),
                  label("Avatar"),
                  SizedBox(height: 5.0),
                  avatarField,
                  SizedBox(height: 15.0),
                  label("Address"),
                  SizedBox(height: 5.0),
                  addressField,
                  SizedBox(height: 15.0),
                  label("Phone number"),
                  SizedBox(height: 5.0),
                  phoneNumberField,
                  SizedBox(height: 15.0),
                  label("Password"),
                  SizedBox(height: 10.0),
                  passwordField,
                  SizedBox(height: 20.0),
                  auth.loggedInStatus == Status.Authenticating
                      ? loading
                      : longButtons("Register", doRegister),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
