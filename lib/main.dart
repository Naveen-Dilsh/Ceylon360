import 'package:ceyloan_360/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'firebase_options.dart';

Future<void> main() async {
  //TODO: Add widgets Binding

  //TODO: Init Local Storage

  //TODO: Init Payment Methods

  //TODO: Await Native Splash

  //Initialize Firebase && Authentication Repository
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then(
    (FirebaseApp value) => Get.put(AuthenticationRepository()),
  );

  //TODO: Initialize Authentication

  //Load All the material Design / Themes / Localization / Bindings
  runApp(const App());
}
