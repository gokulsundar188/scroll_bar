import 'package:flutter/material.dart';

class CustomScrollbar extends StatefulWidget {
  CustomScrollbar({
    super.key,
    required this.builder,
    required this.scrollSectionSize,
    required this.scrollThumpSize,
    required this.scrollTrailPropotion,
    this.scrollTrailPadding = 0,
    this.scrollTrailThumpRadius = 0,
    this.scrollDirection = Axis.vertical,
    this.scrollThumpDecoration,
    this.scrollTrailDecoration,
    this.isDraggable = true,
    required this.controller,
  })  : assert(scrollTrailPropotion >= 0.0 && scrollTrailPropotion <= 1),
        assert(!(scrollTrailPropotion < 0.01 || scrollTrailPropotion > 0.15)),
        assert(
          !(scrollDirection == Axis.horizontal && scrollThumpSize.width < 0.01),
        ),
        assert(
          !(scrollDirection == Axis.vertical && scrollThumpSize.height < 0.01),
        );

  final ScrollController? controller;
  final Axis scrollDirection;
  final Function(BuildContext, ScrollController, Axis, Size) builder;
  final Size scrollSectionSize;
  final Size scrollThumpSize;
  final double scrollTrailPropotion;
  final double scrollTrailPadding;
  final double scrollTrailThumpRadius;
  final BoxDecoration? scrollThumpDecoration;
  final BoxDecoration? scrollTrailDecoration;
  final bool isDraggable;

  @override
  State<CustomScrollbar> createState() => _CustomScrollbarState();
}

class _CustomScrollbarState extends State<CustomScrollbar> {
  late double _barOffset = 0.0;
  late double _viewOffset = 0.0;
  bool _isDragInProcess = false;
  late Size? scrollTrailSize;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    scrollTrailSize = Size(
        widget.scrollDirection == Axis.horizontal
            ? widget.scrollSectionSize.width
            : widget.scrollSectionSize.width * (widget.scrollTrailPropotion),
        widget.scrollDirection == Axis.horizontal
            ? widget.scrollSectionSize.height * (widget.scrollTrailPropotion)
            : widget.scrollSectionSize.height);

