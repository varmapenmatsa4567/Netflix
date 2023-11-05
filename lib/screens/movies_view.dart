import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:netflix/widgets/movie_card.dart';

class MoviesView extends StatefulWidget {
  const MoviesView({super.key});

  @override
  State<MoviesView> createState() => _MoviesViewState();
}

class _MoviesViewState extends State<MoviesView> {
  Stream<QuerySnapshot> _moviesStream = FirebaseFirestore.instance
      .collection('movies')
      .orderBy("date", descending: true)
      .snapshots();
  bool byDate = true;
  List<DocumentSnapshot> listOfMovies = [];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
      child: StreamBuilder(
        stream: _moviesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          listOfMovies.clear();
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            DocumentSnapshot movies = snapshot.data!.docs[i];
            listOfMovies.add(movies);
          }

          return GridView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 0.53,
              ),
              itemCount: listOfMovies.length,
              itemBuilder: (context, index) {
                DocumentSnapshot movies = listOfMovies[index];
                var date = movies['date'].toDate();

                return MovieCard(
                  imageUrl: movies['image'],
                  title: movies['name'],
                  releaseDate: date.year.toString(),
                  movie: movies,
                );
              });
        },
      ),
    );
  }
}
