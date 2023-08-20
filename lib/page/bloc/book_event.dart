part of 'book_bloc.dart';

@immutable
abstract class BookEvent {}

class LoadDataEvent extends BookEvent{
  final String? query;
  LoadDataEvent(this.query);
}
