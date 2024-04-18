local u = import '../utils/main.libsonnet';

{
  key1: {
    key2: {
      key3: {
        key4: {
          orig: 'val',
        },
      },
    },
  },
  anotherKey: {
    subkey: 'value',
  },
}
+ u.withValueAtPath('key1.key2.key3.key4', { test: 'valOverride' })
+ u.withValueAtPathMixin('key1.key2.key3.key4', { testMixin: 'valMixin' })
