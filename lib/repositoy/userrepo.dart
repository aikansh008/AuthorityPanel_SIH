import 'dart:math';
import 'package:authority_panel/repositoy/nearby_screen.dart';
import 'package:authority_panel/repositoy/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserRepository {
  static final _db = FirebaseFirestore.instance;
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<void> createUser(UserModel user, BuildContext context) async {
    try {
      await _db.collection("Authority").doc(user.id).set(user.toJson());
    } on FirebaseAuthException catch (e) {
      _showSnackBar(context, e.message ?? "Authentication Error");
    } on FirebaseException catch (e) {
      _showSnackBar(context, e.message ?? "Firebase Error");
    } on PlatformException catch (e) {
      _showSnackBar(context, e.message ?? "Platform Error");
    } on FormatException catch (e) {
      _showSnackBar(context, e.message);
    } catch (e) {
      _showSnackBar(context, "An unknown error occurred: $e");
    }
  }

  static Future<UserModel?> getUserDetail(String email) async {
    try {
      final snapshot =
          await _db.collection("Authority").where("Email", isEqualTo: email).get();
      if (snapshot.docs.isNotEmpty) {
        return UserModel.fromSnapshot(snapshot.docs[0]);
      }
      return null;
    } catch (e) {
      print("Error fetching user detail: $e");
      return null;
    }
  }

  static Future<UserModel?> getUserData() async {
    try {
      final email = FirebaseAuth.instance.currentUser?.email;
      if (email != null) {
        return await getUserDetail(email);
      } else {
        throw "No authenticated user found!";
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  static Future<void> updateUserRecord(
      UserModel user, String field, String value) async {
    try {
      await _db
          .collection("Authority")
          .doc(user.id)
          .update(user.toJson2(field, value));
    } catch (e) {
      print("Error updating user record: $e");
    }
  }

  static Future<void> deleteUserRecord(
      UserModel user, BuildContext context) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await _db.collection("Authority").doc(user.id).delete();
        await currentUser.delete();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  NearbyUsersScreen()),
        );
        print("User deleted successfully");
      }
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  static Future<void> uploadUserPicture(UserModel user, String image) async {
    try {
      await _db
          .collection("Authority")
          .doc(user.id)
          .update(user.toJsonimage(image));
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  static Future<List<UserModel>> fetchUsersFromFirestore() async {
    try {
      final querySnapshot = await _db.collection('Users').get();
      return querySnapshot.docs
          .map((doc) => UserModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      print("Error fetching users from Firestore: $e");
      return [];
    }
  }

  static Future<void> storeDeviceToken() async {
    final token = await _firebaseMessaging.getToken();

    if (token != null) {
      UserModel? user = await getUserData();
      if (user != null) {
        await _db.collection("Users").doc(user.id).update({'fcmToken': token});
      }
    } else {
      print('Failed to get FCM token');
    }
  }

  static double calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371.0; // Radius of the Earth in km

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  static double _toRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  static Future<List<UserModel>> getNearbyUsers(
      double currentLat, double currentLon) async {
    List<UserModel> allUsers = await fetchUsersFromFirestore();
    List<UserModel> nearbyUsers = allUsers.where((user) {
      if (user.x != null && user.y != null) {
        double distance = calculateDistance(
          currentLat,
          currentLon,
          user.x!,
          user.y!,
        );
        return distance <= 50.0; // 50 km
      }
      return false;
    }).toList();

    return nearbyUsers;
  }


  static void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
