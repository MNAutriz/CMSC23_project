import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc23project/providers/admin_provider.dart';
import 'package:cmsc23project/providers/auth_provider.dart';
import 'package:cmsc23project/providers/donor_provider.dart';
import 'package:cmsc23project/providers/organization_provider.dart';
import 'package:cmsc23project/screens/adminview.dart';
import 'package:cmsc23project/screens/donorview.dart';
import 'package:cmsc23project/screens/orgview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  User? user;

  dynamic admin;
  dynamic org;
  dynamic donor;

  @override
  Widget build(BuildContext context) {
    //get user
    user = context.read<UserAuthProvider>().user;

    //check if user is in the admins database
    context
        .read<AdminProvider>()
        .admin
        .where("email", isEqualTo: user!.email!)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          //contain query in admin
          admin = doc;
        });
      });
    });

    //check if org
    context
        .read<OrganizationProvider>()
        .orgCollection
        .where("email", isEqualTo: user!.email!)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          //contain query in admin
          org = doc;
        });
      });
    });

    //check if donor
    context
        .read<DonorProvider>()
        .donorCollection
        .where("email", isEqualTo: user!.email!)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          //contain query in donor
          donor = doc;
        });
      });
    });

    //if the user is in the admin database
    if (admin != null) {
      return AdminView();
      //if the user is in the organization database
    } else if (org != null) {
      return DonationApp();
    }

    //else return authDonor
    else if (donor != null) {
      return DonorView();
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  //logout
  Drawer get drawer => Drawer(
          child: Container(
        color: const Color(0xFFEEF2E6),
        child: ListView(padding: EdgeInsets.zero, children: [
          const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF1C6758)),
              child: Text("Settings",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Color(0xFFEEF2E6)))),
          ListTile(
            title: const Center(
              child: Text(
                "Log out",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF1C6758)),
              ),
            ),
            onTap: () {
              context.read<UserAuthProvider>().signOut();
            },
          ),
        ]),
      ));

  Widget get authOrg => //authorized as org widget
      SizedBox(
        height: 150,
        width: 350,
        child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/organization');
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3D8361),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))),
            child: const Text("ORGANIZATION",
                style: TextStyle(shadows: [
                  Shadow(
                      color: Colors.black,
                      blurRadius: 2.0,
                      offset: Offset(2.0, 2.0))
                ], color: Colors.white, fontFamily: "Freeman", fontSize: 30),
                textAlign: TextAlign.center)),
      );

  Widget get authAdmin => //authorized as admin widget
      SizedBox(
        height: 150,
        width: 350,
        child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/admin');
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3D8361),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))),
            child: const Text("ADMIN",
                style: TextStyle(shadows: [
                  Shadow(
                      color: Colors.black,
                      blurRadius: 2.0,
                      offset: Offset(2.0, 2.0))
                ], color: Colors.white, fontFamily: "Freeman", fontSize: 30),
                textAlign: TextAlign.center)),
      );

  Widget get authDonor => //authorized as donor widget
      SizedBox(
        height: 150,
        width: 350,
        child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/donor');
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3D8361),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))),
            child: const Text(
              "DONOR",
              style: TextStyle(shadows: [
                Shadow(
                    color: Colors.black,
                    blurRadius: 2.0,
                    offset: Offset(2.0, 2.0))
              ], color: Colors.white, fontFamily: "Freeman", fontSize: 30),
              textAlign: TextAlign.center,
            )),
      );

  //widget for authorization
  Widget authorization() {
    //if the user is in the admin database
    if (admin != null) {
      return AdminView();
      //if the user is in the organization database
    } else if (org != null) {
      return DonationApp();
    }

    //else return authDonor
    else if (donor != null) {
      return DonorView();
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
