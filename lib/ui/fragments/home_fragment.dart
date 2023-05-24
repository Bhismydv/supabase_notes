import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_hack/styles/app_colors.dart';
import 'package:supabase_hack/ui/fragments/base_fargment.dart';
import 'package:supabase_hack/ui/fragments/update_notes_fragment.dart';
import 'package:supabase_hack/ui/screens/home_screen.dart';
import 'package:supabase_hack/ui/widgets/app_rounded_button.dart';
import 'package:supabase_hack/utils/ui_helper.dart';


class HomeFragment extends StatefulWidget implements BaseFragment {
  const HomeFragment({Key? key}) : super(key: key);

  @override
  State<HomeFragment> createState() => _HomeFragmentState();

  @override
  void onRefresh() {
    // TODO: implement onRefresh
  }
}

class _HomeFragmentState extends State<HomeFragment> {


  final response = Supabase.instance.client.from("supabaseNotes").select<List<Map<String, dynamic>>>();
  late int id;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: FutureBuilder<List<Map<String, dynamic>>>(
          future: response,
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return CircularProgressIndicator(color: AppColors.accentColor,);
            }
            final result = snapshot.data!;
            print("result: "+result.toString());
            return  result.length > 0 ? ListView.separated(
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (context, index){
                return Divider(color: AppColors.accentColor,);
              },
                shrinkWrap: true,
                itemCount: result.length,
                itemBuilder: (context, index){
                  final data= result[index];
                  print("data: "+ data.toString());
                  return buildNote(data);
                }) : Align(
              alignment: Alignment.center,
              child: Text("Notes Empty", style: TextStyle(color: Colors.black12, fontSize: 20,),)
            );
          }),
    );
  }

  Widget buildNote(Map<String, dynamic> data) {
   id= data["id"];
    return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red,
                borderRadius: const BorderRadius.only(topLeft: Radius.elliptical(30, 30),
                  bottomRight: Radius.elliptical(30, 30),
                ),
              boxShadow: [
                BoxShadow(color: AppColors.bodyTextColor.withOpacity(.5),
                    offset: Offset(2,5), blurRadius: 12)
              ]
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: RichText(text: TextSpan(
                       text: "Title: ", style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.titleTextColor
                      ),
                        children: [
                          TextSpan(
                           text: data["title"], style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.backgroundColor
                          ),
                          )
                        ]
                      ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    GestureDetector(
                        onTap: (){
                         onDelete();
                        },
                        child: Icon(Icons.delete_sweep_outlined, color: AppColors.backgroundColor,)),
                  ],
                ),
                const SizedBox(height: 5,),
                Divider(color: AppColors.appColor,),
                const SizedBox(height: 5,),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RichText(text: TextSpan(
                        text:  "Description: \n", style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.titleTextColor
                      ),
                        children: [
                          TextSpan(
                            text: data["description"], style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.backgroundColor
                          ),
                          )
                        ]
                      )),
                    ),

                    const SizedBox(width: 10,),
                    GestureDetector(
                        onTap: (){
                          UIHelper.getFragmentManager(context).setFragment(UpdateNotesFragment(title: data["title"], description: data["description"], id: data["id"],), true, "Update Note");
                        },
                        child: Icon(Icons.update, color: AppColors.backgroundColor,)),
                  ],
                )

              ],
            ),
          );
  }

  Future onDelete(){
    return showDialog(context: context, builder: (dContaxt){
      return WillPopScope(onWillPop: () async{
        return true;
      },
        child: AlertDialog(
          actionsPadding: const EdgeInsets.only(bottom: 20, top: 20),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               AppRoundedButton(label: "Cancel",
                   width: UIHelper.getScreenWidth(context)/3.2,
                   bagColor: AppColors.backgroundColor,
                   txtColor: AppColors.accentColor,
                   onPressed: (){
                     Navigator.of(context).pop();
                   }),
               AppRoundedButton(label: "Delete",
                   width: UIHelper.getScreenWidth(context)/3.2,
                   onPressed: () async {
                   setState(() {
                     Supabase.instance.client.from("supabaseNotes").delete().eq('id', id).execute();
                   });
                     HomeScreen.menuListener!.onRefresh();
                     await Future.delayed(Duration(seconds: 3));
                     Navigator.of(context).pop();
                     UIHelper.showShortToast(" Notes Deleted");
                   })

             ],
           )
          ],
        ),);
    });
  }


}
