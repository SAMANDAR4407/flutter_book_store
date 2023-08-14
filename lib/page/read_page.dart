import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../core/pref.dart';

class ReadingPage extends StatefulWidget {
  final String path;

  const ReadingPage({Key? key, required this.path}) : super(key: key);

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  final pref = BookPref();
  final controller = PdfViewerController();
  var title = "PDF";
  late final file = File(widget.path);
  var offset = -1.0;


  Future<void> loadPosition() async {
    offset = await pref.getPosition(widget.path);
    setState(() {});
  }

  @override
  void initState() {
    loadPosition();
    controller.addListener(() {
      title = "[${controller.pageNumber}/${controller.pageCount}]";
      try {
        setState(() {});
      } catch (_) {}
    });
    super.initState();
  }

  @override
  void dispose() {
    pref.setPosition(widget.path, controller.scrollOffset.dy);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: GoogleFonts.quicksand().copyWith(fontSize: 18, fontWeight: FontWeight.w600),),
        centerTitle: true,
      ),
      body: offset == -1
          ? const Center(child: CupertinoActivityIndicator(radius: 15,))
          : SfPdfViewer.file(
              file,
              initialScrollOffset: Offset(0, offset),
              controller: controller,
            ),
    );
  }
}
