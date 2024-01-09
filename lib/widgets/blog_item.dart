import 'package:flutter/material.dart';
import 'package:miniblog/models/blog.dart';
import 'package:miniblog/screens/blog_detail.dart';

class BlogItem extends StatelessWidget {
  const BlogItem({super.key, required this.blog ,required this.onBack});
  final void Function() onBack;
  final Blog blog;

 

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => BlogDetail(id: blog.id!)));
        this.onBack();
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 4 /2,
                child:Container(
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: Center(child: Image.network(blog.thumbnail!)),
                )),
              ListTile(
                title: Text(blog.title!),
                subtitle: Text(blog.author!),
              )
            ],
          ),
        ),
      ),
    );
  }
}
