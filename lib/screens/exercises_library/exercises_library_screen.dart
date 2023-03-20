import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:toned_australia/components/circular_progress.dart';
import 'package:toned_australia/providers/exercise_library_provider.dart';
import 'package:toned_australia/screens/exercises_library/components/exercise_header.dart';
import 'package:toned_australia/screens/exercises_library/components/item_exercise_library.dart';
import '../../constants.dart';

class ExercisesLibraryScreen extends StatefulWidget {
  @override
  _ExercisesLibraryScreenState createState() => _ExercisesLibraryScreenState();
}

class _ExercisesLibraryScreenState extends State<ExercisesLibraryScreen> {
  Logger logger = Logger();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    final _provider =
        Provider.of<ExerciseLibraryProvider>(context, listen: false);
    Future.delayed(Duration(milliseconds: 500)).then((_) {
      if(_provider.exerciseLibList.isEmpty){
        _provider.clearExerciseLibraryList();
      _provider.getExercises();
      }
    });
    super.initState();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        _provider.getExercises();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseLibraryProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                ExerciseHeader(title: 'Exercises Library'),
                SizedBox(height: defaultPadding),
                if (provider.exerciseLibList.length > 0) ...[
                  Expanded(
                    child: RefreshIndicator(
                      color: Theme.of(context).primaryColor,
                      child: Container(
                        padding: EdgeInsets.all(defaultPadding),
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: ListView.separated(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: provider.exerciseLibList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ItemExerciseLibrary(index: index);
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              height: 0,
                              indent: 12,
                              endIndent: 12,
                            );
                          },
                        ),
                      ),
                      onRefresh: () async {
                        provider.clearExerciseLibraryList();
                        await provider.getExercises();
                      },
                    ),
                  ),
                ],
                if (provider.exerciseLibList.length == 0) ...[
                  if (!provider.exerciseLibLoading)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('No exercises for now'),
                          ],
                        ),
                      ),
                    ),
                ],
                if (provider.exerciseLibLoading)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: LinearProgress(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
