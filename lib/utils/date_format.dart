String _two(int n) => n.toString().padLeft(2, '0');

String _time(DateTime t) => '${_two(t.hour)}:${_two(t.minute)}';

String formatDateTime(DateTime t) =>
    '${_two(t.day)}/${_two(t.month)}/${t.year} às ${_time(t)}';

String formatRelativeDateTime(DateTime t, {DateTime? now}) {
  final n = now ?? DateTime.now();
  final today = DateTime(n.year, n.month, n.day);
  final day = DateTime(t.year, t.month, t.day);

  final daysAgo = (today.difference(day).inHours / 24).round();

  if (daysAgo == 0) return 'Hoje às ${_time(t)}';
  if (daysAgo == 1) return 'Ontem às ${_time(t)}';
  if (day.year == today.year) {
    return '${_two(t.day)}/${_two(t.month)} às ${_time(t)}';
  }
  return formatDateTime(t);
}
