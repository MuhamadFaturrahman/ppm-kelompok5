import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsDetailScreen extends StatefulWidget {
  const NewsDetailScreen({
    super.key,
    required this.id,
  });
  final String id;

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  String desc = "";
  int likeCount = 0;

  Future<Map<String, dynamic>> _getNewsDetail(String id) async {
    final response = await http.get(Uri.parse('https://loremipsum.io/'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load news detail");
    }
  }

  @override
  void initState() {
    likeCount = 0;
    super.initState();
    _getNewsDetail(widget.id).then((data) {
      setState(() {
        desc = data["Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."];
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            likeCount++;
            print(likeCount);
          });
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.favorite),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  GoRouter.of(context).pop();
                },
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              const Text("News Detail Screen")
            ],
          ),
          AspectRatio(
            aspectRatio: 16 / 9, // Ditambahkan aspectratio oleh Genta
            child: Image.network(
              "https://images.pexels.com/photos/2607544/pexels-photo-2607544.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        flex: 1,
                        child: Text(
                          "Headline News",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                    Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 25,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(likeCount.toString())
                      ],
                    )
                  ],
                ),
                const Text(
                  "Source Image : Pexels.com",
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 10),
                  textAlign: TextAlign.justify,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
