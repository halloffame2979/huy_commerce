import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ImageSlide extends StatelessWidget {
  final List<String> imageList;

  const ImageSlide({Key key, this.imageList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width / 3 * 3.5,
      child: Container(
        color: Colors.black,
        child: PageView(
          allowImplicitScrolling: true,
          children: List.generate(
            imageList.length,
                (index) => FutureBuilder(
              future: FirebaseStorage.instance
                  .ref(imageList[index])
                  .getDownloadURL(),
              builder: (context, image) {
                if (image.connectionState == ConnectionState.done)
                  return Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Center(child: Image.network(image.data)),
                            barrierDismissible: true,
                          );
                        },
                        child: Center(
                          child: Image.network(image.data),
                        ),
                      ),
                      Positioned(
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(5),
                              right: Radius.circular(5),
                            ),
                          ),
                          child: Text(
                            '${index + 1}/${imageList.length}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        bottom: 5,
                        right: 5,
                      ),
                    ],
                  );
                else
                  return Center();
              },
            ),
          ),
        ),
      ),
    );
  }
}