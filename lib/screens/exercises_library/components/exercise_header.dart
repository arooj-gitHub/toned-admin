import 'package:toned_australia/components/se_text_field.dart';
import 'package:toned_australia/controllers/menu_controller.dart';
import 'package:toned_australia/providers/exercise_library_provider.dart';
import 'package:toned_australia/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';

class ExerciseHeader extends StatefulWidget {
  final String title;

  const ExerciseHeader({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<ExerciseHeader> createState() => _ExerciseHeaderState();
}

class _ExerciseHeaderState extends State<ExerciseHeader> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseLibraryProvider>(
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
                provider.showExerciseLibraryDialog(context, true);
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
