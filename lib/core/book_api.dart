import 'package:dio/dio.dart';
import 'package:my_book_store/models/book_model.dart';

class BookApi {
  final _dio = Dio(BaseOptions(
    baseUrl: 'https://run.mocky.io/v3/',
    validateStatus: (status) => true,
  ));

  Future<List<BookModel>> getList() async {
    final response = await _dio.get("69d02cd4-a7a4-41bb-929f-f9b51837a13a");
    return (response.data['books'] as List)
        .map((e) => BookModel.fromJson(e)).toList();
  }

  Future<List<BookModel>> getRequiredList(String query) async {
    final response = await _dio.get("69d02cd4-a7a4-41bb-929f-f9b51837a13a");
    var requiredList = <BookModel>[];
    var responseList = (response.data['books'] as List).map((e) => BookModel.fromJson(e)).toList();
    for(var data in responseList){
      if(data.name.toLowerCase().startsWith(query) || data.author.toLowerCase().startsWith(query)){
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
