import 'package:bill_app/global/constants.dart';
import 'package:bill_app/model/core/customer.dart';
import 'package:bill_app/provider/customer_provider.dart';
import 'package:bill_app/themes/light_color.dart';
import 'package:bill_app/view/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, this.customer}) : super(key: key);
  final Customer? customer;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: TitleText(
            text: 'Profile',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            ListTile(
              leading: TitleText(
                text: "Name:",
                fontWeight: FontWeight.normal,
              ),
              title: TitleText(
                text: widget.customer?.name,
              ),
            ),
            ListTile(
              leading: TitleText(
                text: "Phone:",
                fontWeight: FontWeight.normal,
              ),
              title: TitleText(
                text: widget.customer?.phoneNumber,
              ),
            ),
            ListTile(
              leading: TitleText(
                text: "Address:",
                fontWeight: FontWeight.normal,
              ),
              title: TitleText(
                text: widget.customer?.address,
              ),
            ),
            SignInButtonBuilder(
                iconColor: LightColor.black,
                icon: Icons.exit_to_app_outlined,
                textColor: LightColor.black,
                elevation: 5,
                backgroundColor: LightColor.background,
                onPressed: () async {
                  await Provider.of<CustomerProvider>(context, listen: false)
                      .removeCustomer();
                  Navigator.pushNamed(context, loginRoute);
                  // print('===========profile ${value.customer.token}');
                },
                text: "Log out"),
          ],
        )),
      ),
    );
  }
}


// OutlinedButton(
//           child: Text('Logout'),
//           onPressed: () async {
//             await Provider.of<CustomerProvider>(context, listen: false)
//                 .removeCustomer();
//             Navigator.pushNamed(context, loginRoute);
//             // print('===========profile ${value.customer.token}');
//           },
//         ),