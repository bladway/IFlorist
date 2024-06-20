import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/domain/models/models.dart';
import 'package:me_and_flora/core/presentation/bloc/plant_history/plant_history.dart';
import 'package:me_and_flora/core/presentation/widgets/widgets.dart';

import 'history_plant_element.dart';

class PlantGrid extends StatefulWidget {
  const PlantGrid({super.key});

  @override
  State<PlantGrid> createState() => _PlantGridState();
}

class _PlantGridState extends State<PlantGrid> {
  late bool _isLastPage = false;
  late int _pageNumber = 0;
  final int _nextPageTrigger = 3;
  List<Plant> plantList = [];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocBuilder<PlantHistoryBloc, PlantHistoryState>(
          builder: (context, state) {
        if (state is PlantHistoryLoadSuccess) {
          if (state.plantList.isNotEmpty) {
            _pageNumber++;
            plantList.addAll(state.plantList);
          } else {
            return const EmptyWidget();
          }
        }
        if (state is PlantLoadInProgress) {
          return const Center(child: CircularProgressIndicator());
        }
        return GridView.builder(
          itemCount: plantList.length + (_isLastPage ? 0 : 1),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            if (index == plantList.length - _nextPageTrigger && !_isLastPage) {
              //BlocProvider.of<PlantHistoryBloc>(context).add(PlantHistoryListRequested(page: _pageNumber));
            }
            if (index == plantList.length) {
              _isLastPage = true;
              if (state is PlantLoadInProgress) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return const Center();
              }
            }
            return HistoryPlantElement(
                plant: plantList[index], iconSize: height * 0.3 * 0.15);
          },
        );
      }),
    );
  }
}