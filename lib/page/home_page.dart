import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_book_store/models/book_model.dart';
import 'package:my_book_store/widgets/book_card.dart';
import 'package:yako_theme_switch/yako_theme_switch.dart';

import '../core/book_api.dart';
import '../main.dart';
import 'details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum Status { initial, loading, fail, success }

class _HomePageState extends State<HomePage> {
  final api = BookApi();
  var list = <BookModel>[];
  var status = Status.loading;
  var error = '';
  var query = '';
  final controller = TextEditingController();
  final node = FocusNode();

  @override
  void initState() {
    loadData(null);
    controller.addListener(() {
      query = controller.text;
      loadData(query);
    });
    super.initState();
  }

  Future<void> loadData(String? query) async {
    status = Status.loading;
    setState(() {});
    try {
      if (query != null) {
        list = await api.getRequiredList(query);
      } else {
        list = await api.getList();
      }
      status = Status.success;
    } catch (e) {
      error = '$e';
      status = Status.fail;
    }
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            'Ilovamizga Xush kelibsiz!',
            style: GoogleFonts.poppins().copyWith(
              color: const Color(0xFF8A8A8A),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: YakoThemeSwitch(
              enabled: true,
              onChanged: ({bool? changed}) {
                if (changed != null && !changed) {
                  MyApp.of(context)!.changeTheme(ThemeMode.dark);
                } else {
                  MyApp.of(context)!.changeTheme(ThemeMode.light);
                }
                setState(() {});
              },
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: ShapeDecoration(
                    color: const Color(0x30C4C4C4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: TextField(
                    focusNode: node,
                    controller: controller,
                    onEditingComplete: () {
                      loadData(query);
                    },
                    onTapOutside: (event) {
                      node.unfocus();
                      setState(() {});
                    },
                    cursorColor: Colors.red,
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: 'Izlash',
                      suffixIcon: controller.text.isNotEmpty
                          ? InkWell(
                              onTap: () => controller.text = '',
                              child: const Icon(Icons.close,
                                  color: Color(0xFFAFAFAF)))
                          : null,
                      prefixIcon:
                          const Icon(Icons.search, color: Color(0xFFAFAFAF)),
                      hintStyle: const TextStyle(
                        color: Color(0xFFC4C4C4),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(child: Builder(
                  builder: (context) {
                    if (status == Status.loading) {
                      return Container();
                    }
                    if (status == Status.fail) {
                      return Center(
                        child: Text(
                          'Xatolik\n$error',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: list.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 18,
                              childAspectRatio: 0.55),
                      itemBuilder: (context, index) {
                        final model = list[index];
                        return BookCard(
                            onTap: () {
                              node.unfocus();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return DetailsPage(id: model.id);
                                  },
                                ),
                              );
                            },
                            title: model.name,
                            author: model.author,
                            image: model.image);
                      },
                    );
                  },
                )),
              ],
            ),
          ),
          status == Status.loading
              ? const Center(
                  child: CupertinoActivityIndicator(
                    radius: 15,
                  ),
                )
              : Container()
        ]),
      ),
    );
  }
}
