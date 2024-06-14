local u = import '../path-utils/main.libsonnet';
local m = u.matchers;

{
  array1: [
    {
      key1: 'value1',
      key2: 'value2',
    },
    {
      key1: 'value3',
      key2: 'value4',
    },
  ],
  array2: [
    {
      key1: 'value5',
      key2: 'value6',
    },
    {
      key1: 'value7',
      key2: 'value8',
    },
  ],
}
+ u.withArrayItemAtPathMixin(
  'array1',
  m.itemAtIndex(0),
  { key1: 'newValue1' },
)
+ u.withArrayItemAtPath(
  'array2',
  m.itemAtIndex(1),
  { key: 'newValue' },
)
