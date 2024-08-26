import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additionalInfoitem.dart';
import 'package:weather_app/hourly_forcast.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secretstuff.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  // double temp = 0;
  // @override
  // void initState() {
  //   super.initState();
  //   getCurrentWeather();
  // }
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = "new delhi";
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey'),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw "an unexpected error ";
      }
      return data;
      // setState(() {
      //   temp = (data['list'][0]['main']['temp']);
      // });
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Weather_App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      // body: temp ==0 ? const CircularProgressIndicator() :
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          //print(snapshot);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          final data = snapshot.data!;
          final currentData = data["list"][0];
          final currentTemp = currentData["main"]["temp"];
          final currentsky = currentData["weather"][0]["main"];
          final currentPressure = currentData["main"]["pressure"];
          final currentHumidity = currentData["main"]["humidity"];
          final currentWindSpeed = currentData["wind"]["speed"];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    elevation: 10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp k',
                                style: const TextStyle(fontSize: 40),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Icon(
                                currentsky == "Clouds" || currentsky == "Rain"
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                "$currentsky",
                                style: const TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "  Hourly Forcast",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 1; i < 6; i++)
                        HourlyForcast(
                          icons: data["list"][i + 1]["weather"][0]["main"] ==
                                      "Clouds" ||
                                  data["list"][i + 1]["weather"][0]["main"] ==
                                      "Sunny"
                              ? Icons.cloud
                              : Icons.sunny,
                          time: DateFormat.j().format(
                              DateTime.parse(data["list"][i + 1]["dt_txt"])),
                          temp: data["list"][i + 1]["main"]["temp"].toString(),
                        ),
                    ],
                  ),
                  // ),
                  // SizedBox(
                  //   height: 120,
                  //   child: ListView.builder(
                  //       scrollDirection: Axis.horizontal,
                  //       itemCount: 5,
                  //       itemBuilder: (context, index) {
                  //         HourlyForcast(
                  //           icons: data["list"][index + 1]["weather"][0]
                  //                           ["main"] ==
                  //                       "Clouds" ||
                  //                   data["list"][index + 1]["weather"][0]
                  //                           ["main"] ==
                  //                       "Sunny"
                  //               ? Icons.cloud
                  //               : Icons.sunny,
                  //           time: data["list"][index + 1]["dt"].toString(),
                  //           temp: data["list"][index + 1]["main"]["temp"]
                  //               .toString(),
                  //         );
                  //         return null;
                  //       }),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Additional Information",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                      icons: Icons.water_drop,
                      lable: "Humidity",
                      value: currentHumidity.toString(),
                    ),
                    AdditionalInfoItem(
                      icons: Icons.air,
                      lable: "Wind Speed",
                      value: currentWindSpeed.toString(),
                    ),
                    AdditionalInfoItem(
                      icons: Icons.umbrella,
                      lable: "pressure",
                      value: currentPressure.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// class AdditionalInfoItem extends StatelessWidget {
//   const AdditionalInfoItem({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           width: 160,
//         ),
//         SizedBox(
//           height: 8,
//         ),
//         Icon(
//           Icons.water_drop,
//           size: 30,
//         ),
//         SizedBox(
//           height: 8,
//         ),
//         Text(
//           "Humidity",
//           style: TextStyle(
//             fontSize: 12,
//           ),
//         ),
//         SizedBox(
//           height: 8,
//         ),
//         Text(
//           "60",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 12,
//           ),
//         ),
//         SizedBox(
//           height: 8,
//         ),
//       ],
//     );
//   }
// }
