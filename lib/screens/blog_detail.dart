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
          context.read<ArticleBloc>().add(FetchArticleDetail(id: widget.id));
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
                    aspectRatio: 10 / 7,
                    child: Image.network(state.blog.thumbnail!)),
                const SizedBox(height: 40),
                Text(state.blog.title!),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    state.blog.content!,
                    textAlign: TextAlign.center,
                  ),
                ),
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
