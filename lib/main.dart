import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SafeArea(
        child: CustomScrollbar(
          controller: controller,
          scrollDirection: Axis.horizontal,
          scrollThumpDecoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(10)),
          scrollSectionSize: Size(
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height * 0.5,
          ),
          scrollThumpSize: const Size(
            0.5,
            1,
          ),
          scrollTrailPropotion: 0.06,
          scrollTrailPadding: 2,
          builder: (context, scrollController, axis) => ListView(
            controller: scrollController,
            scrollDirection: axis,
            shrinkWrap: true,
            children: List.generate(
              20,
              (index) => Container(
                height: MediaQuery.of(context).size.width / 4,
                width: MediaQuery.of(context).size.width / 2,
                color: Colors.red,
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(index.toString()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
  final Function(BuildContext, ScrollController, Axis) builder;
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
        onNotification: changePosition,
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
          ),
        ),
        dragger(context)
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
          ),
        ),
        dragger(context)
      ],
    );
  }

  Widget dragger(BuildContext context) {
    return GestureDetector(
      // To manage vertical drag
      onVerticalDragStart: widget.isDraggable ? onDragStart : null,
      onVerticalDragEnd: widget.isDraggable ? onDragEnd : null,
      onVerticalDragUpdate: widget.isDraggable ? onDragUpdate : null,

      // to manage horizontal drag
      onHorizontalDragStart: widget.isDraggable ? onDragStart : null,
      onHorizontalDragEnd: widget.isDraggable ? onDragEnd : null,
      onHorizontalDragUpdate: widget.isDraggable ? onDragUpdate : null,

      child: Container(
        width: scrollTrailSize!.width,
        height: scrollTrailSize!.height,
        decoration: widget.scrollTrailDecoration ??
            BoxDecoration(
              borderRadius:
                  BorderRadius.circular(widget.scrollTrailThumpRadius),
              color: Colors.blue,
            ),
        alignment: widget.scrollDirection == Axis.horizontal
            ? Alignment.centerLeft
            : Alignment.topCenter,
        padding: EdgeInsets.all(widget.scrollTrailPadding),
        child: Container(
          height: scrollTrailSize!.height * widget.scrollThumpSize.height,
          width: scrollTrailSize!.width * widget.scrollThumpSize.width,
          margin: widget.scrollDirection == Axis.vertical
              ? EdgeInsets.only(top: _barOffset)
              : EdgeInsets.only(left: _barOffset),
          decoration: widget.scrollThumpDecoration ??
              BoxDecoration(
                borderRadius:
                    BorderRadius.circular(widget.scrollTrailThumpRadius),
                color: Colors.blue,
              ),
        ),
      ),
    );
  }

  double get barMaxScrollExtent => widget.scrollDirection == Axis.vertical
      ? (context.size!.height -
          (scrollTrailSize!.height * widget.scrollThumpSize.height))
      : (context.size!.width -
          (scrollTrailSize!.width * widget.scrollThumpSize.width));

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
  bool changePosition(ScrollNotification notification) {
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
