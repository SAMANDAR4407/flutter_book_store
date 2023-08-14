import 'package:dio/dio.dart';
import 'package:my_book_store/models/book_model.dart';

class BookApi {
  final _dio = Dio(BaseOptions(
    baseUrl: 'https://run.mocky.io/v3/',
    validateStatus: (status) => true,
  ));

  Future<List<BookModel>> getList() async {
    final response = await _dio.get("a9195398-8204-4ace-b0ee-4d949bdc195d");
    return (response.data['books'] as List)
        .map((e) => BookModel.fromJson(e)).toList();
  }

  Future<List<BookModel>> getRequiredList(String query) async {
    final response = await _dio.get("a9195398-8204-4ace-b0ee-4d949bdc195d");
    var responseList = (response.data['books'] as List).map((e) => BookModel.fromJson(e)).toList();
    var requiredList = <BookModel>[];
    for(var data in responseList){
      if(data.name.toLowerCase().startsWith(query)){
        requiredList.add(data);
      }
    }
    return requiredList;
  }

  Future<BookModel> getDetails(String id) async {
    final response = await _dio.get(id);
    return BookModel.fromJson(response.data);
  }
}
