import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:netflix/utils/utils.dart';
import 'package:netflix/widgets/movie_image.dart';

class MoviesList extends StatelessWidget {
  String query;
  MoviesList({required this.query});

  List<DocumentSnapshot> listOfMovies = [];

  @override
  Widget build(BuildContext context) {
    List<String> a = query.split(":");
    String name = a[1];
    String title = name[0].toUpperCase() + name.substring(1) + " Movies";
    Stream<QuerySnapshot> queryStream = getStream(query);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          height: 165,
          padding: EdgeInsets.symmetric(horizontal: 13),
          child: StreamBuilder(
            stream: queryStream,
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
                if (a.length == 3) {
                  if (!movies['tags'].contains(a[2])) listOfMovies.add(movies);
                } else {
                  listOfMovies.add(movies);
                }
                // listOfMovies.add(movies);
              }

              return ListView.separated(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    width: 8,
                  );
                },
                itemCount: listOfMovies.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot movie = listOfMovies[index];
                  return MovieImage(
                    movie: movie,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
