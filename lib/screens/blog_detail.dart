import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniblog/blocs/article_bloc/article_bloc.dart';
import 'package:miniblog/blocs/article_bloc/article_event.dart';
import 'package:miniblog/blocs/article_bloc/article_state.dart';

class BlogDetail extends StatefulWidget {
  const BlogDetail({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  _BlogDetailState createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  void initState() {
    super.initState();
    fetchArticleDetail();
  }

  void fetchArticleDetail() {
    context.read<ArticleBloc>().add(FetchArticleDetail(id: widget.id));
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
        title: const Text("Detay"),
      ),
      body: BlocBuilder<ArticleBloc, ArticleState>(builder: (context, state) {
        if (state is ArticlesInitial) {
          return const Text("İstek atılmalı..");
        }

        if (state is ArticleDetailsLoading) {
          return const Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.grey,
            color: Color.fromARGB(255, 101, 226, 166),
          ));
        }

        if (state is ArticlesDetailLoaded) {
          return Center(
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 2 / 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(109, 210, 210, 210),
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        fit: BoxFit
                            .contain, // Resmi uygun bir şekilde sığdırmak için
                        image: NetworkImage(state.blog.thumbnail!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(state.blog.title!,
                    style: const TextStyle(
                      fontSize: 20,
                    )),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    state.blog.content!,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  state.blog.author!,
                  style: const TextStyle(fontSize: 13),
                )
              ],
            ),
          );
        }

        if (state is ArticlesDetailError) {
          return const Center(child: Text("Bloglar yüklenirken hata oluştu"));
        }
        return const Center(
          child: Text("Unknown State"),
        );
      }),
    );
  }
}
