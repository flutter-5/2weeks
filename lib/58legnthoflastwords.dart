class Solution {
  int lengthOfLastWord(String s) {
    String word = s.trim();
    return word.length - s.lastIndexOf(' ') - 1;
  }
}
