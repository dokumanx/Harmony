class FormValidation {
  dynamic validateEmail(String value) =>
      value.isEmpty ? 'Enter your email' : null;

  dynamic validatePassword(String value) =>
      value.length < 6 ? 'Password should be at least 6 character' : null;

  dynamic validateName(String value) => value.isEmpty ? 'Enter a name' : null;
}
