import 'package:toned_australia/components/se_text_field.dart';
import 'package:toned_australia/controllers/menu_controller.dart';
import 'package:toned_australia/providers/events_provider.dart';
import 'package:toned_australia/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';

class EventsHeader extends StatefulWidget {
  final String title;

  const EventsHeader({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<EventsHeader> createState() => _EventsHeaderState();
}

class _EventsHeaderState extends State<EventsHeader> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EventsProvider>(
      builder: (context, provider, wid) {
        return Row(
          children: [
            if (!Responsive.isDesktop(context))
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: context.read<CMenuController>().controlMenu,
              ),
            // if (!Responsive.isMobile(context))
            //   Text(
            //     title,
            //     style: Theme.of(context).textTheme.headline6,
            //   ),
            Expanded(
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            // if (!Responsive.isMobile(context))
            //   Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5,
                  vertical: defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: () {
                provider.showEventDialog(context, true);
              },
              icon: Icon(Icons.add),
              label: Text("Add New"),
            ),
          ],
        );
      }
    );
  }
}
