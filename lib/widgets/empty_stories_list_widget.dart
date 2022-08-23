import 'package:flutter/material.dart';

class EmptyStoriesListWidget extends StatelessWidget {
  const EmptyStoriesListWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text('No stories available :(')
      )
    );
  }
}