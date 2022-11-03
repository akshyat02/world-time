
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:worldtime/services/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String time = "";
  Future<void> setUpWorldTime() async {
    WorldTime instance = WorldTime(location: 'Asia/Kolkata', flag: 'india.png', url: 'Asia/Kolkata');
    await instance.getTime();
    if(!mounted) return;
    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'location': instance.location,
      'flag': instance.flag,
      'time': instance.time,
      'daytime': instance.daytime,
    });
    // print(instance.time);
    // setState((){
    //   time = instance.time;
    // });
  }
  @override
  void initState(){
    super.initState();
    if (kDebugMode) {
      print("Init");
    }
    setUpWorldTime();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          // padding: EdgeInsets.all(40),
          // child: Text(time)
        child: SpinKitPouringHourGlassRefined(
          color: Colors.white,
          size: 100.0,
          strokeWidth: 2.0,
        )
      ),
    );
  }
}
