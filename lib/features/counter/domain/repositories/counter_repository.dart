import 'package:too_do_app/features/counter/domain/entities/counter.dart';

abstract class CounterRepository {
  Future<Counter> getCounter();
  Future<void> increment();
}