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
          scrollDirection: Axis.vertical,
          scrollThumpDecoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(10)),
          scrollSectionSize: Size(
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height * 0.5,
          ),
          scrollThumpSize: const Size(
            1,
            0.5,
          ),
          scrollTrailSize: 0.06,
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
    required this.scrollTrailSize,
    this.scrollTrailPadding = 0,
    this.scrollTrailThumpRadius = 0,
    this.scrollDirection = Axis.vertical,
    this.scrollThumpDecoration,
    this.scrollTrailDecoration,
    this.isDraggable = true,
    required this.controller,
  })  : assert(scrollTrailSize >= 0.0 && scrollTrailSize <= 1),
        assert(!(scrollTrailSize < 0.01 || scrollTrailSize > 0.15)),
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
  final double scrollTrailSize;
  final double scrollTrailPadding;
  final double scrollTrailThumpRadius;
  final BoxDecoration? scrollThumpDecoration;
  final BoxDecoration? scrollTrailDecoration;
  final bool isDraggable;

  @override
  State<CustomScrollbar> createState() => _CustomScrollbarState();
}

class _CustomScrollbarState extends State<CustomScrollbar> {
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
    return Scaffold(
      body: Center(
        child: widget.scrollDirection == Axis.horizontal
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: widget.scrollSectionSize.height -
                        (widget.scrollSectionSize.height *
                            (widget.scrollTrailSize)),
                    width: widget.scrollSectionSize.width,
                    color: Colors.green,
                    child: widget.builder(
                      context,
                      widget.controller!,
                      widget.scrollDirection,
                    ),
                  ),
                  dragger(context)
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: widget.scrollSectionSize.height,
                    width: widget.scrollSectionSize.width -
                        (widget.scrollSectionSize.width *
                            widget.scrollTrailSize),
                    color: Colors.green,
                    child: widget.builder(
                      context,
                      widget.controller!,
                      widget.scrollDirection,
                    ),
                  ),
                  dragger(context)
                ],
              ),
      ),
    );
  }

  Widget dragger(BuildContext context) {
    var scrollTrailSize = Size(
        widget.scrollDirection == Axis.horizontal
            ? widget.scrollSectionSize.width
            : widget.scrollSectionSize.width * (widget.scrollTrailSize),
        widget.scrollDirection == Axis.horizontal
            ? widget.scrollSectionSize.height * (widget.scrollTrailSize)
            : widget.scrollSectionSize.height);

    return GestureDetector(
      // To manage vertical drag
      onVerticalDragStart:
          widget.scrollDirection == Axis.vertical && widget.isDraggable
              ? (detail) {}
              : null,
      onVerticalDragEnd:
          widget.scrollDirection == Axis.vertical && widget.isDraggable
              ? (detail) {}
              : null,
      onVerticalDragUpdate:
          widget.scrollDirection == Axis.vertical && widget.isDraggable
              ? (detail) {}
              : null,

      // to manage horizontal drag
      onHorizontalDragStart:
          widget.scrollDirection == Axis.horizontal && widget.isDraggable
              ? (detail) {}
              : null,
      onHorizontalDragEnd:
          widget.scrollDirection == Axis.horizontal && widget.isDraggable
              ? (detail) {}
              : null,
      onHorizontalDragUpdate:
          widget.scrollDirection == Axis.horizontal && widget.isDraggable
              ? (detail) {}
              : null,

      child: Container(
        width: scrollTrailSize.width,
        height: scrollTrailSize.height,
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
          height: scrollTrailSize.height * widget.scrollThumpSize.height,
          width: scrollTrailSize.width * widget.scrollThumpSize.width,
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
}
