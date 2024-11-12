class Solution {
  bool judgeCircle(String moves) {
    int countU = 'U'.allMatches(moves).length;
    int countD = 'D'.allMatches(moves).length;
    int countR = 'R'.allMatches(moves).length;
    int countL = 'L'.allMatches(moves).length;
    return countU == countD && countR == countL;
  }
}
