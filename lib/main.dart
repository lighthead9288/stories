import 'package:flutter/material.dart';
import 'package:stories/models/story_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late double _deviceHeight;
  late double _deviceWidth;

  final PageController _pageController = PageController();
  late AnimationController _animationController;

  final List<StoryData> _stories = [
    StoryData(
        backgroundColor: 0xFF90CAF9,
        title: 'Screen 1 title',
        subtitle: 'Screen 1 subtitle',
        containsButtons: false),
    StoryData(
        backgroundColor: 0xFF000000,
        title: 'Screen 2 title',
        subtitle: 'Screen 2 subtitle',
        containsButtons: true),
    StoryData(
        backgroundColor: 0xFFFF9800,
        title: 'Screen 3 title',
        subtitle: 'Screen 3 subtitle',
        containsButtons: true),
    StoryData(
        backgroundColor: 0xFFF44336,
        title: 'Screen 4 title',
        subtitle: 'Screen 4 subtitle',
        containsButtons: true),
    StoryData(
        backgroundColor: 0xFF43A047,
        title: 'Screen 5 title',
        subtitle: 'Screen 5 subtitle',
        containsButtons: true)
  ];

  int _curPageNumber = 0;

  late Animatable<Color?> bgColor;

  late ColorTween _curBackgroundTween;

  @override
  void initState() {
    super.initState();

    _curBackgroundTween = ColorTween(begin: Color(_stories[0].backgroundColor), end: Color(_stories[0].backgroundColor));
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    var storiesLinesPanelWidth = _deviceWidth * 0.95;

    return Scaffold(
        body: GestureDetector(
            onLongPressStart: (_) {
              print('Stopped');
            },
            onLongPressEnd: (_) {
              print('Released');
            },
            onTapUp: (details) async {
              if (details.localPosition.dx < _deviceWidth / 2) {
                print('Previous');
                if (_curPageNumber != 0) {
                  _curBackgroundTween = ColorTween(begin: Color(_stories[_curPageNumber].backgroundColor), end: Color(_stories[_curPageNumber - 1].backgroundColor));
                  _curPageNumber--;
                  await _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                  setState(() {                    
                  });
                } 
              } else {
                print('Next');
                if (_curPageNumber != _stories.length - 1) {
                  _curBackgroundTween = ColorTween(begin: Color(_stories[_curPageNumber].backgroundColor), end: Color(_stories[_curPageNumber + 1].backgroundColor));
                  _curPageNumber++;
                  await _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                  setState(() {                    
                  });
                }
              }
            },
            child: TweenAnimationBuilder(
              key: UniqueKey(),
              tween: _curBackgroundTween,
              duration: const Duration(milliseconds: 500),
              builder: (_, Color? color, __) => Container(
                height: _deviceHeight,
                padding: EdgeInsets.symmetric(vertical: _deviceHeight * 0.01),
                color: color,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: _deviceHeight * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            _getStoriesLinesPanelItems(storiesLinesPanelWidth),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: _deviceHeight * 0.05),
                        child: Container(
                            height: _deviceHeight * 0.5,
                            width: _deviceWidth,
                            child: PageView.builder(                             
                              controller: _pageController,                              
                              itemCount: _stories.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (_, i) {
                                return Center(
                                  child: Container(
                                    height: _deviceHeight * 0.5,
                                    width: _deviceWidth * 0.75,
                                    color: Colors.purple,
                                    alignment: Alignment.center,
                                    child: Text('Image ${_curPageNumber + 1}', style: const TextStyle(color: Colors.white))
                                  ),
                                );
                              }
                              ),
                            )
                      ),
                    Padding(
                        padding: EdgeInsets.only(top: _deviceHeight * 0.05),
                        child: _getOpacityChangeElement(Text(
                          _stories[_curPageNumber].title,
                          style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ))),
                    Padding(
                      padding: EdgeInsets.only(top: _deviceHeight * 0.02),
                      child: _getOpacityChangeElement(Text(
                        _stories[_curPageNumber].subtitle,
                        style: const TextStyle(fontSize: 15, color: Colors.white),
                      )),
                    ),
                    (_stories[_curPageNumber].containsButtons)
                        ? Padding(
                            padding: EdgeInsets.only(top: _deviceHeight * 0.05),
                            child: _getOpacityChangeElement(Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: _deviceHeight * 0.05,
                                  width: _deviceWidth * 0.35,
                                  child: ElevatedButton(
                                      onPressed: () {},
                                      child: const Icon(Icons.thumb_down),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.black),
                                      )),
                                ),
                                SizedBox(
                                  width: _deviceWidth * 0.05,
                                ),
                                SizedBox(
                                  height: _deviceHeight * 0.05,
                                  width: _deviceWidth * 0.35,
                                  child: ElevatedButton(
                                      onPressed: () {},
                                      child: const Icon(Icons.thumb_up),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white),
                                          foregroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.black))),
                                )
                              ],
                            )))
                        : const SizedBox(),
                  ],
                ),
              ),
            )));

    // return Scaffold(
    //   body: PageView.builder(
    //       controller: _pageController,
    //       onPageChanged: (value) {
    //         print(value);
    //       },
    //       itemCount: _stories.length,
    //       itemBuilder: (_, i) {
    //         return GestureDetector(
    //           onLongPressStart: (_) {
    //             print('Stopped');
    //           },
    //           onLongPressEnd: (_) {
    //             print('Released');
    //           },
    //           onTapUp: (details) {
    //             if (_pageController.hasClients) {
    //               if (details.localPosition.dx < _deviceWidth / 2) {
    //                 print('Previous');
    //                 if (i != 0) {
    //                   _pageController.animateToPage(i - 1, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    //                 } else {
    //                   _pageController.jumpToPage(_stories.length - 1);
    //                 }
    //               } else {
    //                 print('Next');
    //                 if (i != _stories.length - 1) {
    //                   _pageController.animateToPage(i + 1, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);;
    //                 } else {
    //                   _pageController.jumpToPage(0);
    //                 }
    //               }
    //             }
    //           },
    //           child: Container(
    //             padding: EdgeInsets.symmetric(vertical: _deviceHeight * 0.01),
    //             color: Color(_stories[i].backgroundColor),
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               mainAxisSize: MainAxisSize.min,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 Padding(
    //                   padding: EdgeInsets.only(top: _deviceHeight * 0.05),
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: _getStoriesLinesPanelItems(storiesLinesPanelWidth),
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.only(top: _deviceHeight * 0.05),
    //                   child: Container(
    //                     height: _deviceHeight * 0.5,
    //                     width: _deviceWidth * 0.75,
    //                     child: Center(child:Text('Image $i', style: const TextStyle(color: Colors.white)))
    //                   //  color: Colors.grey,
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.only(top: _deviceHeight * 0.05),
    //                   child: Text(
    //                     _stories[i].title,
    //                     style: const TextStyle(
    //                         fontSize: 30,
    //                         fontWeight: FontWeight.bold,
    //                         color: Colors.white),
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.only(top: _deviceHeight * 0.02),
    //                   child: Text(
    //                     _stories[i].subtitle,
    //                     style: const TextStyle(fontSize: 15, color: Colors.white),
    //                   ),
    //                 ),
    //                 (_stories[i].containsButtons)
    //                     ? Padding(
    //                         padding: EdgeInsets.only(top: _deviceHeight * 0.05),
    //                         child: Row(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: [
    //                             SizedBox(
    //                               height: _deviceHeight * 0.05,
    //                               width: _deviceWidth * 0.35,
    //                               child: ElevatedButton(
    //                                   onPressed: () {},
    //                                   child: const Icon(Icons.thumb_down),
    //                                   style: ButtonStyle(
    //                                     backgroundColor:
    //                                         MaterialStateProperty.all(
    //                                             Colors.white),
    //                                     foregroundColor:
    //                                         MaterialStateProperty.all(
    //                                             Colors.black),
    //                                   )),
    //                             ),
    //                             SizedBox(
    //                               width: _deviceWidth * 0.05,
    //                             ),
    //                             SizedBox(
    //                               height: _deviceHeight * 0.05,
    //                               width: _deviceWidth * 0.35,
    //                               child: ElevatedButton(
    //                                   onPressed: () {},
    //                                   child: const Icon(Icons.thumb_up),
    //                                   style: ButtonStyle(
    //                                       backgroundColor:
    //                                           MaterialStateProperty.all(
    //                                               Colors.white),
    //                                       foregroundColor:
    //                                           MaterialStateProperty.all(
    //                                               Colors.black))),
    //                             )
    //                           ],
    //                         ))
    //                     : const SizedBox(),
    //               ],
    //             ),
    //           ),
    //         );
    //       }),
    // );
  }

  Widget _getOpacityChangeElement(Widget child) {
    return TweenAnimationBuilder(
        key: UniqueKey(),
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 500),
        builder: (_, double opacity, __) {
          return Opacity(
            opacity: opacity,
            child: child,
          );
        });
  }

  List<Widget> _getStoriesLinesPanelItems(double width) {
    var iconWidth = 30.0;
    var lineWidth = (width - iconWidth) / 5;
    List<Widget> lines = _stories.map((e) {
      var index = _stories.indexOf(e);
      var progress = (index < 2)
          ? 1
          : (index > 2)
              ? 0
              : 0.25;
      return Container(
        height: _deviceHeight * 0.005,
        width: lineWidth,
        margin: const EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[300]?.withOpacity(0.4)),
        alignment: Alignment.centerLeft,
        child: Container(
          height: _deviceHeight * 0.005,
          width: lineWidth * progress,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[300]?.withOpacity(1.0)),
        ),
      );
    }).toList();
    lines.add(Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        child: GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.close,
              color: Colors.grey[300],
              size: iconWidth,
            ))));
    return lines;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
