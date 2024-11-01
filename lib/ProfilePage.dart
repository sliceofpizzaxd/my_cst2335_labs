import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_cst2335_labs/DataRepository.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late TextEditingController firstNameTextController, lastNameTextController,
    phoneNumberTextController, emailTextController;
  @override
  void initState() {
    super.initState();
    // initialize all text editing controllers
    firstNameTextController = TextEditingController();
    lastNameTextController = TextEditingController();
    phoneNumberTextController = TextEditingController();
    emailTextController = TextEditingController();
    firstNameTextController.text = DataRepository.firstName ?? '';
    lastNameTextController.text = DataRepository.lastName ?? '';
    phoneNumberTextController.text = DataRepository.phoneNumber ?? '';
    emailTextController.text = DataRepository.email ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    // save user data
    DataRepository.firstName = firstNameTextController.text;
    DataRepository.lastName = lastNameTextController.text;
    DataRepository.phoneNumber = phoneNumberTextController.text;
    DataRepository.email = emailTextController.text;
    DataRepository.saveData();
    // dispose of all text editing controllers
    for (TextEditingController controller in [
      firstNameTextController, lastNameTextController,
      phoneNumberTextController, emailTextController
    // ignore: curly_braces_in_flow_control_structures
    ]) controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Hello, World!")
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // First name text field
            TextField(controller: firstNameTextController,
              decoration: InputDecoration(
                hintText: "First Name",
                border: OutlineInputBorder()
              )
            ),
            // Last name text field
            TextField(controller: lastNameTextController,
              decoration: InputDecoration(
                hintText: "Last Name",
                border: OutlineInputBorder()
              )
            ),
            // Last name text field
            Row(
              children: <Widget>[
                Flexible(
                  child: TextField(controller: phoneNumberTextController,
                    decoration: InputDecoration(
                      hintText: "Phone Number",
                      border: OutlineInputBorder()
                    )
                  )
                ),
                // phone call button
                ElevatedButton(onPressed: () {
                  canLaunchUrl(Uri.parse("tel: ${phoneNumberTextController.text}")).then(
                      (can) {
                        if(can) {
                          launchUrl(Uri.parse("tel: ${phoneNumberTextController.text}"));
                        } else if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("cannot make phone calls from this device")));
                        }
                      }
                  );
                }, child: Icon(Icons.phone)),
                // sms button
                ElevatedButton(onPressed: () {
                  canLaunchUrl(Uri.parse("sms: ${phoneNumberTextController.text}")).then(
                      (can) {
                        if(can) {
                          launchUrl(Uri.parse("sms: ${phoneNumberTextController.text}"));
                        } else if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("cannot send texts from this device")));
                        }
                      }
                  );
                }, child: Icon(Icons.sms)),
              ],
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: TextField(controller: emailTextController,
                    decoration: InputDecoration(
                      hintText: "Email address",
                      border: OutlineInputBorder()
                    )
                  ),
                ),
                ElevatedButton(onPressed: () {
                  canLaunchUrl(Uri.parse("mailto: ${emailTextController.text}")).then(
                          (can) {
                        if(can) {
                          launchUrl(Uri.parse("mailto: ${emailTextController.text}?"));
                        } else if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("cannot send emails from this device")));
                        }
                      }
                  );
                }, child: Icon(Icons.email)),
              ]
            )
          ]
        )
      )
    );
  }
}