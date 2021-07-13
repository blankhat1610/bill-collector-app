import 'package:another_flushbar/flushbar.dart';
import 'package:bill_app/global/constants.dart';
import 'package:bill_app/model/core/customer.dart';
import 'package:bill_app/provider/auth_provider.dart';
import 'package:bill_app/provider/customer_provider.dart';
import 'package:bill_app/view/widgets/login_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String? _phoneNumber, _password;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final phoneNumberField = TextFormField(
      autofocus: false,
      validator: (value) => value != null && value.isEmpty ? "Please enter phone number" : null,
      onSaved: (value) => _phoneNumber = value,
      decoration: buildInputDecoration("Phone number", Icons.phone),
    );

    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) => value != null && value.isEmpty ? "Please enter password" : null,
      onSaved: (value) => _password = value,
      decoration: buildInputDecoration("Confirm password", Icons.lock),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Authenticating ... Please wait")
      ],
    );

    final forgotLabel = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton(
          padding: EdgeInsets.all(0.0),
          child: Text("Forgot password?",
              style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
//            Navigator.pushReplacementNamed(context, '/reset-password');
          },
        ),
        FlatButton(
          padding: EdgeInsets.only(left: 0.0),
          child: Text("Sign up", style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
            Navigator.pushNamed(context, registerRoute);
          },
        ),
      ],
    );

    var doLogin = () {
      final form = formKey.currentState!;

      if (form.validate()) {
        form.save();

        final Future<Map<String, dynamic>> successfulMessage =
            auth.login(_phoneNumber, _password);

        successfulMessage.then((response) async {
          if (response['status']) {
            Customer customer = response['customer'];
            await Provider.of<CustomerProvider>(context, listen: false)
                .setCustomer(customer);
            Navigator.pushNamedAndRemoveUntil(
              context,
              mainRoute,
                  (Route<dynamic> route) => false,
            );
          } else {
            Flushbar(
              title: "Failed Login",
              message: response['message']['message'].toString(),
              duration: Duration(seconds: 3),
            ).show(context);
          }
        });
      } else {
        print("form is invalid");
      }
    };

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(40.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.0),
                label("Phone number"),
                SizedBox(height: 5.0),
                phoneNumberField,
                SizedBox(height: 20.0),
                label("Password"),
                SizedBox(height: 5.0),
                passwordField,
                SizedBox(height: 20.0),
                auth.loggedInStatus == Status.Authenticating
                    ? loading
                    : longButtons("Login", doLogin),
                SizedBox(height: 5.0),
                forgotLabel
              ],
            ),
          ),
        ),
      ),
    );
  }
}
