import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:toned_australia/components/circular_progress.dart';
import 'package:toned_australia/providers/groups_provider.dart';

import '../../constants.dart';
import 'components/groups_header.dart';
import 'components/item_program.dart';

class ProgramsScreen extends StatefulWidget {
  @override
  _ProgramsScreenState createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen> {
  Logger logger = Logger();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    final _provider = Provider.of<GroupsProvider>(context, listen: false);
    Future.delayed(Duration(milliseconds: 500)).then((_) {
      _provider.clearProgramsList();
      _provider.getPrograms();
    });
    super.initState();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        _provider.getPrograms();
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
                GroupsHeader(
                    title:
                        'Programs of ${provider.groupsList[provider.selectedGroup].title}',
                    isGroup: 2),
                SizedBox(height: defaultPadding),
                if (provider.programsList.length > 0) ...[
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
                          itemCount: provider.programsList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ItemProgram(index: index);
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
                        provider.clearProgramsList();
                        await provider.getPrograms();
                      },
                    ),
                  ),
                ],
                if (provider.programsList.length == 0) ...[
                  if (!provider.programsLoading)
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
                if (provider.programsLoading)
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
