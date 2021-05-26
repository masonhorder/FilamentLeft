import 'package:url_launcher/url_launcher.dart';



website() async {
  const url = 'https://masonhorder.github.io/Filament-Left/index.html';
  try{
    await launch(url);
  } on Exception catch (_) {
    throw 'Could not launch $url';
  }
}



helpSite() async {
  const url = 'https://masonhorder.github.io/Filament-Left/help.html';
  try{
    await launch(url);
  } on Exception catch (_) {
    throw 'Could not launch $url';
  }
}

freePro() async {
  const url = 'https://masonhorder.github.io/Filament-Left/freePro.html';
  try{
    await launch(url);
  } on Exception catch (_) {
    throw 'Could not launch $url';
  }
}