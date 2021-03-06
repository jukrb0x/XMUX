part of 'timetable.dart';

class TimeTableGrid extends StatelessWidget {
  final List<Timetable_Class> classes;

  const TimeTableGrid(this.classes);

  @override
  Widget build(BuildContext context) {
    var periods = Iterable<int>.generate(13)
        .map((i) => SpannableGridCell(
              id: i,
              column: 1,
              row: i + 2,
              columnFlex: 1,
              child: Column(
                children: <Widget>[
                  Divider(height: 1),
                  Expanded(
                    child: Center(
                      child: Text(
                        '${i + 8} - ${i + 9}',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ),
                  Divider(height: 1),
                ],
              ),
            ))
        .toList();
    var weekdayCells = Iterable<int>.generate(5)
        .map((i) => SpannableGridCell(
              id: i.toString().hashCode,
              column: i + 2,
              row: 1,
              child: Center(
                child: Text(
                  'General_Weekday${i + 1}'.tr(),
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ))
        .toList();
    var timetableCells = classes
        .map((c) => SpannableGridCell(
              id: c.hashCode,
              column: c.day + 1,
              row: c.begin.toDateTime().toLocal().hour - 6,
              rowSpan: c.end.toDateTime().toLocal().hour -
                  c.begin.toDateTime().toLocal().hour,
              columnFlex: 2,
              rowFlex: 3,
              child: ClassCard(
                c,
                isInGrid: true,
              ),
            ))
        .toList();

    return SingleChildScrollView(
      padding: EdgeInsets.only(top: Scaffold.of(context).appBarMaxHeight),
      child: SizedBox(
        height: 1111,
        child: SpannableGrid(
          rows: 14,
          columns: 6,
          spacing: 1,
          cells: [
            ...timetableCells,
            ...weekdayCells,
            ...periods,
          ],
        ),
      ),
    );
  }
}
