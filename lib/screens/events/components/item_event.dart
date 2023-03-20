import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toned_australia/components/ask_action.dart';
import 'package:toned_australia/models/event.dart';
import 'package:toned_australia/providers/events_provider.dart';

class ItemEvent extends StatelessWidget {
  final int index;

  const ItemEvent({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<EventsProvider>(
      builder: (context, provider, widget) {
        EventModel event = provider.eventsList[index];
        String eventDateTimeDay =
            DateFormat.yMEd().add_jm().format(event.eventDateTime!);
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: ListTile(
            title: Text(
              "${event.title}",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$eventDateTimeDay",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 8),
                Text(
                  "${event.description}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    askAction(
                      actionText: 'Yes',
                      cancelText: 'No',
                      text:
                          'Do you want to delete ${event.title}?',
                      context: context,
                      func: () async {
                        provider.deleteEvent(event.id);
                      },
                      cancelFunc: () => Navigator.pop(context),
                    );
                  },
                ),
                Container(
                  height: 30,
                  width: 1,
                  color: Colors.grey,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    provider.showEventDialog(context, false, model: event);
                  },
                ),
              ],
            ),
            
            onTap: () {},
          ),
        );
      },
    );
  }
}
