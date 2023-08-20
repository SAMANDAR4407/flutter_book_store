part of 'book_bloc.dart';

@freezed
class BookEvent with _$BookEvent {
  const factory BookEvent.loadData({
    @Default('') String query
}) = _loadData;
}
