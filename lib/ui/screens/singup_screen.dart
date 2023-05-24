import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_hack/utils/ui_helper.dart';

import '../../styles/app_colors.dart';
import '../widgets/app_rounded_button.dart';
import '../widgets/app_rounded_text_field.dart';
import 'home_screen.dart';
import 'singin_screen.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({Key? key}) : super(key: key);

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {

  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final _authController = Supabase.instance;
  User? get user => _authController.client.auth.currentUser;
  String email='', password='', confirmPassword='';
  bool showPassword = true;
  bool showConfirmPassword = true;

  String? _emailValidator(String? val) {
    if (val?.isEmpty ?? true) {
      return 'Please enter a email';
    }else {
      return (UIHelper.validateEmail(email)) ? null : 'Please enter valid email';
    }
  }
  void _emailOnChanged(String val) {
    email = val;
  }

  String? _passwordValidator(String? val) {
    if (val?.isEmpty ?? true) {
      return 'Please enter a password';
    } else {
      if (val!.length < 6) {
        return 'Password should be at least 6 characters long';
      }
      return (UIHelper.validatePassword(val)? null : 'Password Should be Strong');
    }
  }
  void _passwordOnChanged(String val) {
    password = val;
  }
  void _confirmPasswordOnChanged(String val) {
    confirmPassword = val;
  }
  String? _confirmPasswordValidator(String? val) {
    return (val == password) ? null : "Passwords do not match";
  }

  void _toggleVisibility() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void _toggleConfirmVisibility() {
    setState(() {
      showConfirmPassword = !showConfirmPassword;
    });
  }

  Future _onSignUp(BuildContext context) async{
    if (_formKey.currentState!.validate()) {

      try{
        _authController.client.auth.signUp(email: email, password: password);
        UIHelper.gotoScreen(context, HomeScreen());
        UIHelper.showShortToast(_authController.client.auth.currentUser!.email);
        _formKey.currentState!.reset();

      } on AuthException catch(error){
        UIHelper.showAlertDialog(context, error.message);
      } catch (error){
        debugPrint(error.toString());
        UIHelper.showAlertDialog(context, error.toString());
      }
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
              SvgPicture.asset("assets/svg/access_account.svg", width: 120,),
              const SizedBox(height: 20,),
              Form(
                key: _formKey,
                child: Container(
                    width: MediaQuery.of(context).size.width-50,
                    padding: const EdgeInsets.only(top: 20, left: 5, right: 5, bottom: 20),
                    decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.elliptical(30, 30),
                          topRight: Radius.elliptical(30, 30),
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
                        Text("Register your account here.",
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
                        const SizedBox(height: 10,),
                        AppRoundedTextField(
                          validator: _passwordValidator,
                          onChanged: _passwordOnChanged,
                          width: MediaQuery.of(context).size.width/1.5,
                          borderColor: AppColors.accentColor,
                          contentPadding: const EdgeInsets.all(5),
                          onTapShowPassVisibility: _toggleVisibility,
                          radius: 8,
                          obsureText: showPassword,
                          hintText: "password",
                        ),
                        const SizedBox(height: 10,),
                        AppRoundedTextField(
                          validator: _confirmPasswordValidator,
                          onChanged: _confirmPasswordOnChanged,
                          width: MediaQuery.of(context).size.width/1.5,
                          borderColor: AppColors.accentColor,
                          contentPadding: const EdgeInsets.all(5),
                          onTapShowPassVisibility: _toggleConfirmVisibility,
                          radius: 8,
                          obsureText: showConfirmPassword,
                          hintText: "confirm password",
                        ),
                        const SizedBox(height: 20,),
                        AppRoundedButton(label: "Sing Up", onPressed: (){
                         _onSignUp(context);
                        },
                          bagColor: AppColors.accentColor,

                        ),
                        const SizedBox(height: 20,),
                        GestureDetector(
                            onTap: (){
                              UIHelper.gotoScreen(context, SignInScreen());
                            },
                            child: Text("Sign In Here ?",
                              style: TextStyle(decoration: TextDecoration.underline, fontSize: 16,
                                fontWeight: FontWeight.w600, color: AppColors.accentColor,),))
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
