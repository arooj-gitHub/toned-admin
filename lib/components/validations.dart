class Validations {
  String? validate(int decide, String value) {
    switch (decide) {
      case 0:
        // Simple
        return validateSimple(value);
      case 1:
        // Email
        return validateEmail(value);
      case 2:
        // Password
        return validatePassword(value);
      case 3:
        // Name
        return validateName(value);
      case 4:
        // Mobile
        return validateMobile(value);
      case 5:
        // Price
        return validatePrice(value);
      default:
        return null;
    }
  }

  String? validateName(String value) {
    if (value.isEmpty) return 'Name is required.';
    final RegExp nameExp = new RegExp(r'^[A-za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  String? validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern.toString());
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String? validatePassword(String value) {
    if (value.length < 8) return 'Please choose a strong password.';
    return null;
  }

  String? validateSimple(String value) {
    if (value.isEmpty) return "Field can't be empty";
    return null;
  }

  String? validateMobile(String value) {
    if (value.length < 6)
      return 'Mobile Number must be correct';
    else
      return null;
  }

  String? validatePrice(String value) {
    if (value.isEmpty)
      return 'Price must be valid';
    else if (double.parse(value) < 90)
      return 'Price must be greater than \$90';
    else
      return null;
  }
}
