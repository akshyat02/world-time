import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'choose_location.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context)?.settings.arguments as Map;
    if (kDebugMode) {
      print(data);
    }

    String bgImage = data['daytime'] ? 'day.jpg' : 'night.jpg';
    Color? bgColor = data['daytime'] ? Colors.white: Colors.black;
    Color? textColor = data['daytime'] ? Colors.black.withOpacity(0.7): Colors.white.withOpacity(0.7);

    return Scaffold(
      backgroundColor: bgColor,
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   title: const Text("World Time"),
      //   backgroundColor: Colors.transparent,
      //   foregroundColor: textColor,
      //   centerTitle: true,
      //   elevation: 0,
      // ),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/$bgImage'),
              fit: BoxFit.cover,
              opacity: 0.3
            )
          ),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                    onPressed: () async {
                      dynamic result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChooseLocation(prevSelectedRegion: data['location'].split('/')[0].toString(),prevSelectedCity: data['location'].split('/').where((x)=>data['location'].split('/').indexOf(x)!=0).toList().join('/'),daytime: data['daytime'],),
                          ));
                      // dynamic result = await Navigator.pushNamed(context, '/location',
                      //     arguments: data
                      // );
                      // print(result['location']);
                      setState(() {
                        data = {
                          'time' : result['time'],
                          'url' : result['url'],
                          'daytime' : result['daytime'],
                          'location': result['location']
                        };
                      });
                      // print(result['location']);
                    },
                    icon:const Icon(Icons.location_pin),
                    label:const Text("Edit location"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        foregroundColor: textColor,
                    )
                ),
                const SizedBox(
                  height: 24.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data['location'].split('/').last,
                      style: TextStyle(
                          fontSize: 32,
                          color: textColor.withOpacity(0.3),
                          letterSpacing: 5,
                          fontFeatures: const [FontFeature.enable('smcp')]
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 0.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data['time'].split(' ')[0].toString(),
                      style:
                          TextStyle(
                              fontSize: 70, 
                              fontWeight: FontWeight.bold, 
                              color: textColor,
                              fontFeatures: const [FontFeature.enable('onum')]
                          ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        data['time'].split(' ')[1].toString(),
                        style: TextStyle(
                            color: textColor.withOpacity(0.5),
                            letterSpacing: 2,
                            fontWeight: FontWeight.w800
                        ),
                      ),
                    )
                  ],
                ),
                // SizedBox(
                //   width: 10.0,
                // ),

                const SizedBox(height: 200,)
              ],
            )),
      )
    );
  }

}
