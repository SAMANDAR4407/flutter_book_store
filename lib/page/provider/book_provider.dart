import 'package:flutter/widgets.dart';
import 'package:my_book_store/core/book_api.dart';

import '../../models/book_model.dart';

class BookProvider extends ChangeNotifier{
  final BookApi _api;

  BookProvider(this._api);

  var _list = <BookModel>[];
  var _loading = false;
  var _error = '';

  Future<void> loadData(String? query) async {
    if(_loading) return;
    _loading = true;
    notifyListeners();
    try{
      if(query != null){
        _list = await _api.getRequiredList(query);
      }else{
        _list = await _api.getList();
      }
      _loading = false;
    }catch(e){
      _error = '$e';
    }
    notifyListeners();
  }

  List<BookModel> get list => _list;
  bool get loading => _loading;
  String get error => _error;
}