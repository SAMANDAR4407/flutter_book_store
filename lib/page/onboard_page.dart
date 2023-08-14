import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_book_store/models/onboard_data.dart';
import 'package:my_book_store/widgets/onboard_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  var index = 0.0;
  final controller = PageController();
  SharedPreferences? prefs;
  final list = [
    OnBoardData('assets/images/page1.svg', 'Read your e-books',
        'Contrary You can buy any books online. we\nwill deliver the book within 2 days in tashkent\n3 days within Uzbekistan'),
    OnBoardData('assets/images/page2.svg', 'Order your books',
        'Contrary You can buy any books online. we\nwill deliver the book within 2 days in tashkent\n3 days within Uzbekistan'),
    OnBoardData('assets/images/page3.svg', 'Now you can listen audio books',
        'We have vide range of audio books that you\ncan enjoy listening books anytime, anywhere'),
  ];

  Future<void> load() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    load();
    controller.addListener(() {
      index = controller.page!;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            allowImplicitScrolling: true,
            controller: controller,
            itemCount: list.length,
            itemBuilder: (context, index) {
              return OnBoardItem(img: list[index].img,
                  text1: list[index].text1,
                  text2: list[index].text2);
            },
          ),
          Column(
            children: [
              SizedBox(height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.86,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.animateToPage(
                          3, duration: const Duration(milliseconds: 250),
                          curve: Curves.linear);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 18),
                      child: Text(
                        'Skip',
                        style: GoogleFonts.montserrat().copyWith(
                          color: index >= 1.5 ? Colors.white : const Color(
                              0xff7e7e7e),
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 60),
                  SizedBox(height: 8,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      separatorBuilder: (__, _) => const SizedBox(width: 8),
                      itemCount: 3,
                      itemBuilder: (_, i) {
                        return Container(
                          width: 15,
                          height: 6,
                          decoration: ShapeDecoration(
                            color: i == index.round()
                                ? const Color(0xFF9098B1)
                                : const Color(0xFFEAEFFF),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 0.50, color: Color(0xFF9098B1)),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        );
                      },),
                  ),
                  const SizedBox(width: 60),
                  GestureDetector(
                    onTap: () {
                      if (index == 2) {
                        Get.offNamed('/home');
                        prefs?.setBool('isFirst', false);
                        return;
                      }
                      controller.nextPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.linear);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 18),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFD45555),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Text(
                        index >= 1.5 ? 'Start' : 'Next',
                        style: GoogleFonts.montserrat().copyWith(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
