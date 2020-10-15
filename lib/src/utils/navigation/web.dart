// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class NavUtils {
  NavUtils._();
  static String get initialURL => html.window.location.pathname;
}

void pageReload() {
  print("reloading page");
  html.window.location.reload();
}
