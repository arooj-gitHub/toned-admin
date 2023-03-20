import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:toned_australia/components/circular_progress.dart';
import 'package:toned_australia/providers/events_provider.dart';
import 'package:toned_australia/screens/events/components/events_header.dart';

import '../../constants.dart';
import 'components/item_event.dart';

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  Logger logger = Logger();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    final _provider = Provider.of<EventsProvider>(context, listen: false);
    Future.delayed(Duration(milliseconds: 500)).then((_) {
      if (_provider.eventsList.isEmpty) {
        _provider.clearEventsList();
        _provider.getEvents();
      }
    });
    super.initState();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        _provider.getEvents();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventsProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                EventsHeader(title: 'Events'),
                SizedBox(height: defaultPadding),
                CalendarTimeline(
                  initialDate: provider.selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 300)),
                  onDateSelected: (date) {
                    provider.selectedDate = date;
                    provider.clearEventsList();
                    provider.getEvents();
                  },
                  leftMargin: 1,
                  monthColor: Colors.blueGrey,
                  dayColor: Colors.blueGrey,
                  activeDayColor: Colors.black,
                  activeBackgroundDayColor: Colors.white,
                  dotsColor: Colors.black,
                  // selectableDayPredicate: (date) => date.day != 23,
                  locale: 'en_ISO',
                ),
                SizedBox(height: defaultPadding),
                if (provider.eventsList.length > 0) ...[
                  Expanded(
                    child: RefreshIndicator(
                      color: Theme.of(context).primaryColor,
                      child: Container(
                        padding: EdgeInsets.all(defaultPadding),
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: ListView.separated(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: provider.eventsList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ItemEvent(index: index);
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
                        provider.clearEventsList();
                        await provider.getEvents();
                      },
                    ),
                  ),
                ],
                if (provider.eventsList.length == 0) ...[
                  if (!provider.eventsLoading)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('No events for now'),
                          ],
                        ),
                      ),
                    ),
                ],
                if (provider.eventsLoading)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: LinearProgress(),
                  ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              provider.selectedDate = null;
              provider.clearEventsList();
              provider.getEvents();
            },
            label: Text('Show All'),
            icon: Icon(Icons.refresh_rounded),
            backgroundColor: primaryColor,
          ),
        );
      },
    );
  }
}
