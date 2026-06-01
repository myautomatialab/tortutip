class HardcoreSession {
  HardcoreSession._();

  static bool isActive = false;

  static void start() => isActive = true;

  static void end() => isActive = false;
}
