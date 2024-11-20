extension HexString on List {
  String toHexString() {
    StringBuffer buffer = StringBuffer();
    for (int part in this) {
      if (part & 0xff != part) {
        throw FormatException("Non-byte integer detected");
      }
      buffer.write('${part < 16 ? '0' : ''}${part.toRadixString(16)}');
    }
    return buffer.toString();
  }
}
