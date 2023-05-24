import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../styles/app_colors.dart';
import 'fragment_notifier.dart';

class UIHelper {

  static void showShortToast(String? message) {
    if (message != null) {
      Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.grey.shade200,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: AppColors.primaryColor,
          fontSize: 13.0);
    }
  }

  static Future<bool> showAlertDialog(BuildContext context, String msg) async {
    // Create button
    Widget okButton = FlatButton(
      child: Text(
        "OK",
        style: TextStyle(color: AppColors.primaryColor),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(msg),
      title: const Text('Message'),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    return true;
  }


  static double getScreenWidth(BuildContext context){
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context){
    return MediaQuery.of(context).size.height;
  }

  static Future gotoScreen(BuildContext context, Widget toScreen, {bool? removePreviousStack}){
    if(removePreviousStack ==null || removePreviousStack ==false){
      return Navigator.push(context, MaterialPageRoute(builder: (context)=>toScreen));
    }else{
      return gotoForcedScreen(context, toScreen);
    }
  }

  static gotoForcedScreen(BuildContext context, Widget toScreen){
    return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>toScreen), (route) => false);
  }

  static FragmentNotifier getFragmentManager(BuildContext context){
    return Provider.of<FragmentNotifier>(context, listen: false);
  }

  static bool validateEmail(String email){
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  static bool validatePassword(String password){
    return RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{12,}$").hasMatch(password);
  }

  static Future<TextEditingController> openTimeChooser(
      BuildContext context) async {
    TextEditingController controller = TextEditingController();
    final TimeOfDay? picked_s = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        });

    if (picked_s != null) {
      controller.text = picked_s.format(context);
      return controller;
    } else {
      controller.text = TimeOfDay.now().format(context);

      return controller;
    }
  }


  static Future<TextEditingController> openCalendarWithDateChooser(
      BuildContext context,
      {bool? isBackDateEnabled}) async {
    TextEditingController dateCtrl = TextEditingController();

    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: isBackDateEnabled == false || isBackDateEnabled == null
            ? DateTime.now()
            : DateTime(2000),
        lastDate: DateTime(2050),
        cancelText: 'NONE');

    if (pickedDate != null) {
      print(DateFormat("dd-MM-yyyy").format(pickedDate));
      dateCtrl.text = DateFormat("yyyy-MM-dd").format(pickedDate);
    } else {
      dateCtrl.text = '';
    }
    FocusScope.of(context).requestFocus(new FocusNode());

    return dateCtrl;
  }
}