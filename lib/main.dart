import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_hack/styles/app_colors.dart';
import 'package:supabase_hack/ui/screens/splash_screen.dart';
import 'package:supabase_hack/utils/fragment_notifier.dart';
import 'networking/url_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: UrlProvider.supabaseUrl,
      anonKey: UrlProvider.supabaseKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FragmentNotifier()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Montserrat",
          primarySwatch: Colors.blue,
            appBarTheme: AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: AppColors.accentColor,
                  statusBarBrightness: Brightness.light, // For iOS: (light icons)
                  statusBarIconBrightness: Brightness.light,
                )
            )
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
























































