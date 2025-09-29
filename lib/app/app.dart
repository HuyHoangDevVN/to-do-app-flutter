import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:too_do_app/features/counter/data/repositories/counter_repository_impl.dart';
import 'package:too_do_app/features/counter/presentation/bloc/counter_cubit.dart';
import 'package:too_do_app/features/counter/presentation/pages/counter_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(CounterRepositoryImpl())..loadCounter(),
      child: MaterialApp(
        title: 'Counter Page',
        home: const CounterPage(),
      ),
    );
  }
}