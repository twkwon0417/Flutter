import 'package:flutter/material.dart';

class MtWidget extends StatelessWidget {
  const MtWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final PageController pageController = PageController( initialPage: 0, );

    return PageView(
      controller: pageController,
      children: [
        SizedBox.expand(
            child: Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  children: [
                    Image.asset('assets/demo-1.png', fit: BoxFit.fitHeight, height: MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight!.toDouble() - 90, width: MediaQuery.of(context).size.width),
                  ],
                )
              ),
            ),
        ),
        SizedBox.expand(
          child: Container(
            color: Colors.white,
            child: Center(
                child: Column(
                  children: [
                    Image.asset('assets/demo-2.png', fit: BoxFit.fitHeight, height: MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight!.toDouble() - 90, width: MediaQuery.of(context).size.width),
                  ],
                )
            ),
          ),
        ),
        SizedBox.expand(
          child: Container(
            color: Colors.white,
            child: Center(
                child: Column(
                  children: [
                    Image.asset('assets/demo-3.png', fit: BoxFit.fitHeight, height: MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight!.toDouble() - 90, width: MediaQuery.of(context).size.width), // Text( 'Page index : 1', style: TextStyle(fontSize: 20), )
                  ],
                )
            ),
          ),
        ),
        SizedBox.expand(
          child: Container(
            color: Colors.white,
            child: Center(
                child: Column(
                  children: [
                    Image.asset('assets/demo-4.png', fit: BoxFit.fitHeight, height: MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight!.toDouble() - 90, width: MediaQuery.of(context).size.width),
                  ],
                )
            ),
          ),
        ),
        SizedBox.expand(
          child: Container(
            color: Colors.white,
            child: Center(
                child: Column(
                  children: [
                    Image.asset('assets/demo-5.png', fit: BoxFit.fitHeight, height: MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight!.toDouble() - 90, width: MediaQuery.of(context).size.width),
                  ],
                )
            ),
          ),
        ),
      ],
    );
  }
}