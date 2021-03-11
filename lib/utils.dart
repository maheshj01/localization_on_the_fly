/// The number of variables in the statement must match the length of
/// args list
String localize(String string, List<String> args) {
  if (args == null || args.isEmpty) return string;
  List<String> list = string.split(' ').toList();
  int count = 0;

  /// TODO: handle case where in the argument length is mismatched
  /// with Strings ({}) to be replaced
  for (int i = 0; i < list.length; i++) {
    if (list[i].contains(r'{')) {
      list[i] = args[count];
      count += 1;
    }
  }
  return list.join(' ');
}
