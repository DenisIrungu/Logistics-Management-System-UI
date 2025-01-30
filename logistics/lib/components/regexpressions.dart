final emailRegExp= RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

final passWordRegExp= RegExp (r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

final upperCaseExp= RegExp(r'[A-Z]');

final lowerCaseExp= RegExp(r'[a-z]');

final numbersExp= RegExp(r'[0-9]');

final specialCaseExp = RegExp(r'[!@#$%^&*(),.?":{}|<>]');