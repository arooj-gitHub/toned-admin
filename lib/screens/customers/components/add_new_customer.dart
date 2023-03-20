import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toned_australia/components/se_text_field.dart';
import 'package:toned_australia/controllers/menu_controller.dart';
import 'package:toned_australia/providers/customers_provider.dart';
import 'package:toned_australia/responsive.dart';

import '../../../constants.dart';

class CustomerHeader extends StatefulWidget {
  const CustomerHeader({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomerHeader> createState() => _CustomerHeaderState();
}

class _CustomerHeaderState extends State<CustomerHeader> {
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
            'Customer',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),

        ElevatedButton.icon(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: defaultPadding * 1.5,
              vertical: defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
            ),
          ),
          onPressed: () {
            _displayDialog(context);
          },
          icon: Icon(Icons.add),
          label: Text("Add New"),
        ),
      ],
    );
  }

  _displayDialog(BuildContext context) async {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    FocusNode usernameNode = FocusNode();
    FocusNode passwordNode = FocusNode();
    FocusNode emailNode = FocusNode();

    final _provider = Provider.of<CustomersProvider>(context, listen: false);

    return showDialog(
        context: context,
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 400,
                height: 400,
                child: AlertDialog(
                  title: Text('Add New Customer'),
                  content: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SeTextField(
                          controller: _provider.username,
                          hintText: 'username',
                          focusNode: usernameNode,
                          autoFocus: true,
                          isForm: true,
                          validator: 0,
                        ),
                        SeTextField(
                          controller: _provider.email,
                          hintText: 'email',
                          focusNode: emailNode,
                          autoFocus: true,
                          isForm: true,
                          validator: 0,
                        ),
                        SeTextField(
                          controller: _provider.password,
                          hintText: 'password',
                          focusNode: passwordNode,
                          autoFocus: true,
                          isForm: true,
                          validator: 0,
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    new TextButton(
                      child: new Text('Submit'),
                      onPressed: () async => await _provider.addNewCustomer(context),
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }
}
