import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_hack/ui/screens/singin_screen.dart';
import 'package:supabase_hack/ui/screens/singup_screen.dart';

import '../../styles/app_colors.dart';
import '../../utils/ui_helper.dart';
import '../widgets/app_rounded_button.dart';
import '../widgets/app_rounded_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
   const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _authController = Supabase.instance;
  User? get user => _authController.client.auth.currentUser;


  String email='';
  void _emailOnChanged(String val) {
    email = val;
  }
  String? _emailValidator(String? val) {
    if (val?.isEmpty ?? true) {
      return 'Please enter a email';
    }else  {
      return null;
    }
  }

  Future _onForgot(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _authController.client.auth.resetPasswordForEmail(email,
      redirectTo: 'io.supabase.supabase_hack://login-callback/');
      UIHelper.gotoScreen(context, SignInScreen());
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 60),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset("assets/svg/forgot_password.svg", height: 120,),
             const SizedBox(height: 20,),
              Form(
                key: _formKey,
                child: Container(
                  width: MediaQuery.of(context).size.width-50,
                  padding: const EdgeInsets.only(top: 20, left: 5, right: 5, bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: const BorderRadius.only(topLeft: Radius.elliptical(30, 30),
                    bottomRight: Radius.elliptical(30, 30),
                    ),
                    boxShadow: [
                      BoxShadow(color: AppColors.bodyTextColor,
                      blurRadius: 10,
                      offset: const Offset(2,2)),
                    ]
                  ),
                  child: Column(
                    children: [
                      Text("SupabaseHack",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500, color: AppColors.accentColor),),
                      const SizedBox(height: 5,),
                      Text("Type the registered email to reset your forgotten password.",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.bodyTextColor),),

                      const SizedBox(height: 20,),
                      AppRoundedTextField(
                        validator: _emailValidator,
                        onChanged: _emailOnChanged,
                        width: MediaQuery.of(context).size.width/1.5,
                        borderColor: AppColors.accentColor,
                        contentPadding: const EdgeInsets.all(5),
                        radius: 8,
                        hintText: "email",
                      ),
                      const SizedBox(height: 20,),
                    AppRoundedButton(label: "Forgot Password", onPressed: (){
                      _onForgot(context);
                    },
                      bagColor: AppColors.accentColor,
                    ),
                    ],
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
