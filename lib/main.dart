import 'package:flutter/material.dart';
import 'package:scroll_bar/scroll_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: CustomScrollbar(
        controller: ScrollController(),
        isDraggable: true,
        scrollDirection: Axis.vertical,
        scrollSectionSize: Size(
          ((MediaQuery.of(context).size.width * 0.8) - 60),
          (MediaQuery.of(context).size.height / 2),
        ),

        // Trail decorations
        scrollTrailThumpRadius: 10,
        scrollTrailPropotion: 0.06,
        scrollTrailPadding: 4,
        scrollTrailDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [Color(0xFF450101), Color(0xFF450101)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),

        // Thump decorations
        scrollThumpSize: const Size(
          0.5,
          0.1,
        ),
        scrollThumpDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [Color(0xFFec1313), Color(0xFFec1313)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),

        // Builder
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
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(index.toString()),
            ),
          ),
        ),
      ),
    );
  }
}
