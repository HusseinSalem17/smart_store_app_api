import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/home/fragments/home_fragment/home_fragment_repository.dart';
import 'package:my_smartstore/models/slide_model/slide_model.dart';
import 'package:my_smartstore/registration/authentication/auth_cubit.dart';

import '../../../models/category_model.dart';
import 'home_fragment_state.dart';

class HomeFragmentCubit extends Cubit<HomeFragmentState> {
  HomeFragmentCubit() : super(HomeFragmentInitial());
  final HomeFragmentRepository _repository = HomeFragmentRepository();
  void loadCategories() async {
    emit(HomeFragmentLoading());
    _repository.categories().then((value) {
      List<CategoryModel> categories = List.from(
        value.data.map(
          (json) => CategoryModel.fromJson(json),
        ),
      );
      loadSlides(categories);
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(HomeFragmentFailed(message: error.response!.data));
        } catch (e) {
          emit(HomeFragmentFailed(message: error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.badResponse) {
          emit(HomeFragmentFailed(
              message: "Please check your internet connection!"));
        } else {
          emit(HomeFragmentFailed(message: error.message!));
        }
      }
    });
  }

  void loadSlides(categories) {
    _repository.slides().then((value) {
      emit(
        HomeFragmentLoaded(
          categories: categories,
          slides: List.from(
            value.data.map(
              (json) => SlideModel.fromJson(json),
            ),
          ),
        ),
      );
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(HomeFragmentFailed(message: error.response!.data));
        } catch (e) {
          emit(HomeFragmentFailed(message: error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.badResponse) {
          emit(HomeFragmentFailed(
              message: "Please check your internet connection!"));
        } else {
          emit(HomeFragmentFailed(message: error.message!));
        }
      }
    });
  }
}
