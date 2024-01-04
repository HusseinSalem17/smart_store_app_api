import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/constants.dart';
import 'package:my_smartstore/home/fragments/home_fragment/home_fragment_cubit.dart';
import 'package:my_smartstore/models/slide_model/slide_model.dart';
import 'package:my_smartstore/my_widgets/category_item.dart';
import 'package:my_smartstore/my_widgets/slider_carousel.dart';

import 'home_fragment_state.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<HomeFragmentCubit, HomeFragmentState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is HomeFragmentInitial) {
            BlocProvider.of<HomeFragmentCubit>(context).loadCategories();
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is HomeFragmentLoaded) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  toolbarHeight: 150,
                  titleSpacing: 0,
                  backgroundColor: Colors.white,
                  title: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        color: PRIMARY_SWATCH,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            elevation: MaterialStateProperty.all(0),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                                Text(
                                  "Search",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        height: 80,
                        child: _categories(state),
                      )
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return listItem(state, 0);
                    },
                    childCount: 1,
                  ),
                )
              ],
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  _categories(state) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: state.categories.length,
      itemBuilder: (_, index) {
        return CategoryItem(categoryModel: state.categories[index]);
      },
    );
  }

  listItem(state, viewType) {
    switch (viewType) {
      case 0:
        return SliderCarousel(
          imgList: List.from(
            state.slides.map((SlideModel slide) => slide.image.toString()),
          ),
        );
      default:
        return Text('Error');
    }
  }
}
