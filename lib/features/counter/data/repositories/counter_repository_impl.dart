import 'package:too_do_app/features/counter/domain/entities/counter.dart';
import 'package:too_do_app/features/counter/domain/repositories/counter_repository.dart';

class CounterRepositoryImpl implements CounterRepository {
  int _counter = 0;

  @override
  Future<Counter> getCounter() async {
    return Counter(_counter);
  }

  @override
  Future<void> increment() async {
    _counter++;
  }
}