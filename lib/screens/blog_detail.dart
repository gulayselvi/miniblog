import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:miniblog/models/blog.dart';
import 'package:http/http.dart' as http;

class BlogDetail extends StatefulWidget {
  const BlogDetail({Key? key, required this.blogId}) : super(key: key);
  final String? blogId;

  @override
  _BlogDetailState createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  late Future<Map<String, dynamic>> _blogDetails;
  late Blog blogItem;

  @override
  void initState() {
    super.initState();
    _blogDetails = fetchBlogDetail();
  }

  Future<Map<String, dynamic>> fetchBlogDetail() async {
    Uri url = Uri.parse(
        "https://tobetoapi.halitkalayci.com/api/Articles/${widget.blogId}");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        blogItem = Blog.fromJson(jsonData);
      });
      return jsonData;
    } else {
      throw Exception('Blog detayları yüklenemedi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20))),
        backgroundColor: const Color.fromARGB(255, 101, 226, 166),
        title: FutureBuilder<Map<String, dynamic>>(
          future: _blogDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Yükleniyor...');
            } else if (snapshot.hasError) {
              return const Text('Blog detayları yüklenirken hata oluştu');
            } else {
              return Text(snapshot.data?['title'] ?? '');
            }
          },
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _blogDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.grey,
                color: Color.fromARGB(255, 101, 226, 166),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Blog detayları yüklenirken hata oluştu'),
            );
          } else {
            blogItem =
                Blog.fromJson(snapshot.data!); // Burada blogItem'ı ayarla
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 2 / 2,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromARGB(109, 210, 210, 210),
                      ),
                      child: Image.network(
                        blogItem.thumbnail ?? "",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    blogItem.title ?? "",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    blogItem.content ?? "",
                    style: const TextStyle(fontSize: 15,),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    blogItem.author ?? "",
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
