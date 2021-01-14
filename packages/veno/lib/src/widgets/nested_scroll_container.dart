import 'package:flutter/material.dart';

typedef NestedScrollContainerBuilder = Widget Function(ScrollController);

class NestedScrollContainer extends StatefulWidget {
  NestedScrollContainer({this.parentController, this.builder});

  final ScrollController parentController;
  final NestedScrollContainerBuilder builder;

  _NestedScrollContainerState createState() => _NestedScrollContainerState();
}

class _NestedScrollContainerState extends State<NestedScrollContainer>
    with AutomaticKeepAliveClientMixin<NestedScrollContainer> {
  bool _showBackTop = false;
  bool _showing = false;
  bool _hideing = false;

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;

  ScrollController _scrollController;

  ScrollPhysics ph;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      var innerPos = _scrollController.position.pixels;
      var currentOutPos = widget.parentController.position.pixels;
      var maxOuterPos = widget.parentController.position.maxScrollExtent;

      if (innerPos > 0 && currentOutPos < maxOuterPos) {
        _show();
      } else if (innerPos <= 0 && currentOutPos > 0) {
        _hide();
      }
    });
  }

  Future<void> _show() async {
    if (_showing) {
      return;
    }
    _showing = true;
    await widget.parentController.animateTo(
      widget.parentController.position.maxScrollExtent,
      duration: Duration(milliseconds: 250),
      curve: Curves.decelerate,
    );
    _showing = false;

    var currentOutPos = widget.parentController.position.pixels;
    var maxOuterPos = widget.parentController.position.maxScrollExtent;
    if (!_showBackTop && currentOutPos == maxOuterPos) {
      setState(() => _showBackTop = true);
    }
  }

  Future<void> _hide() async {
    if (_hideing) {
      return;
    }
    _hideing = true;
    await widget.parentController.animateTo(
      0.0,
      duration: Duration(milliseconds: 250),
      curve: Curves.decelerate,
    );
    _hideing = false;

    var currentOutPos = widget.parentController.position.pixels;
    var maxOuterPos = widget.parentController.position.maxScrollExtent;
    if (_showBackTop && currentOutPos < maxOuterPos) {
      setState(() => _showBackTop = false);
    }
  }

  void _backTop() async {
    await _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 250),
      curve: Curves.decelerate,
    );
    await _hide();
    setState(() => _showBackTop = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      widget.builder(_scrollController),
      Positioned(
        bottom: 80,
        right: 10,
        child: _showBackTop
            ? FloatingActionButton(
                onPressed: _backTop,
                child: Icon(Icons.vertical_align_top),
                heroTag: null,
                mini: true,
              )
            : SizedBox.shrink(),
      ),
    ]);
  }
}
