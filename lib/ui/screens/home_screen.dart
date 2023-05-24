import 'package:flutter/material.dart';
import 'package:supabase_hack/listeners/refresh_listner.dart';
import 'package:supabase_hack/networking/url_provider.dart';
import 'package:supabase_hack/styles/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:supabase_hack/ui/fragments/add_notes_fragment.dart';
import 'package:supabase_hack/ui/screens/singin_screen.dart';

import '../../utils/fragment_notifier.dart';
import '../../utils/ui_helper.dart';

class HomeScreen extends StatefulWidget {
  static MenuListener? menuListener;
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    floatingActionButton: FloatingActionButton(
      child: Icon(Icons.edit_note, color: AppColors.accentColor, size: 40,),
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(30), side: BorderSide(color: AppColors.accentColor)),
      backgroundColor: AppColors.backgroundColor,
      onPressed: () {
        UIHelper.getFragmentManager(context).setFragment(AddNotesFragment(), true, "Add Notes");
      },),
    floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    appBar: AppBar(
      backgroundColor: AppColors.accentColor,
      title: Text(Provider.of<FragmentNotifier>(context).screenTitle, style: TextStyle(color: AppColors.backgroundColor),),
      centerTitle: true,
      leading: Visibility(visible: Provider.of<FragmentNotifier>(context).showRefresh,
        child: IconButton(icon:Icon(Icons.refresh, color: AppColors.backgroundColor,), onPressed: ()async{
          CircularProgressIndicator(color: AppColors.backgroundColor,);
          await Future.delayed(const Duration(seconds: 3));
          UIHelper.gotoScreen(context, const HomeScreen());
        },),
      ),
      actions: [
        IconButton(onPressed: (){
         UrlProvider.supabase.auth.signOut();
         UIHelper.gotoScreen(context, SignInScreen());
        }, icon: Icon(Icons.logout, color: AppColors.backgroundColor,),
          splashColor: AppColors.primaryColor, )
      ],
    ),
    body: WillPopScope(
        onWillPop: () async{
          bool canGoBack = UIHelper.getFragmentManager(context).navigatedBack(context);
          return canGoBack;
        },
      child:  SizedBox(
        child: Provider.of<FragmentNotifier>(context).selectedFragment,
      ),
    )
    );
  }
}
