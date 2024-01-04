import 'package:my_smartstore/models/category_model.dart';

import '../../../models/slide_model/slide_model.dart';

abstract class HomeFragmentState {}

class HomeFragmentInitial extends HomeFragmentState {}

class HomeFragmentLoading extends HomeFragmentState {}

class HomeFragmentLoaded extends HomeFragmentState {
  List<CategoryModel> categories;
  List<SlideModel> slides;
  HomeFragmentLoaded({required this.categories, required this.slides});
}

class HomeFragmentFailed extends HomeFragmentState {
  String message;
  HomeFragmentFailed({required this.message});
}
