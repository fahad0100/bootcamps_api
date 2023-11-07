validatorBody({required Map body, required List keyBody}) {
  if (body.keys.length != keyBody.length) {
    throw FormatException("The body must contain only $keyBody");
  }

  for (var element in keyBody) {
    if (!body.containsKey(element)) {
      throw FormatException("$element is required");
    }
  }
}