import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime{
  String location;
  String time="";
  String flag;
  String url;
  bool daytime=false;

  WorldTime({required this.location, required this.flag, required this.url, });

  Future<void> getTime() async {
    try {
      Response response = await get(
          Uri.parse('http://worldtimeapi.org/api/timezone/${url}'));
      Map data = jsonDecode(response.body);
      // print(data);
      // time = DateTime.parse(data['datetime']).add(Duration(hours: int.parse(data['utc_offset'].substring(1,3)), minutes: int.parse(data['utc_offset'].substring(4,6)))).toString();
      // print(time);
      DateTime now = DateTime.parse(data['datetime']).add(Duration(
          hours: int.parse(data['utc_offset'].substring(1, 3)),
          minutes: int.parse(data['utc_offset'].substring(4, 6))));
      daytime = now.hour > 6 && now.hour < 18 ? true:  false;
      time = DateFormat.jm().format(now);
      // print(time);
    }
    catch(e){
      print('caught error ${e}');
      // time = 'Could not loaded now';

    }
  }

}