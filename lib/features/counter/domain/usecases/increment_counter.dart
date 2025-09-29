import 'package:too_do_app/features/counter/domain/repositories/counter_repository.dart';

class IncrementCounter {
  final CounterRepository repository;
  IncrementCounter(this.repository);

  Future<void> call() async {
    await repository.increment();
  }
}