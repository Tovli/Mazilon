import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseAppProvider with ChangeNotifier {
  final FirebaseApp _dbUsersApp;

  FirebaseAppProvider(FirebaseApp dbUsersApp) : _dbUsersApp = dbUsersApp;

  FirebaseApp get dbUsersApp => _dbUsersApp;
}
