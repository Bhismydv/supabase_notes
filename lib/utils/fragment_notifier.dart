import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stack/stack.dart' as MyStack;
import 'package:supabase_hack/ui/fragments/add_notes_fragment.dart';
import '../ui/fragments/base_fargment.dart';
import '../ui/fragments/home_fragment.dart';
import '../ui/screens/home_screen.dart';


class FragmentNotifier extends ChangeNotifier {
  late Widget selectedFragment;
  bool showRefresh=true;
  bool showAppBar=false;
  String screenTitle='Home';
  static MyStack.Stack<Widget> _fragmentStack = MyStack.Stack();
  static MyStack.Stack<bool> _showRefreshStack = MyStack.Stack();
  static MyStack.Stack<String> _screenTitleStack = MyStack.Stack();
  static MyStack.Stack<bool> _showAppBarStack = MyStack.Stack();

  FragmentNotifier() {

    setScreenTitle('');
    selectedFragment =  const HomeFragment();
   HomeScreen.menuListener=selectedFragment as BaseFragment;
    setShowAppBarStack(showAppBar);
    setShowRefresh(showRefresh);
    setScreenTitle(screenTitle);
    _fragmentStack.push(selectedFragment);
  }

  MyStack.Stack<Widget> getFragmentStack() => _fragmentStack;

  void setFragment(Widget fragment,bool showAppBar,String title) {
    if (selectedFragment.runtimeType.toString() != fragment.runtimeType.toString()) {
      selectedFragment = fragment;
      HomeScreen.menuListener=selectedFragment as BaseFragment;
      setShowAppBarStack(showAppBar);
      setShowRefresh(showRefresh);
      setScreenTitle(title);
      _fragmentStack.push(fragment);
      print('in cd');
    }

    notifyListeners();
  }

  void setShowRefresh(bool val){
      _showRefreshStack.push(val);
      showRefresh=val;
      //notifyListeners();
  }

  void setShowAppBarStack(bool val){
    _showAppBarStack.push(val);
    showAppBar=val;
    //notifyListeners();
  }

  void setScreenTitle(String val){
    _screenTitleStack.push(val);
    screenTitle=val;
    //notifyListeners();
  }

  bool navigatedBack(BuildContext context) {
    if (_fragmentStack.isNotEmpty) {
      _fragmentStack.pop();
    }
    if(_showAppBarStack.isNotEmpty){
      _showAppBarStack.pop();
    }
    if(_screenTitleStack.isNotEmpty){
      _screenTitleStack.pop();
    }
    if(_showRefreshStack.isNotEmpty){
      _showRefreshStack.pop();
    }
    if (_fragmentStack.isEmpty) {
      print('is empty ${_fragmentStack.isEmpty}');
      return true; //exit
    } else {
      setShowAppBarStack(_showAppBarStack.top());
      setScreenTitle(_screenTitleStack.top());
      setShowRefresh(_showRefreshStack.top());
      selectedFragment = _fragmentStack.top();
      HomeScreen.menuListener=selectedFragment as BaseFragment;
      notifyListeners();
      print('is empty false');
      return false; //dont exit,jst navigate back
    }
  }

  void clearStackAndGotoHome() {
    _fragmentStack = MyStack.Stack();
    _showAppBarStack=MyStack.Stack();
    _screenTitleStack=MyStack.Stack();
    _showRefreshStack=MyStack.Stack();
    selectedFragment =  const HomeFragment();
    HomeScreen.menuListener=selectedFragment as BaseFragment;
    setShowAppBarStack(false);
    setShowRefresh(true);
    setScreenTitle('Notes Dash');
    _fragmentStack.push(selectedFragment);
    notifyListeners();
  }

  void clearStackAndGotoAddNotes() {
    _fragmentStack = MyStack.Stack();
    _showAppBarStack=MyStack.Stack();
    _showRefreshStack = MyStack.Stack();
    _screenTitleStack=MyStack.Stack();
    selectedFragment =  const AddNotesFragment();
    HomeScreen.menuListener=selectedFragment as BaseFragment;
    setShowAppBarStack(false);
    setShowRefresh(true);
    setScreenTitle('Add Notes');
    _fragmentStack.push(selectedFragment);
    notifyListeners();
  }

  void clearStackAndSetSelected(){
    _fragmentStack = MyStack.Stack();
    _showAppBarStack=MyStack.Stack();
    _showRefreshStack=MyStack.Stack();
    _screenTitleStack=MyStack.Stack();
    selectedFragment =  const HomeFragment();
    HomeScreen.menuListener=selectedFragment as BaseFragment;
    setShowAppBarStack(false);
    setShowRefresh(true);
    setScreenTitle('');
    _fragmentStack.push(selectedFragment);
  }

}
