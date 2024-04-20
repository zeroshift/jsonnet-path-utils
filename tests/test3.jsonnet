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
      key3: 'value5',
    },
  ],
  array2: [
    {
      key1: 'value6',
      key2: 'value7',
    },
    {
      key1: 'value8',
      key2: 'value9',
      key3: 'value10',
    },
  ],
}
+ u.withArrayItemAtPathMixin(
  'array1',
  m.objectKeyInItem('key1'),
  {
    key1: 'newValue',
    newKey: 'newValue',
  },
)
+ u.withArrayItemAtPath(
  'array2',
  m.objectKeyInItem('key3'),
  'objectRepacedWithNewValue',
)
