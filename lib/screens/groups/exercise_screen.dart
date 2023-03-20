import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:toned_australia/components/circular_progress.dart';
import 'package:toned_australia/providers/groups_provider.dart';
import 'package:toned_australia/screens/groups/components/item_exercise.dart';
import '../../constants.dart';
import 'components/groups_header.dart';

class ExerciseScreen extends StatefulWidget {
  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  Logger logger = Logger();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    final _provider = Provider.of<GroupsProvider>(context, listen: false);
    Future.delayed(Duration(milliseconds: 500)).then((_) {
      _provider.clearExercisesList();
      _provider.getExercises();
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
    return Consumer<GroupsProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                GroupsHeader(title: 'Exercises of ${provider.programsList[provider.selectedProgram].title}', isGroup: 3),
                SizedBox(height: defaultPadding),
                if (provider.exercisesList.length > 0) ...[
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
                          itemCount: provider.exercisesList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ItemExercise(index: index);
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
                        provider.clearExercisesList();
                        await provider.getExercises();
                      },
                    ),
                  ),
                ],
                if (provider.exercisesList.length == 0) ...[
                  if (!provider.exercisesLoading)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('No programs for now'),
                          ],
                        ),
                      ),
                    ),
                ],
                if (provider.exercisesLoading)
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
