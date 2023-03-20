import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:toned_australia/components/se_text_field.dart';
import 'package:toned_australia/models/event.dart';
import 'package:toned_australia/services/navigation_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../locator.dart';

class EventsProvider extends ChangeNotifier {
  final NavigationService _navigationService = locator<NavigationService>();
  Logger logger = Logger();
  late FirebaseFirestore _firestore;
  DateTime? selectedDate;

  EventsProvider() {
    _firestore = FirebaseFirestore.instance;
  }

  //! GROUPS PAGINATION

  //#region

  List<EventModel> eventsList = [];

  bool hasMoreEvents = true; // flag for more docs available or not
  DocumentSnapshot? lastEventsDocument;

  bool eventsLoading = false;

  void clearEventsList() {
    hasMoreEvents = true;
    eventsList = [];
    lastEventsDocument = null;
  }

  Future getEvents() async {
    try {
      if (eventsLoading || !hasMoreEvents) {
        logger.wtf('Loading or No More Events');
        return;
      }
      eventsLoading = true;
      notifyListeners();

      Query query = _firestore.collection('events').where('status', isEqualTo: 1).orderBy('event_timestamp', descending: false).limit(10);
      if (selectedDate != null) {
        query = _firestore.collection('events').where('event_date', isEqualTo: "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}").where('status', isEqualTo: 1).orderBy('event_timestamp', descending: false).limit(10);
      }
      QuerySnapshot querySnapshot;
      if (lastEventsDocument == null)
        querySnapshot = await query.get();
      else
        querySnapshot = await query.startAfterDocument(lastEventsDocument!).get();
      if (querySnapshot.docs.isNotEmpty) {
        if (querySnapshot.docs.length < 10) hasMoreEvents = false;
        lastEventsDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
        querySnapshot.docs.forEach((doc) {
          logger.wtf('Event Doc -> ${doc.data()}');
          eventsList.add(EventModel.fromJson(doc));
        });
      } else {
        hasMoreEvents = false;
      }
      eventsLoading = false;
      notifyListeners();
    } catch (err) {
      logger.e('$err');
    }
  }

//#endregion

  TextEditingController newEventTitleTec = TextEditingController();
  TextEditingController newEventDetailTec = TextEditingController();
  TextEditingController newEventDateTimeTec = TextEditingController();
  DateTime eventDateTime = DateTime.now();

  Future createNewEvent() async {
    try {
      EasyLoading.show(status: 'Loading...');
      DocumentReference<Map<String, dynamic>> value = await _firestore.collection('events').add({
        'title': newEventTitleTec.text,
        'description': newEventDetailTec.text,
        'event_date': "${eventDateTime.day}-${eventDateTime.month}-${eventDateTime.year}",
        'event_timestamp': eventDateTime,
        'status': 1,
        'doc': DateTime.now(),
      });
      var documentRef = value.path.split('/');
      await _firestore.collection('event_attendees').doc(documentRef[1]).set({
        'attendees': null,
      });
      clearEventsList();
      await getEvents();
      EasyLoading.dismiss();
      newEventTitleTec.text = "";
      newEventDetailTec.text = "";
      newEventDateTimeTec.text = "";
      _navigationService.goBack();
    } catch (e) {
      EasyLoading.dismiss();
      logger.e(e);
    }
  }

  Future updateEvent(String id) async {
    try {
      EasyLoading.show(status: 'Loading...');
      await _firestore.collection('events').doc(id).update({
        'title': newEventTitleTec.text,
        'description': newEventDetailTec.text,
        'event_date': "${eventDateTime.day}-${eventDateTime.month}-${eventDateTime.year}",
        'event_timestamp': eventDateTime,
      });
      clearEventsList();
      await getEvents();
      EasyLoading.dismiss();
      newEventTitleTec.text = "";
      newEventDetailTec.text = "";
      newEventDateTimeTec.text = "";
      _navigationService.goBack();
    } catch (e) {
      EasyLoading.dismiss();
      logger.e(e);
    }
  }

  Future deleteEvent(String id) async {
    try {
      EasyLoading.show(status: 'Loading...');
      await _firestore.collection('events').doc(id).update({'status': 2});
      clearEventsList();
      await getEvents();
      EasyLoading.dismiss();
      _navigationService.goBack();
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Something went wrong');
      logger.e(e);
    }
  }

  Future<void> selectEventDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: eventDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 100)),
    );
    if (pickedDate != null && pickedDate != eventDateTime) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        eventDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
        newEventDateTimeTec.text = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year} ${pickedTime.format(context)}";
        logger.i('eventDateTime -> ${eventDateTime.toString()}');
        logger.w('format -> ${pickedTime.format(context)}');
      }
    }
  }

  showEventDialog(BuildContext context, bool isNew, {EventModel? model}) async {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    FocusNode _focusNode1 = FocusNode();
    FocusNode _focusNode2 = FocusNode();
    FocusNode _focusNode3 = FocusNode();
    if (!isNew && model != null) {
      newEventTitleTec.text = model.title;
      newEventDetailTec.text = model.description;
      eventDateTime = model.eventDateTime!;
      TimeOfDay tOd = TimeOfDay.fromDateTime(eventDateTime);
      newEventDateTimeTec.text = "${eventDateTime.day}-${eventDateTime.month}-${eventDateTime.year} ${tOd.format(context)}";
    }

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Event Details'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SeTextField(
                  controller: newEventTitleTec,
                  hintText: 'Event Title',
                  focusNode: _focusNode1,
                  autoFocus: true,
                  isForm: true,
                  validator: 0,
                  onFieldSubmitted: (val) {
                    _focusNode2.requestFocus();
                  },
                  textInputAction: TextInputAction.next,
                ),
                SeTextField(
                  controller: newEventDetailTec,
                  hintText: 'Event Details',
                  focusNode: _focusNode2,
                  isForm: true,
                  validator: 0,
                  onFieldSubmitted: (val) {
                    selectEventDate(context);
                  },
                  textInputAction: TextInputAction.next,
                  // textInputType: TextInputType.multiline,
                ),
                GestureDetector(
                  onTap: () => selectEventDate(context),
                  child: AbsorbPointer(
                    child: SeTextField(
                      controller: newEventDateTimeTec,
                      hintText: 'Event Date',
                      focusNode: _focusNode3,
                      isForm: true,
                      validator: 0,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (val) {
                        if (_formKey.currentState!.validate()) {
                          if (isNew) {
                            createNewEvent();
                          } else {
                            updateEvent(model!.id);
                          }
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: new Text('Submit'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (isNew) {
                    createNewEvent();
                  } else {
                    updateEvent(model!.id);
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void launchURL(String url) async {
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }
}
