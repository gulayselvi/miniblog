import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniblog/blocs/article_bloc/article_bloc.dart';
import 'package:miniblog/blocs/article_bloc/article_event.dart';
import 'package:miniblog/blocs/article_bloc/article_state.dart';
import 'package:miniblog/repositories/article_repository.dart';
import 'package:miniblog/screens/add_blog.dart';
import 'package:miniblog/widgets/blog_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  void fetchAgain() {
    context.read<ArticleBloc>().add(FetchArticles());
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
                    
                if (result == true) {
                  context.read<ArticleBloc>().add(FetchArticles());
                }
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: BlocBuilder<ArticleBloc, ArticleState>(builder: (context, state) {
        if (state is ArticlesInitial) {
          //bloc'a fetcharticles gönermek
          context
              .read<ArticleBloc>()
              .add(FetchArticles()); //UI'dan bloc'a event
          return const Center(child: Text("İstek atılıyor ..."));
        }
        if (state is ArticlesLoading) {
          return const Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.grey,
            color: Color.fromARGB(255, 101, 226, 166),
          ));
        }

        if (state is ArticlesLoaded) {
          return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) =>
                  BlogItem(blog: state.blogs[index], onBack: () => fetchAgain(),));
        }

        if (state is ArticlesError) {
          return const Center(child: Text("Bloglar yüklenirken hata oluştu"));
        }

        return const Center(
          child: Text("Unknown State"),
        );
      }),
    );
  }
}
