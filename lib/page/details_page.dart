import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_book_store/core/book_api.dart';
import 'package:my_book_store/page/read_page.dart';
import 'package:path_provider/path_provider.dart';

import '../models/book_model.dart';

class DetailsPage extends StatefulWidget {
  final String id;

  const DetailsPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

enum Status { initial, loading, fail, success }

class _DetailsPageState extends State<DetailsPage> {
  final api = BookApi();
  var details = BookModel.empty();
  var status = Status.initial;
  var path = "";
  var hasPdf = false;
  var progress = 0;

  Future<void> loadData() async {
    status = Status.loading;
    setState(() {});
    try {
      // id = Get.arguments;
      details = await api.getDetails(widget.id);
      status = Status.success;
    } catch (e) {
      status = Status.fail;
    }
    setState(() {});
  }

  @override
  void initState() {
    loadData().then((value) => checkPdf());
    super.initState();
  }

  Future<void> checkPdf() async {
    final dir = await getApplicationDocumentsDirectory();
    path = "${dir.path}/${details.name}";
    final file = File(path);
    hasPdf = await file.exists();
    setState(() {});
  }

  Future<void> onDownload() async {
    if (hasPdf) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReadingPage(path: path)),
      );
      return;
    }
    await Dio().download(
      details.pdf,
      path,
      onReceiveProgress: (count, total) {
        progress = 100 * count ~/ total;
        setState(() {});
      },
    );
    hasPdf = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Stack(children: [
          status == Status.loading
              ? const Center(
                  child: CupertinoActivityIndicator(
                    radius: 15,
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Builder(
                      builder: (context) {
                        if (status == Status.fail) {
                          return const Center(
                            child: Text(
                              'Xatolik yuz berdi',
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        }
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.4,
                                      child: Image.network(
                                        details.image,
                                        fit: BoxFit.fitHeight,
                                      ))),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Text(details.name,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins().copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    )),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  details.author,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins().copyWith(
                                      fontSize: 14,
                                      color: const Color(0xFF777777)),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Text(
                                'Muallif haqida',
                                style: GoogleFonts.poppins().copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              SizedBox(
                                child: Text(
                                  details.biography,
                                  style: GoogleFonts.poppins().copyWith(
                                      fontSize: 14,
                                      height: 1.6,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF9D9D9D)),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Kitob haqida',
                                style: GoogleFonts.poppins().copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              SizedBox(
                                child: Text(
                                  details.overview,
                                  style: GoogleFonts.poppins().copyWith(
                                      fontSize: 14,
                                      height: 1.6,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF9D9D9D)),
                                ),
                              ),
                              const SizedBox(height: 100),
                            ]);
                      },
                    ),
                  ),
                ),
          Column(
            children: [
              Expanded(child: Container()),
              GestureDetector(
                onTap: onDownload,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(15)),
                  alignment: Alignment.center,
                  child: status == Status.loading
                      ? const SizedBox(
                          height: 29,
                        )
                      : Builder(builder: (context) {
                          if (hasPdf) {
                            return Text(
                              "Ochish",
                              style: GoogleFonts.quicksand().copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            );
                          }
                          if (progress != 0) {
                            return Text(
                              "Yuklanmoqda [$progress%]",
                              style: GoogleFonts.quicksand().copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            );
                          }
                          return Text(
                            "Yuklash",
                            style: GoogleFonts.quicksand().copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          );
                        }),
                ),
              ),
              const SizedBox(height: 25),
            ],
          )
        ]));
  }
}
