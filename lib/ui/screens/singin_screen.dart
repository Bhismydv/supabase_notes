import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_hack/ui/screens/forgot_password_screen.dart';
import 'package:supabase_hack/ui/screens/home_screen.dart';
import 'package:supabase_hack/ui/screens/singup_screen.dart';
import 'package:supabase_hack/utils/ui_helper.dart';
import '../../styles/app_colors.dart';
import '../widgets/app_rounded_button.dart';
import '../widgets/app_rounded_text_field.dart';

class SignInScreen extends StatefulWidget {
   const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _authController = Supabase.instance;
  User? get user => _authController.client.auth.currentUser;
  String email='', password='';
  bool showPassword = true;

  void _emailOnChanged(String val) {
    email = val;
  }

  String? _emailValidator(String? val) {
    if (val?.isEmpty ?? true) {
      return 'Please enter a email';
    }else {
      return (UIHelper.validateEmail(email)) ? null : 'Please enter valid email';
    }
  }

  String? _passwordValidator(String? val) {
    if (val?.isEmpty ?? true) {
      return 'Please enter a password';
    } else {
      if (val!.length < 6) {
        return 'Password should be at least 6 characters long';
      }
      return (UIHelper.validatePassword(val)? null : 'Please enter valid password');
    }
  }
  void _passwordOnChanged(String val) {
    password = val;
  }

  void _toggleVisibility() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  Future _onSignIn(BuildContext context) async {
    if (_formKey != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();

      try{
        final response = await _authController.client.auth.signInWithPassword(email: email, password: password);
        if (response.session != null) {
          UIHelper.showShortToast(response.user!.email);
          UIHelper.gotoScreen(context, HomeScreen());
          _formKey.currentState!.reset();
          // _signInEmailController.reset();
        } else {
          UIHelper.showShortToast("Something Wrong!");
        }
      } on AuthException catch(error){
        UIHelper.showAlertDialog(context, error.message);
      } catch (error){
        debugPrint(error.toString());
        UIHelper.showAlertDialog(context, error.toString());
      }


  }}

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      key: scaffoldKey,
      body: SingleChildScrollView(
        reverse: true,
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.only(top: 60),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset("assets/svg/access_account.svg", height: 120,),
             const SizedBox(height: 20,),
              Form(
                key: _formKey,
                child: Container(
                  width: MediaQuery.of(context).size.width-50, padding: const EdgeInsets.only(top: 20, left: 5, right: 5, bottom: 20),
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
                      Text("Type the registered account email and password for the sign in.",
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
                      const SizedBox(height: 20,),
                    AppRoundedButton(label: "Sing In", onPressed: (){
                      _onSignIn(context);
                    },
                      bagColor: AppColors.accentColor,
                    ),
                      const SizedBox(height: 20,),
                      GestureDetector(
                        onTap: (){
                          UIHelper.gotoScreen(context, ForgotPasswordScreen());

                        },
                        child: Text("Forgot Password ?" ,  style: TextStyle(color: AppColors.accentColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,),),
                      )
                    ],
                  )
                ),
              ),
             const SizedBox(height: 20,),
          //    Image.asset("assets/images/google.png"),
              GestureDetector(
                  onTap: (){
                    UIHelper.gotoScreen(context, SingUpScreen());
                  },
                  child: Text("Sign Up Here ?", style: TextStyle(decoration: TextDecoration.underline, fontSize: 16,
                      fontWeight: FontWeight.w600, color: AppColors.accentColor),))
            ],
          ),
        ),
      ),
    );
  }

}
