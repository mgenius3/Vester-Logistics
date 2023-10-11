import 'package:flutter/material.dart';
import 'package:vester/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../Assistants/assistant_method.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final addressTextEditingController = TextEditingController();

  // DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users");
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');

  bool? refresh = false;

  Future<void> uploadImageToFirestore(String userId) async {
    try {
      // Pick an image from the device's gallery
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        // Create a reference to the Firebase Storage bucket
        Reference storageRef = FirebaseStorage.instance.ref();

        // Generate a unique ID for the image
        String imageName = DateTime.now().millisecondsSinceEpoch.toString();

        // Upload the image to Firestore
        TaskSnapshot snapshot = await storageRef
            .child('users/$userId/images/$imageName.jpg')
            .putFile(File(image.path));

        // Retrieve the download URL of the uploaded image
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Store the download URL in Firestore
        userRef.doc(userId).set({
          'image_url': downloadUrl,
        }, SetOptions(merge: true)).then((_) {
          Fluttertoast.showToast(msg: "Updated Successfully.");
          AssistantMethods.readCurrentOnlineUserInfo();
          setState(() {
            refresh = true;
          });
        }).catchError((error) {
          Fluttertoast.showToast(msg: "Error Occurred. \n $error");
        });
      }
    } catch (err) {
      print(err);
    }
  }

  Future<void> showUserNameDialogAlert(BuildContext context, String name) {
    nameTextEditingController.text = name;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update"),
            content: SingleChildScrollView(
              child: Column(children: [
                TextFormField(
                  controller: nameTextEditingController,
                )
              ]),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel", style: TextStyle(color: Colors.red))),
              TextButton(
                  onPressed: () {
                    userRef.doc(FirebaseAuth.instance.currentUser!.uid).update({
                      "name": nameTextEditingController.text.trim()
                    }).then((value) {
                      nameTextEditingController.clear();
                      Fluttertoast.showToast(msg: "Updated Successfully.");

                      AssistantMethods.readCurrentOnlineUserInfo();
                      setState(() {
                        refresh = true;
                      });
                    }).catchError((errorMessage) {
                      print("error");
                      Fluttertoast.showToast(
                          msg: "Error Occurred. \n $errorMessage");
                    });
                    Navigator.pop(context);
                  },
                  child: Text("OK", style: TextStyle(color: Colors.black))),
            ],
          );
        });
  }

  Future<void> showAddressDialogAlert(BuildContext context, String name) {
    addressTextEditingController.text = name;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update"),
            content: SingleChildScrollView(
              child: Column(children: [
                TextFormField(
                  controller: addressTextEditingController,
                )
              ]),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel", style: TextStyle(color: Colors.red))),
              TextButton(
                  onPressed: () {
                    userRef.doc(FirebaseAuth.instance.currentUser!.uid).update({
                      "address": addressTextEditingController.text.trim()
                    }).then((value) {
                      addressTextEditingController.clear();
                      Fluttertoast.showToast(msg: "Updated Successfully.");

                      AssistantMethods.readCurrentOnlineUserInfo();
                      setState(() {
                        refresh = true;
                      });
                    }).catchError((errorMessage) {
                      print("error");
                      Fluttertoast.showToast(
                          msg: "Error Occurred. \n $errorMessage");
                    });
                    Navigator.pop(context);
                  },
                  child: Text("OK", style: TextStyle(color: Colors.black))),
            ],
          );
        });
  }

  Future<void> showPhoneDialogAlert(BuildContext context, String name) {
    phoneTextEditingController.text = name;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update"),
            content: SingleChildScrollView(
              child: Column(children: [
                TextFormField(
                  controller: phoneTextEditingController,
                )
              ]),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel", style: TextStyle(color: Colors.red))),
              TextButton(
                  onPressed: () {
                    userRef.doc(FirebaseAuth.instance.currentUser!.uid).update({
                      "phone": phoneTextEditingController.text.trim()
                    }).then((value) {
                      phoneTextEditingController.clear();
                      Fluttertoast.showToast(msg: "Updated Successfully.");

                      AssistantMethods.readCurrentOnlineUserInfo();
                      setState(() {
                        refresh = true;
                      });
                    }).catchError((errorMessage) {
                      print("error");
                      Fluttertoast.showToast(
                          msg: "Error Occurred. \n $errorMessage");
                    });
                    Navigator.pop(context);
                  },
                  child: Text("OK", style: TextStyle(color: Colors.black))),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios, color: Colors.black)),
            title: Text("Profile Screen",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            centerTitle: true,
            elevation: 0.0,
          ),
          body: SingleChildScrollView(
              child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 50),
              child: Column(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          // uploadImageToFirestore(
                          //     FirebaseAuth.instance.currentUser!.uid);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              child: Text(
                                  "${userModelCurrentInfo!.name.toString()[0]}",
                                  style: TextStyle(fontSize: 30)),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 30,
                  ),

                  SizedBox(height: 30),

                  Text(
                    "SETTINGS",
                    style: TextStyle(color: Colors.grey),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    iconColor: Colors.black,
                    leading: Icon(Icons.person, color: Colors.black),
                    title: Text(
                      '${userModelCurrentInfo?.name}',
                      style: TextStyle(color: Colors.black),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 15),
                    onTap: () {
                      showUserNameDialogAlert(
                          context, userModelCurrentInfo?.name ?? "");
                    },
                  ),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    iconColor: Colors.black,
                    leading: Icon(Icons.phone_android, color: Colors.black),
                    title: Text(
                      '${userModelCurrentInfo?.phone}',
                      style: TextStyle(color: Colors.black),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 15),
                    onTap: () {
                      showPhoneDialogAlert(
                          context, userModelCurrentInfo?.phone ?? "");
                    },
                  ),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    iconColor: Colors.black,
                    leading: Icon(FontAwesomeIcons.locationPinLock,
                        color: Colors.black),
                    title: Text(
                      "${userModelCurrentInfo?.address}",
                      style: TextStyle(color: Colors.black),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 15),
                    onTap: () {
                      showAddressDialogAlert(
                          context, userModelCurrentInfo?.address ?? "");
                    },
                  ),
                  // Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    iconColor: Colors.black,
                    leading: Icon(Icons.mail_lock, color: Colors.black),
                    title: Text(
                      '${userModelCurrentInfo?.email}',
                      style: TextStyle(color: Colors.black),
                    ),
                    trailing: Icon(FontAwesomeIcons.lock, size: 15),
                    onTap: () {
                      // Navigator.pushNamed(context, AppRoutes.trade_giftcard);
                    },
                  ),
                  // Divider(),

                  SizedBox(height: 30),
                  Text(
                    "SOCIAL HANDLES",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 10),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    iconColor: Colors.black,
                    leading:
                        Icon(FontAwesomeIcons.instagram, color: Colors.black),
                    title: Text(
                      'Follow on Instagram',
                      style: TextStyle(color: Colors.black),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 15),
                    onTap: () {
                      // Navigator.pushNamed(context, AppRoutes.trade_giftcard);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    iconColor: Colors.black,
                    leading:
                        Icon(FontAwesomeIcons.twitter, color: Colors.black),
                    title: Text(
                      'Follow on Twitter',
                      style: TextStyle(color: Colors.black),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 15),
                    onTap: () {
                      // Navigator.pushNamed(context, AppRoutes.trade_giftcard);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    iconColor: Colors.black,
                    leading:
                        Icon(FontAwesomeIcons.facebook, color: Colors.black),
                    title: Text(
                      'Follow on Facebook',
                      style: TextStyle(color: Colors.black),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 15),
                    onTap: () {
                      // Navigator.pushNamed(context, AppRoutes.trade_giftcard);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    iconColor: Colors.black,
                    leading:
                        Icon(FontAwesomeIcons.whatsapp, color: Colors.black),
                    title: Text(
                      'Write us on Whatsapp',
                      style: TextStyle(color: Colors.black),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 15),
                    onTap: () {
                      // Navigator.pushNamed(context, AppRoutes.trade_giftcard);
                    },
                  ),
                ],
              ),
            ),
          ))),
    );
  }
}
