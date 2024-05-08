import 'package:flutter/material.dart';
import 'package:scroll_bar/scroll_bar.dart';

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
