import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:miniblog/models/blog.dart';
import 'package:http/http.dart' as http;
import 'package:miniblog/screens/add_blog.dart';
import 'package:miniblog/screens/blog_detail.dart';
import 'package:miniblog/widgets/blog_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Blog> blogs = [];
  @override
  void initState() {
    super.initState();
    fetchBlogs();
  }

  fetchBlogs() async {
    Uri url = Uri.parse("https://tobetoapi.halitkalayci.com/api/Articles");
    final response = await http.get(url);
    final List jsonData = json.decode(response.body);

    setState(() {
      blogs = jsonData.map((json) => Blog.fromJson(json)).toList();
    });
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
          title: const Text("Bloglar"),
          actions: [
            IconButton(
                onPressed: () async {
                  bool? result = await Navigator.of(context)
                      .push(MaterialPageRoute(builder: (ctx) => AddBlog()));

                  if(result == true) {
                    fetchBlogs();
                  }    
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: blogs.isEmpty
            ? const Center(
                child: CircularProgressIndicator(
                backgroundColor: Colors.grey,
                color: Color.fromARGB(255, 101, 226, 166),
              ))
            : RefreshIndicator(
                onRefresh: () async {
                  fetchBlogs();
                },
                child: ListView.builder(
                  
                  itemCount: blogs.length,
                  itemBuilder: (context, index) => InkWell(child: BlogItem(blog: blogs[index]),
                  onTap: () {
                    if (blogs[index].id != null){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BlogDetail(blogId: blogs[index].id!)));
                    }
                  },
                  ),
                ),
              ));
  }
}
