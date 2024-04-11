# jsonnet-path-utils

Jsonnet utils for overriding values at particular paths or array indexes.

- [jsonnet-path-utils](#jsonnet-path-utils)
  - [Overriding and patching a path of only keys](#overriding-and-patching-a-path-of-only-keys)
  - [Working with Arrays](#working-with-arrays)
  - [Known issues](#known-issues)

## Overriding and patching a path of only keys

```js
local u = import 'util.libsonnet';
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
// Override key4
+ u.withValueAtPath('key1.key2.key3.key4', { test: 'valOverride' })

// Mixin data to key4
+ u.withValueAtPathMixin('key1.key2.key3.key4', { testMixin: 'valMixin' })
```

Renders as:

```yaml
anotherKey:
  subkey: value
key1:
  key2:
    key3:
      key4:
        test: valOverride
        testMixin: valMixin
```

## Working with Arrays

```js
local u = import 'utils/main.libsonnet';
// We have an array nested  in an object
{
  topkey1: {
    arr1: [
      { key1: {} },
      { key1: { subKey1: 'val' } },
    ],
  },
  topkey2: {
    'subKey.hasDot': [
      { key1: {} },
    ],
  },
}

// Mixin new object to array items that contain all key/value pairs
+ u.withArrayItemAtPathMixin(
  'topkey1.arr1',
  { key2: 'valueByMatcher' },
  matcher={ key1: {} },
)

// Mixin new object to specific array item at index 0
+ u.withArrayItemAtPathMixin(
  'topkey1.arr1',
  { key1: 'newValueByIndex' },
  matcher=0,
)

// Mixin object to all items of an array
+ u.withArrayItemAtPathMixin(
  'topkey1.arr1',
  { allKey+: 'allValue' },
  matcher='*',
)

// Chaining calls
+ u.withArrayItemAtPathMixin(
  'topkey1.arr1',
  u.withValueAtPathMixin(
    'key2.newArray',
    [
      u.withValueAtPath('key1', { subKey1: 'val' }),
    ],
  ),
  matcher=1,
)

// Mixin with array path
+ u.withArrayItemAtPathMixin(
  ['topkey2', 'subKey.hasDot'],
  { key1: 'newValueByIndex' },
  matcher=0,
)

// The following ith throw an error

// + u.withArrayItemAtPathMixin(
//   'topkey1.arr1',
//   { allKey+: 'allValue' },
//   matcher='err',
// )
```

Renders as:

```yaml
topkey1:
  arr1:
    - allKey: allValue
      key1: newValueByIndex
      key2: valueByMatcher
    - allKey: allValue
      key1:
        subKey1: val
      key2:
        newArray:
          - key1:
              subKey1: val
topkey2:
  subKey.hasDot:
    - key1: newValueByIndex
```

## Known issues

- All of the keys in the dot notated path string will be expanded as a patch. For instance:

  ```js
  'key1.key2' = {key1+: { key2+: {} } }
  ```

  This means that you need to have the key you want to override as part of your override object. For instance if I wanted to replace what's in key2, I would need to specify:

  ```js
  + u.withValueAtPath(
    'key1',
    { key2: { test: 'value' } }
  )
  ```
