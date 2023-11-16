import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:netflix/screens/movie.dart';
import 'package:netflix/screens/series.dart';

class MovieImage extends StatelessWidget {
  DocumentSnapshot movie;
  MovieImage({
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => movie['type'] == 'movie'
                ? Movies(
                    movie: movie,
                  )
                : Series(
                    movie: movie,
                  ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: movie['image'],
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
