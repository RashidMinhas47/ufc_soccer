import 'package:flutter/material.dart';

class AnimatedListTile extends StatefulWidget {
  const AnimatedListTile({Key? key}) : super(key: key);

  @override
  _AnimatedListTileState createState() => _AnimatedListTileState();
}

class _AnimatedListTileState extends State<AnimatedListTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Tap to Expand'),
      onExpansionChanged: (value) {
        setState(() {
          _isExpanded = value;
        });
      },
      children: [
        if (_isExpanded)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  title: Text('Item 1'),
                  onTap: () {
                    // Handle item tap
                  },
                ),
                ListTile(
                  title: Text('Item 2'),
                  onTap: () {
                    // Handle item tap
                  },
                ),
                ListTile(
                  title: Text('Item 3'),
                  onTap: () {
                    // Handle item tap
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
