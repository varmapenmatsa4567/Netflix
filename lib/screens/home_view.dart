import 'package:flutter/cupertino.dart';
import 'package:netflix/widgets/movies_list.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<String> queries = [
    'tags:telugu',
    'genre:Comedy',
    'genre:Action',
    'tags:Marvel',
    'genre:Thriller',
    'genre:Romance',
    'tags:english:Marvel'
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return MoviesList(query: queries[index]);
      },
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 18,
        );
      },
      itemCount: queries.length,
    );
  }
}
