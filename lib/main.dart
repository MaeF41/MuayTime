import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muay_time/app.dart';
import 'package:muay_time/viewmodel/timer_viewmodel.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => TimerCubit(),
      child: const MyApp(),
    ),
  );
}
