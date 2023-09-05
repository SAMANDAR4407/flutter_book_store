part of 'book_bloc.dart';

@freezed
class BookState with _$BookState{
  const factory BookState.state({
    @Default([]) List<BookModel> list,
    @Default(EnumStatus.initial) EnumStatus status,
    @Default('') String message,
  }) = _state;
}

enum EnumStatus { initial, loading, success, fail }
