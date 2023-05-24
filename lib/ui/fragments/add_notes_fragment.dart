import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_hack/styles/app_colors.dart';
import 'package:supabase_hack/ui/fragments/base_fargment.dart';
import 'package:supabase_hack/ui/fragments/home_fragment.dart';
import 'package:supabase_hack/ui/screens/home_screen.dart';
import 'package:supabase_hack/ui/widgets/app_rounded_text_field.dart';

import '../../utils/ui_helper.dart';
import '../widgets/app_rounded_button.dart';

class AddNotesFragment extends StatefulWidget implements BaseFragment {
  const AddNotesFragment({Key? key}) : super(key: key);

  @override
  State<AddNotesFragment> createState() => _AddNotesFragmentState();

  @override
  void onRefresh() {
    // TODO: implement onRefresh
  }
}

class _AddNotesFragmentState extends State<AddNotesFragment> {

  final _formKey = GlobalKey<FormState>();
  late DateTime now;
  String title='', description='';
  String currentDate = "",
      currentTime = "";
  TextEditingController controllerDate = TextEditingController();
  TextEditingController controllerTime = TextEditingController();
  late bool select = false;

  void onTapTimeFilter() async {
    controllerTime = await UIHelper.openTimeChooser(context);
    setState(() {
      currentTime = controllerTime.text;
    });
  }

  void onTapDateFilter() async {
    controllerDate = await UIHelper.openCalendarWithDateChooser(context,
        isBackDateEnabled: true);
    setState(() {
      currentDate= controllerDate.text;
    });
  }

  @override
  void initState() {
    now= DateTime.now();
    currentDate = DateFormat('yyyy-MM-dd').format(now);
    controllerDate.text = currentDate;
    currentTime = DateFormat('hh:mm:ss').format(now);
    controllerTime.text = currentTime;
    super.initState();
  }

  //adding data
  Future<PostgrestResponse?> addNotes({required String title, required String description}) async{
    try{
      PostgrestResponse? response = await Supabase.instance.client.from("supabaseNotes").insert(
          {"title": title, "description": description}).execute();
      if(response.data !=null){
        debugPrint(response.data);

        _formKey.currentState!.reset();
      }else{
        debugPrint(response.status.toString());
      }

    }catch(error){
      debugPrint(error.toString());
    }
  }

  Future<void> onPressNote()async{
    await Future.delayed(Duration(seconds: 2));
    addNotes(title: title, description: description);
    UIHelper.getFragmentManager(context).clearStackAndGotoHome();
    UIHelper.showShortToast("Success");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Container(
                  width: MediaQuery.of(context).size.width, padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
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
                      Icon(Icons.edit_note, color: AppColors.accentColor, size: 40,),
                      const SizedBox(height: 10,),
                      AppRoundedTextField(
                        onChanged: (val){
                        setState(() {
                           title = val;
                        });
                        },
                        width: MediaQuery.of(context).size.width,
                        borderColor: AppColors.accentColor,
                        contentPadding: const EdgeInsets.all(5),
                        radius: 5,
                        hintText: "title",
                      ),
                      const SizedBox(height: 10,),
                      AppRoundedTextField(
                        onChanged: (val){
                          setState(() {
                            description = val;
                          });
                        },
                        width: MediaQuery.of(context).size.width,
                        borderColor: AppColors.accentColor,
                        contentPadding: const EdgeInsets.all(5),
                        radius: 5,
                        maxLines: 8,
                        hintText: "description",
                      ),
                      const SizedBox(height: 10,),
                      AppRoundedButton(label: "Create", onPressed: (){
                        onPressNote();
                      },
                        bagColor: AppColors.accentColor,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
