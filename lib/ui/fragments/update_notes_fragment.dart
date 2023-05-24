import 'dart:convert';
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

class UpdateNotesFragment extends StatefulWidget implements BaseFragment {
  String title, description;
  int id;
   UpdateNotesFragment({required this.title, required this.description, required this.id, Key? key}) : super(key: key);

  @override
  State<UpdateNotesFragment> createState() => _UpdateNotesFragmentState();

  @override
  void onRefresh() {
    // TODO: implement onRefresh
  }
}

class _UpdateNotesFragmentState extends State<UpdateNotesFragment> {

  final _formKey = GlobalKey<FormState>();
 late String updateTitle='', updateDescription='';


@override
  void initState() {
    if(widget.title.isNotEmpty && widget.description.isNotEmpty){
      updateTitle = widget.title;
      updateDescription = widget.description;
    }
    print(widget.title);
    print(widget.description);
    print(widget.id);
    super.initState();
  }

  Future<PostgrestResponse?> onPressNote()async{
    await Future.delayed(const Duration(seconds: 3));
    Supabase.instance.client.from("supabaseNotes").upsert(
        {'id': widget.id, 'title': updateTitle, 'description': updateDescription}).execute();
    UIHelper.getFragmentManager(context).clearStackAndGotoHome();
    UIHelper.showShortToast("Notes Updated");
  }
  @override
  void didUpdateWidget(covariant UpdateNotesFragment oldWidget) {
    onPressNote();
    super.didUpdateWidget(oldWidget);
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
                        initialValue: updateTitle,
                        onChanged: (val){
                           setState(() {
                             updateTitle = val;
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
                        initialValue: updateDescription,
                        onChanged: (val){
                         setState(() {
                           updateDescription = val;
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
                      AppRoundedButton(label:
                          "Update", onPressed: (){
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
