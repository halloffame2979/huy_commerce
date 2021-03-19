import 'package:flutter/material.dart';

class ImageSlide extends StatefulWidget {
  final List<String> imageList;

  const ImageSlide({Key key, this.imageList}) : super(key: key);

  @override
  _ImageSlideState createState() => _ImageSlideState();
}

class _ImageSlideState extends State<ImageSlide> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width / 3 * 3.5,
      child: Stack(
        children: [
          Container(
            color: Colors.black,
            child: PageView(
              onPageChanged: (num) {
                setState(() {
                  page = num;
                });
              },
              allowImplicitScrolling: true,
              children: List.generate(
                widget.imageList.length,
                (index) => GestureDetector(
                  onTap: () {
                    showDialog(
                      barrierColor: Colors.black87,
                      context: context,
                      builder: (context) => Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            // color: Colors.red,
                            alignment: Alignment.topRight,
                            child: MaterialButton(
                              minWidth: 10,
                              onPressed: () => Navigator.of(context).pop(),
                              child: Icon(
                                Icons.cancel_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Image.network(widget.imageList[index]),
                        ],
                      ),
                      barrierDismissible: true,
                    );
                  },
                  child: Center(
                    child: Image.network(widget.imageList[index]),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black.withOpacity(0.7)),
            child: Text(
              '${page + 1}/${widget.imageList.length}',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
