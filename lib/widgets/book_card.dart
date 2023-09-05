import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {

  final Function()? onTap;
  final String title;
  final String author;
  final String image;
  const BookCard({Key? key, required this.title, required this.author, required this.image, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width*0.4,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20)),
                child: CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.fitHeight,
                  placeholder: (context, url) => Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTOSEhd-ARRtRWr0GMmWEp9aRG3yYkgukpQkg&usqp=CAU', fit: BoxFit.cover),
                )
              )
          ),
          const SizedBox(height: 10),
          SizedBox(
            child: Text(
              title,
              maxLines: 1,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width*0.4,
            child: Text(
              author,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
      ),
    );
  }
}
