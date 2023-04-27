import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/amplify/amplifyconfiguration.dart';
import 'package:filroll_app/providers/add_post.dart';
import 'package:filroll_app/providers/google_sign_up.dart';
import 'package:filroll_app/providers/messages.dart';
import 'package:filroll_app/providers/notification.dart';
import 'package:filroll_app/providers/profile.dart';
import 'package:filroll_app/providers/push_notification.dart';
import 'package:filroll_app/providers/report.dart';
import 'package:filroll_app/providers/story.dart';
import 'package:filroll_app/providers/auth.dart';
import 'package:filroll_app/providers/post.dart';
import 'package:filroll_app/providers/profile/extra_user_detail.dart';
import 'package:filroll_app/providers/profile/file_storage.dart';
import 'package:filroll_app/screens/authentication/auth_done_page.dart';
import 'package:filroll_app/screens/authentication/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';

// ignore: unused_element
late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  await configAmp();

  runApp(const MyApp());
}

Future<void> configAmp() async {
  try {
    await Amplify.addPlugins([AmplifyAuthCognito(), AmplifyStorageS3()]);
    await Amplify.configure(amplifyconfig);
  } catch (e) {
    print(e.toString());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProvider(create: (ctx) => FileStorage()),
        ChangeNotifierProvider(create: (ctx) => ExtraUserDetail()),
        ChangeNotifierProvider(create: (ctx) => Post()),
        ChangeNotifierProvider(create: (ctx) => Story()),
        ChangeNotifierProvider(create: (ctx) => NotificationProvider()),
        ChangeNotifierProvider(create: (ctx) => ReportProvider()),
        ChangeNotifierProvider(create: (ctx) => GoogleSignUp()),
        ChangeNotifierProvider(create: (ctx) => ProfileProvider()),
        ChangeNotifierProvider(create: (ctx) => Messages()),
        ChangeNotifierProvider(create: (ctx) => PushNotification()),
        ChangeNotifierProvider(create: (ctx) => Addpost()),
      ],
      child: GetMaterialApp(
        title: 'flutter app',
        debugShowCheckedModeBanner: false,
        // ignore: prefer_const_constructors
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                return const AuthDonePage();
              } else {
                return SplashScreen();
              }
            }),
      ),
    );
  }
}
