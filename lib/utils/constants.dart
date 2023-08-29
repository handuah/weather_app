// // ignore: constant_identifier_names
// const String base_url = 'https://api.weatherbit.io/v2.0/';

// // ignore: non_constant_identifier_names
// const String API_KEY = '1dca4687b313448bb8c162345b0e5f13';

// // Example Call
// // https://api.weatherbit.io/v2.0/current?lat=35.7796&lon=-78.6382&key=1dca4687b313448bb8c162345b0e5f13&include=minutely

// //https://api.weatherbit.io/v2.0/current?city=Accra&country=Ghana&key=1dca4687b313448bb8c162345b0e5f13

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/////////////////////////
// USING WEATHERAPI.COM//
// ignore: constant_identifier_names
const String base_url = 'https://api.weatherapi.com/v1/';

// ignore: non_constant_identifier_names
const String API_KEY = 'dfce69c8d77f4714b29121448232908';

// WEATHER LOTTIES
LottieBuilder cloudy = Lottie.network(
  'https://lottie.host/579a3008-8d5a-47a4-ab4e-c47926a50c52/kFegdlRhPs.json',
  fit: BoxFit.cover,
  alignment: Alignment.center,
);
