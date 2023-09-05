import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';
import 'package:my_book_store/models/book_model.dart';

import '../../core/book_api.dart';

part 'book_bloc.freezed.dart';
part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {

  final BookApi _api;

  BookBloc(this._api) : super(const BookState.state())  {
    on<BookEvent>((event, emit) async {
      switch(event){
        case _loadData():
          await _onLoadData(event, emit, event.query);
          break;
      }
    });
  }

  Future<void> _onLoadData(_loadData event, Emitter<BookState> emit, String? query) async {
    if(state.status == EnumStatus.loading) return;
    emit(const BookState.state(status: EnumStatus.loading));
    try{
      if(query != null){
        emit(BookState.state(status: EnumStatus.success,list: await _api.getRequiredList(query)));
      } else {
        emit(BookState.state(status: EnumStatus.success,list: await _api.getList()));
      }
    }catch(e){
      emit(BookState.state(status: EnumStatus.fail, message: '$e'));
    }
  }
}

