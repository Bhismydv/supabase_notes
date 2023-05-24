import 'package:supabase_flutter/supabase_flutter.dart';

class UrlProvider{

  static const String supabaseUrl = 'https://ayoosldlbquncttltjry.supabase.co';
  static const String supabaseKey ='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF5b29zbGRsYnF1bmN0dGx0anJ5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODQxNzE2MzMsImV4cCI6MTk5OTc0NzYzM30.wWkU22u-xTz9OVgM5KtYTO0wPHXH6yooSgwslwwFxg4';
  static final supabase  = Supabase.instance.client;
}