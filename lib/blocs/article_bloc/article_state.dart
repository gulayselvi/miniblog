
// ArticlesInitial
// ArticlesLoading
// ArticlesLoaded
// ArticlesError

import 'package:miniblog/models/blog.dart';

abstract class ArticleState {}

class ArticlesInitial extends ArticleState {}

class ArticlesLoading extends ArticleState {}

class ArticlesLoaded extends ArticleState {
  final List<Blog>blogs;

  ArticlesLoaded({required this.blogs});
}

class ArticlesError extends ArticleState {}



class ArticleDetailsLoading extends ArticleState{}

class ArticlesDetailLoaded extends ArticleState{
  final Blog blog;

  ArticlesDetailLoaded({required this.blog});
}

class ArticlesDetailError extends ArticleState {}

