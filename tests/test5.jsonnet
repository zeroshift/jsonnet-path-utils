local u = import '../utils/main.libsonnet';
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
  m.allItems(),
  { key3: 'newValue' },
)
+ u.withArrayItemAtPath(
  'array2',
  m.allItems(),
  { key: 'newValue' },
)
