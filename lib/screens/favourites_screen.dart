import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:netflix/providers/favourites_provider.dart';
import 'package:netflix/widgets/movie_card.dart';
import 'package:provider/provider.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  Stream<QuerySnapshot> _moviesStream = FirebaseFirestore.instance
      .collection('movies')
      .orderBy("date", descending: true)
      .snapshots();
  List<DocumentSnapshot> listOfMovies = [];
  @override
  Widget build(BuildContext context) {
    var fp = Provider.of<FavouritesProvider>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
            if (fp.favourites.contains(movies.id)) {
              listOfMovies.add(movies);
            }
          }

          if (listOfMovies.isEmpty) {
            return Center(
              child: Text(
                "Watchlist is empty",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            );
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
            },
          );
        },
      ),
    );
  }
}
