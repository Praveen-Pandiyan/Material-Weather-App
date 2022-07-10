// extension to convert temperature units

enum Temp { c, f, n }

extension ToTemp on num {
  num toTemp(Temp to) {
    if (to == Temp.c) {
      return ((this - 32) * 5 / 9).round();
    } else if (to == Temp.f) {
      return ((this * 9 / 5) + 32).round();
    } else {
      return this.round();
    }
  }
}
