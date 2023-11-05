import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netflix/widgets/movie_card.dart';
// import 'package:speech_recognition/speech_recognition.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchText = "";
  TextEditingController _searchController = TextEditingController();

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  FocusNode _focusNode = FocusNode();

  List<DocumentSnapshot> listOfMovies = [];

  Stream<QuerySnapshot> _moviesStream = FirebaseFirestore.instance
      .collection('movies')
      .orderBy("date", descending: true)
      .snapshots();

  @override
  void initState() {
    super.initState();
    // _focusNode.requestFocus();

    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _searchText = _lastWords;
      _searchController.text = _lastWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: InkWell(
            //     onTap: () {
            //       Navigator.pop(context);
            //     },
            //     child: Padding(
            //       padding: EdgeInsets.all(10),
            //       child: Icon(
            //         Icons.arrow_back,
            //         color: Colors.white,
            //       ),
            //     ),
            //   ),
            // ),
            Container(
              color: Color.fromARGB(255, 39, 38, 38),
              width: double.infinity,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Icon(
                      CupertinoIcons.search,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      focusNode: _focusNode,
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchText = value;
                        });
                      },
                      // controller: _searchController,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: "Search movies, shows, actors",
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        if (_searchText.length == 0) {
                          print("mic");
                          _speechToText.isNotListening
                              ? _startListening()
                              : _stopListening();
                        } else {
                          setState(() {
                            _searchText = "";
                            _searchController.clear();
                          });
                        }
                      },
                      // splashColor: Colors.green,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          _searchText.length == 0
                              ? CupertinoIcons.mic
                              : CupertinoIcons.clear_thick,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
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
                      List<String> tags = movies['tags'].cast<String>();
                      List<String> genres = movies['category'].cast<String>();
                      List<String> total = tags + genres;

                      List<String> searchWords = _searchText.split(" ");

                      bool contains = false;

                      for (int i = 0; i < searchWords.length; i++) {
                        if (total.any((element) => element
                            .toLowerCase()
                            .contains(searchWords[i].toLowerCase()))) {
                          contains = true;
                        } else {
                          contains = false;
                          break;
                        }
                      }
                      if (contains) {
                        listOfMovies.add(movies);
                      }
                    }

                    if (listOfMovies.isEmpty) {
                      return Center(
                        child: Text(
                          "No results found",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      );
                    }

                    return GridView.builder(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
