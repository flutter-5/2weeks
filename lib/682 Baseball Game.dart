class Solution {
  int calPoints(List<String> ops) {
    List<int> record = [];
    for (String op in ops) {
      if (op == 'C') {
        if (record.length > 0) {
          record.removeAt(record.length - 1);
        }
      } else if (op == 'D') {
        if (record.length > 0) {
          record.add(record[record.length - 1] * 2);
        }
      } else if (op == '+') {
        if (record.length > 1) {
          record.add(record[record.length - 1] + record[record.length - 2]);
        }
      } else {
        record.add(int.parse(op));
      }
    }
    return record.fold(0, (a, b) => a + b);

    /// return record.reduce((a, b) => a + b);로 작성시 오류 issue
  }
}
