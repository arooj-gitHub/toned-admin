import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:toned_australia/components/se_text_field.dart';
import 'package:toned_australia/controllers/menu_controller.dart';
import 'package:toned_australia/providers/groups_provider.dart';
import 'package:toned_australia/responsive.dart';

import '../../../app_router.dart';
import '../../../constants.dart';

class GroupsHeader extends StatefulWidget {
  final String title;
  final int isGroup;

  const GroupsHeader({
    Key? key,
    required this.title,
    required this.isGroup,
  }) : super(key: key);

  @override
  State<GroupsHeader> createState() => _GroupsHeaderState();
}

class _GroupsHeaderState extends State<GroupsHeader> {
  @override
  Widget build(BuildContext context) {
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
            style: Theme.of(context).textTheme.titleLarge,
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
            if (widget.isGroup == 4) {
              Provider.of<GroupsProvider>(context, listen: false)
                  .addNewExercise();
            } else if (widget.isGroup == 3) {
              Navigator.pushNamed(context, AppRoute.addExerciseScreen);
            } else {
              _displayDialog(context);
            }
          },
          icon: Icon(Icons.add),
          label: Text(widget.isGroup == 4 ? "Save" : "Add New"),
        ),
      ],
    );
  }

  _displayDialog(BuildContext context) async {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    FocusNode _focusNode = FocusNode();
    final _provider = Provider.of<GroupsProvider>(context, listen: false);

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(getTitle(widget.isGroup)),
            content: Form(
              key: _formKey,
              child: SeTextField(
                controller: _getTextEditingCont(),
                hintText: getHint(widget.isGroup),
                focusNode: _focusNode,
                autoFocus: true,
                isForm: true,
                validator: 0,
                onFieldSubmitted: (val) {
                  _createDoc(_formKey);
                },
              ),
              // child: TextFormField(
              //   controller: _provider.newGroupNameTec,
              //   textInputAction: TextInputAction.go,
              //   keyboardType: TextInputType.numberWithOptions(),
              //   decoration: InputDecoration(hintText: "Group Name"),
              // ),
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text('Submit'),
                onPressed: () => _createDoc(_formKey),
              )
            ],
          );
        });
  }

  String getTitle(int isGroup) {
    String _title = 'What is the group name';
    switch (isGroup) {
      case 1:
        _title = 'What is the group name';
        break;
      case 2:
        _title = 'What is the program name';
        break;
      case 3:
        _title = 'What is the exercise name';
        break;
      default:
        _title = 'What is the group name';
        break;
    }
    return _title;
  }

  String getHint(int isGroup) {
    String _title = 'Group name';
    switch (isGroup) {
      case 1:
        _title = 'Group name';
        break;
      case 2:
        _title = 'Program name';
        break;
      case 3:
        _title = 'Exercise name';
        break;
      default:
        _title = 'Group name';
        break;
    }
    return _title;
  }

  Future _createDoc(GlobalKey<FormState> _formKey) async {
    final _provider = Provider.of<GroupsProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      switch (widget.isGroup) {
        case 1:
          await _provider.createGroup();
          break;
        case 2:
          await _provider.createProgram();
          break;
        case 3:
          await _provider.createGroup();
          break;
        default:
          break;
      }
    }
  }

  TextEditingController _getTextEditingCont() {
    final _provider = Provider.of<GroupsProvider>(context, listen: false);
    TextEditingController _tEc = _provider.newGroupNameTec;
    switch (widget.isGroup) {
      case 1:
        _tEc = _provider.newGroupNameTec;
        break;
      case 2:
        _tEc = _provider.newProgramNameTec;
        break;
      case 3:
        _tEc = _provider.newGroupNameTec;
        break;
      default:
        break;
    }
    return _tEc;
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: secondaryColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(defaultPadding * 0.75),
            margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    );
  }
}