    return Scaffold(
      body: NotificationListener(
        onNotification: (ScrollNotification notification) =>
            changePosition(notification),
        child: widget.scrollDirection == Axis.horizontal
            ? horizontalScrollView(context)
            : verticalScrollView(context),
      ),
    );
  }

  Row verticalScrollView(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: widget.scrollSectionSize.height,
          width: widget.scrollSectionSize.width -
              (widget.scrollSectionSize.width * widget.scrollTrailPropotion),
          color: Colors.transparent,
          child: widget.builder(
              context,
              widget.controller!,
              widget.scrollDirection,
              Size(
                  widget.scrollSectionSize.width -
                      (widget.scrollSectionSize.width *
                          widget.scrollTrailPropotion),
                  widget.scrollSectionSize.height)),
        ),
        scrollBar(context)
      ],
    );
  }

  Column horizontalScrollView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: widget.scrollSectionSize.height -
              (widget.scrollSectionSize.height * (widget.scrollTrailPropotion)),
          width: widget.scrollSectionSize.width,
          color: Colors.transparent,
          child: widget.builder(
              context,
              widget.controller!,
              widget.scrollDirection,
              Size(
                  widget.scrollSectionSize.width,
                  widget.scrollSectionSize.height -
                      (widget.scrollSectionSize.height *
                          (widget.scrollTrailPropotion)))),
        ),
        scrollBar(context)
      ],
    );
  }

  Widget scrollBar(BuildContext context) {
    return GestureDetector(
      // To manage vertical drag
      onVerticalDragStart: widget.isDraggable ? onDragStart : null,
      onVerticalDragEnd: widget.isDraggable ? onDragEnd : null,
      onVerticalDragUpdate: widget.isDraggable ? onDragUpdate : null,

      // to manage horizontal drag
      onHorizontalDragStart: widget.isDraggable ? onDragStart : null,
      onHorizontalDragEnd: widget.isDraggable ? onDragEnd : null,
      onHorizontalDragUpdate: widget.isDraggable ? onDragUpdate : null,

      child: scrollBarTrail(),
    );
  }

  Container scrollBarTrail() {
    return Container(
      width: scrollTrailSize!.width,
      height: scrollTrailSize!.height,
      decoration: widget.scrollTrailDecoration ??
          BoxDecoration(
            borderRadius: BorderRadius.circular(widget.scrollTrailThumpRadius),
            color: Colors.blue,
          ),
      alignment: widget.scrollDirection == Axis.horizontal
          ? Alignment.centerLeft
          : Alignment.topCenter,
      padding: EdgeInsets.all(widget.scrollTrailPadding),
      child: scrollBarThump(),
    );
  }

  Container scrollBarThump() {
    return Container(
      height: scrollTrailSize!.height * widget.scrollThumpSize.height,
      width: scrollTrailSize!.width * widget.scrollThumpSize.width,
      margin: widget.scrollDirection == Axis.vertical
          ? EdgeInsets.only(top: _barOffset)
          : EdgeInsets.only(left: _barOffset),
      decoration: widget.scrollThumpDecoration ??
          BoxDecoration(
            borderRadius: BorderRadius.circular(widget.scrollTrailThumpRadius),
            color: Colors.blue,
          ),
    );
  }

  double get barMaxScrollExtent {
    return widget.scrollDirection == Axis.vertical
        ? ((scrollTrailSize!.height) -
            ((scrollTrailSize!.height * widget.scrollThumpSize.height)))
        : (scrollTrailSize!.width -
            (scrollTrailSize!.width * widget.scrollThumpSize.width));
  }

  double get barMinScrollExtent => 0.0;

  double get viewMaxScrollExtent => widget.controller!.position.maxScrollExtent;

  double get viewMinScrollExtent => widget.controller!.position.minScrollExtent;

  double getScrollViewDelta(
    double barDelta,
    double barMaxScrollExtent,
    double viewMaxScrollExtent,
  ) {
    return barDelta * viewMaxScrollExtent / barMaxScrollExtent;
  }

  double getBarDelta(
    double scrollViewDelta,
    double barMaxScrollExtent,
    double viewMaxScrollExtent,
  ) {
    return scrollViewDelta * barMaxScrollExtent / viewMaxScrollExtent;
  }

  // On scroll listview
  changePosition(ScrollNotification notification) {
    if (_isDragInProcess) {
      return false;
    }

    setState(() {
      if (notification is ScrollUpdateNotification) {
        _barOffset += getBarDelta(
          notification.scrollDelta!,
          barMaxScrollExtent,
          viewMaxScrollExtent,
        );

        if (_barOffset < barMinScrollExtent) {
          _barOffset = barMinScrollExtent;
        }
        if (_barOffset > barMaxScrollExtent) {
          _barOffset = barMaxScrollExtent;
        }

        _viewOffset += notification.scrollDelta!;
        if (_viewOffset < widget.controller!.position.minScrollExtent) {
          _viewOffset = widget.controller!.position.minScrollExtent;
        }
        if (_viewOffset > viewMaxScrollExtent) {
          _viewOffset = viewMaxScrollExtent;
        }
      }
    });

    return true;
  }

  // On Drag thump
  onDragStart(DragStartDetails details) {
    setState(() {
      _isDragInProcess = !_isDragInProcess;
    });
  }

  onDragEnd(DragEndDetails details) {
    setState(() {
      _isDragInProcess = !_isDragInProcess;
    });
  }

  onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _barOffset += widget.scrollDirection == Axis.vertical
          ? details.delta.dy
          : details.delta.dx;

      if (_barOffset < barMinScrollExtent) {
        _barOffset = barMinScrollExtent;
      }
      if (_barOffset > barMaxScrollExtent) {
        _barOffset = barMaxScrollExtent;
      }

      double viewDelta = getScrollViewDelta(
          widget.scrollDirection == Axis.vertical
              ? details.delta.dy
              : details.delta.dx,
          barMaxScrollExtent,
          viewMaxScrollExtent);

      _viewOffset = widget.controller!.position.pixels + viewDelta;
      if (_viewOffset < widget.controller!.position.minScrollExtent) {
        _viewOffset = widget.controller!.position.minScrollExtent;
      }
      if (_viewOffset > viewMaxScrollExtent) {
        _viewOffset = viewMaxScrollExtent;
      }
      widget.controller!.jumpTo(_viewOffset);
    });
  }
}
