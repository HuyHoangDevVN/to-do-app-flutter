import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/counter_cubit.dart';

class CounterDisplay extends StatelessWidget {
  const CounterDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterCubit, dynamic>(
      builder: (context, state) {
        return Text(
          'Count: ${state.value}',
          style: const TextStyle(fontSize: 32),
        );
      },
    );
  }
}