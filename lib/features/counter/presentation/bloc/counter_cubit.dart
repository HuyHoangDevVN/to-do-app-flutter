import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:too_do_app/features/counter/domain/entities/counter.dart';
import 'package:too_do_app/features/counter/domain/repositories/counter_repository.dart';
import 'package:too_do_app/features/counter/domain/usecases/increment_counter.dart';

class CounterCubit extends Cubit<Counter> {
  final CounterRepository repository;
  final IncrementCounter incrementCounter;

  CounterCubit(this.repository)
    : incrementCounter = IncrementCounter(repository),
      super(const Counter(0));

  void loadCounter() async {
    emit(await repository.getCounter());
  }

  void increment() async {
    await incrementCounter();
    emit(await repository.getCounter());
  }
}