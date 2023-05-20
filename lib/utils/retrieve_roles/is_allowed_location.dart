bool is_allowed_location(Map? dict, int number) {
  if(dict != null)
    return dict.values.any((value) => value.contains(number));
  return false;
}