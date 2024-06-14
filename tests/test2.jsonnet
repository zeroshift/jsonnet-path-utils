local u = import '../path-utils/main.libsonnet';
local m = u.matchers;

{
  array1: [
    'string1',
    'string2',
    'string3',
  ],
}
+ u.withArrayItemAtPath(
  'array1',
  m.stringItem('string2'),
  'newString',
)
