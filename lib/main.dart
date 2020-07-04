import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harmony/blocs/authentication_bloc/bloc.dart';
import 'package:harmony/blocs/simple_bloc_delegate.dart';
import 'package:harmony/repository/user_data_repository.dart';
import 'package:harmony/repository/user_repository.dart';
import 'package:harmony/screens/home/home_screen.dart';
import 'package:harmony/screens/login/login_screen.dart';
import 'package:harmony/screens/splash_screen.dart';
import 'package:rxdart/rxdart.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();

  // Notification
  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid = AndroidInitializationSettings("app_icon");
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  });

//TODO: Activate Location Provider

  runApp(MultiRepositoryProvider(
    providers: <RepositoryProvider>[
      RepositoryProvider<UserRepository>(
        create: (context) => UserRepository(),
      ),
      RepositoryProvider<UserDataRepository>(
        create: (context) => UserDataRepository(),
      )
    ],
    child: MainBlocs(),
  ));
}

class MainBlocs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserRepository userRepository =
        RepositoryProvider.of<UserRepository>(context);
    return MultiBlocProvider(providers: [
      BlocProvider<AuthenticationBloc>(
          create: (context) =>
              AuthenticationBloc(userRepository: userRepository)
                ..add(AppStarted())),
    ], child: MyApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme: GoogleFonts.montserratTextTheme(
        Theme.of(context).textTheme,
      )),
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Unauthenticated) {
            return LoginScreen();
          }
          if (state is Authenticated) {
            return HomeScreen();
          }
          return SplashScreen();
        },
      ),
    );
  }
}
