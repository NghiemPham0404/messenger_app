import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageViewer extends StatefulWidget {
  final List<String> images;

  const ImageViewer(this.images, {super.key});

  @override
  State<StatefulWidget> createState() {
    return ImageViewerState();
  }
}

class ImageViewerState extends State<ImageViewer> {
  late final PageController _pageController;
  late final List<String> images;

  bool focus = false;
  int displayIndex = 0;

  @override
  void initState() {
    super.initState();
    images = widget.images;
    _pageController = PageController(initialPage: displayIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Scaffold(
          appBar:
              focus
                  ? null
                  : AppBar(
                    title: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.download),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.black,
                  ),
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: images.length,
                onPageChanged: (index) {
                  setState(() {
                    displayIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onDoubleTap: focusChange,
                    child: Center(
                      child: Image.network(images[index], fit: BoxFit.contain),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void focusChange() {
    setState(() {
      focus = !focus;
      if (focus) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    });
  }
}
