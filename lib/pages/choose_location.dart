import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:worldtime/services/world_time.dart';

class ChooseLocation extends StatefulWidget {
  final String prevSelectedRegion;
  final String prevSelectedCity;
  final bool daytime;
  const ChooseLocation({super.key, required this.prevSelectedRegion, required this.prevSelectedCity, required this.daytime});



  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  List regionList = [
    "Africa",
    "America",
    "Antarctica",
    "Asia",
    "Atlantic",
    "Australia",
    "Europe",
    "Pacific"
  ];
  List cityList = ["Kolkata"];
  String selectedRegion = "Asia";
  String selectedCity = "Kolkata";
  String bgImage = "day.jpg";
  late Color textColor;
  Color bgColor=Colors.white;

  @override
  void initState() {
    super.initState();
    selectedRegion = widget.prevSelectedRegion;
    selectedCity = widget.prevSelectedCity;
    bgImage = widget.daytime? "day.jpg": "night.jpg";
    textColor =widget.daytime ? Colors.black.withOpacity(0.7): Colors.white.withOpacity(0.7);
    bgColor =widget.daytime ? Colors.white: Colors.black;
    cityList = [selectedCity];
    getCityList();

  }

  @override
  Widget build(BuildContext context) {
    // print(cityList);

    return Scaffold(
      backgroundColor: bgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Choose Location"),
        backgroundColor: Colors.transparent,
        foregroundColor: textColor,
        centerTitle: true,
        elevation: 0,
      ),
      // body: SafeArea(child: Text("Choose Location")),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/$bgImage'),
              fit: BoxFit.cover,
              opacity: 0.3
          )
      ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                const SizedBox(height: 100),
                SizedBox(
                  width: 200,
                  child: DropdownButton(
                    isExpanded: true,
                    value: selectedRegion,
                    hint: const Text("Select Region"),
                    borderRadius: BorderRadius.circular(10),
                    dropdownColor: bgColor,
                    style: TextStyle(
                      color: textColor
                    ),
                    onChanged: (newRegion) {
                      setState(() {
                        selectedRegion = newRegion.toString();
                        // print(selectedRegion);
                        cityList.clear();
                        getCityList();
                        // print(selectedRegion);
                      });
                    },
                    icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                    items: regionList.map((e) {
                          return DropdownMenuItem(
                            value: e.toString(),
                            child: Text(e.toString()),
                          );
                        }).toList(),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 200,
                  child: DropdownButton(
                    isExpanded: true,
                    value: selectedCity,
                    hint: const Text("Select City"),
                    borderRadius: BorderRadius.circular(10),
                    dropdownColor: bgColor,
                    
                    style: TextStyle(
                        color: textColor,
                        
                    ),
                    onChanged: (newCity) {
                      setState(() {
                        selectedCity = newCity.toString();
                        if (kDebugMode) {
                          print(selectedCity);
                        }
                      });
                    },
                    icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                    items: cityList.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e.toString()),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton.icon(
                    onPressed: () {
                      updateTime();
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text("Update"),

                    style: ElevatedButton.styleFrom(
                        backgroundColor: bgColor,
                        elevation: 200,
                        foregroundColor: textColor,
                        padding: const EdgeInsets.symmetric(horizontal: 20)
                    )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  getCityList() async {
    Response res = await get(
        Uri.parse('http://worldtimeapi.org/api/timezone/$selectedRegion'));
    var data = jsonDecode(res.body);
    setState(() {
      cityList.clear();
      cityList = data.map((e) {
        // return e.split('/')[1].toString();
        return e.split('/').where((x)=>e.split('/').indexOf(x)!=0).toList().join('/').toString();
      }).toList();
      if (kDebugMode) {
        print(cityList);
      }
      cityList.toSet().toList();
      selectedCity = cityList[0];
    });

    // await http.get(
    //   Uri.parse('http://worldtimeapi.org/api/timezone/${selectedRegion}'),
    // )
    //     .then((response){
    //   var data = json.decode(response.body);
    //   print(data);
    //   setState((){
    //     cityList = data;
    //   });
    // });
  }

  void updateTime() async {
    WorldTime instance = WorldTime(
        location: '$selectedRegion/$selectedCity',
        flag: 'india.png',
        url: '$selectedRegion/$selectedCity');
    await instance.getTime();

    if (kDebugMode) {
      print(instance.time);
    }
    if (!mounted) return;

    Navigator.pop(context, {
      'location': instance.location,
      'flag': instance.flag,
      'time': instance.time,
      'daytime': instance.daytime,
    });
  }
}
