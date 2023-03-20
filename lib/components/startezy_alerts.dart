import 'package:flutter/material.dart';

import '../locator.dart';
import '../services/navigation_service.dart';

class SeAlerts {
  final NavigationService _navigationService = locator<NavigationService>();

  showLoading(BuildContext context, {String? title}) {
    showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: false,
      enableDrag: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: Text(
                    title ?? 'Loading...',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Theme.of(context).textTheme.displayLarge!.color,
                    ),
                  ),
                ),
                LinearProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }

  showMessage(
    BuildContext context, {
    String? title,
    String? subTitle,
    IconData? iconData,
    bool isDismissible = false,
  }) {
    showModalBottomSheet(
      isDismissible: isDismissible,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 20,
                    right: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null) ...[
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
                          ),
                        ),
                      ],
                      SizedBox(height: 12),
                      if (subTitle != null) ...[
                        Text(subTitle),
                      ],
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                      bottom: 20,
                    ),
                    child: ElevatedButton(
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(30.0),
                      //   side: BorderSide(
                      //     color: Colors.grey,
                      //   ),
                      // ),
                      onPressed: hide,
                      child: Text(
                        'OK',
                        style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .color),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ask(BuildContext context,
      {String? yesText,
      String? noText,
      required String title,
      bool isDismissible = false,
      bool isComplexText = false,
      Widget? complexText,
      required Function func,
      required Function cancelFunc}) {
    showModalBottomSheet(
      isDismissible: isDismissible,
      isScrollControlled: isDismissible,
      enableDrag: isDismissible,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            if (isDismissible) Navigator.pop(context);
            return false;
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 12),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                  child: isComplexText
                      ? complexText
                      : Text(
                          title,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
                            fontSize: 16,
                          ),
                        ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                      bottom: 20,
                      left: 20,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            // shape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.circular(30.0),
                            //   side: BorderSide(
                            //     color: Colors.grey,
                            //   ),
                            // ),
                            onPressed: () => cancelFunc(),
                            child: Text(
                              noText ?? 'No',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .color),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            // shape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.circular(30.0),
                            //   side: BorderSide(
                            //     color: Colors.grey,
                            //   ),
                            // ),
                            onPressed: () => func(),
                            child: Text(
                              yesText ?? 'Yes',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .color),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  hide() {
    _navigationService.goBack();
  }
}
