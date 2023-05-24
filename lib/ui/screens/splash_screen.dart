import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_hack/ui/fragments/home_fragment.dart';
import 'package:supabase_hack/ui/screens/home_screen.dart';
import 'package:supabase_hack/utils/ui_helper.dart';

import '../../styles/app_colors.dart';
import '../widgets/app_rounded_button.dart';
import 'singin_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool _redirectCalled = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
   _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(const Duration(seconds: 2));
    if (_redirectCalled || !mounted) {
      return;
    }
    _redirectCalled = true;
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      UIHelper.gotoScreen(context, HomeScreen());
    } else {
      UIHelper.gotoScreen(context, const SignInScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.all(40),
        height: MediaQuery.of(context).size.height/2.5,
        width: MediaQuery.of(context).size.width,
        child: Image.asset("assets/images/supabase-logo-icon.png", fit: BoxFit.contain,),
      ),
              const SizedBox(height: 30,),
              Text("Ready to use \nSupabaseNotes",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: AppColors.accentColor, height: 1.2),),
/*              AppRoundedButton(label: "Get Started",
                bagColor: AppColors.accentColor,
                onPressed: (){
              _redirect();
                },
                    ),*/
            ],
          )
      ),
    );
  }

}
