import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../core/book_api.dart';
import '../../models/book_model.dart';

part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {

  final BookApi _api;

  BookBloc(this._api) : super(const BookState()) {
    on<BookEvent>((event, emit) async {
      switch(event){
        case LoadDataEvent():
          await _onLoadData(event, emit, event.query);
          break;
        default:
          break;
      }
    });
  }

  Future<void> _onLoadData(BookEvent event, Emitter<BookState> emit, String? query) async {
    if(state.status == EnumStatus.loading) return;
    emit(state.copyWith(status: EnumStatus.loading));
    try{
      if(query!=null){
        emit(state.copyWith(
            status: EnumStatus.success,
            list: await _api.getRequiredList(query)
        ));
      } else {
        emit(state.copyWith(
            status: EnumStatus.success,
            list: await _api.getList()
        ));
      }
    }catch(e){
      emit(state.copyWith(message: '$e', status: EnumStatus.fail));
    }
  }
}
