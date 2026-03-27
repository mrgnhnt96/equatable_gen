import 'package:e2e_tests/gen/extends/ignore_super_override.dart';
import 'package:test/test.dart';

void main() {
  group(IgnoreSuperOverrideChild, () {
    test('props uses subclass fields only; super field ignored on override', () {
      final a = IgnoreSuperOverrideChild(['x', 'y']);
      final b = IgnoreSuperOverrideChild(['z', 'y']);

      expect(a.props, [a.paths]);
      expect(a, isNot(b));
      expect(
        IgnoreSuperOverrideChild(['p']),
        equals(IgnoreSuperOverrideChild(['p'])),
      );
    });
  });
}
