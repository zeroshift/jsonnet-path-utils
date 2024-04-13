# jsonnet-path-utils

Jsonnet utils for overriding values at particular paths or array indexes.

- [jsonnet-path-utils](#jsonnet-path-utils)
  - [Overriding and patching a path of only keys](#overriding-and-patching-a-path-of-only-keys)
  - [Working with Arrays](#working-with-arrays)
  - [Advanced Usage](#advanced-usage)
    - [Chaining calls for deep nested objects within multiple arrays](#chaining-calls-for-deep-nested-objects-within-multiple-arrays)
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
local m = u.matchers;

{
  topKey: {
    array1: [
      {
        key1: 'value1',
        key2: 'value2',
      },
      {
        key1: 'value3',
        key2: 'value4',
      },
      {
        key1: 'value5',
        key2: 'value6',
      },
    ],
    array2: [
      'string1',
      'string2',
    ],
  },
}
+ u.withArrayItemAtPathMixin(
  'topKey.array1',
  m.objectKeyInItem('key1'),
  { key1: 'newValue1' }
)
+ u.withArrayItemAtPathMixin(
  'topKey.array1',
  m.objectKeyValueInItem({ key2: 'value4' }),
  { key2: 'newValueOnlyByKVCombo' },
)
+ u.withArrayItemAtPathMixin(
  'topKey.array1',
  m.itemAtIndex(2),
  { key2: 'newValueOnlyAtIndex2' },
)
+ u.withArrayItemAtPathMixin(
  'topKey.array1',
  m.allItems(),
  { key3: 'newKeyValueInAllArrayItems' },
)
+ {
  // using the shorthand '.' syntax is not required for the full path, just for the key that contains the array
  topKey+:
    {} +
    // Override a single string in an the array
    // Must use withArrayItemAtPath with m.stringItem as mixin is not supported for strings
    u.withArrayItemAtPath(
      'array2',
      m.stringItem('string2'),
      'newString2',
    ),
}
+ u.withArrayItemAtPathMixin(
  'topKey.array1',
  m.objectKeyInItem('key3'),
  { key4: super.key3 + '-copiedAndModified' },
  )

```

Renders as:

```yaml
topKey:
  array1:
    - key1: newValue1
      key2: value2
      key3: newKeyValueInAllArrayItems
      key4: newKeyValueInAllArrayItems-copiedAndModified
    - key1: newValue1
      key2: newValueOnlyByKVCombo
      key3: newKeyValueInAllArrayItems
      key4: newKeyValueInAllArrayItems-copiedAndModified
    - key1: newValue1
      key2: newValueOnlyAtIndex2
      key3: newKeyValueInAllArrayItems
      key4: newKeyValueInAllArrayItems-copiedAndModified
  array2:
    - string1
    - newString2
```

## Advanced Usage

### Chaining calls for deep nested objects within multiple arrays

```js
local u = import 'utils/main.libsonnet';
local m = u.matchers;

{
  level: 1,
  key1: {
    level: 2,
    array1: [
      {
        level: 3,
        array2: [],
      },
      {
        level: 3,
        array2: [
          {
            level: 4,
            key: 'foo',
          },
          {
            // duplicate to show behavior of some matchers
            level: 4,
            key: 'foo',
          },
          {
            level: 4,
            key: 'bar',
          },
        ],
      },
    ],
  },
}
// Mixin to array at path key1.array1, item at index 1
// We'll chain another function call as the override to continue to modify another array nested in the object
+ u.withArrayItemAtPathMixin(
  // Set path to array1
  path='key1.array1',  // This can also be specified as an array of strings if any keys contian dots
  // select by array index 1
  matcherFn=m.itemAtIndex(1),
  // We want to "jump through" this array, so we chain another function call
  // For the next array, we want to replace the object with exactly our override, so we use `withArrayItemAtPath` instead of `withArrayItemAtPathMixin`
  override=u.withArrayItemAtPath(
    // select the key array1
    path='array2',
    // use the objectKeyValueInItem matcher to select any array item object with key='foo'
    matcherFn=m.objectKeyValueInItem({ key: 'foo' }),
    // specify the object we want to override
    override={ key: 'newVal' },
  ),
)
```

Evaluates to:

```yaml
key1:
  array1:
    - array2: []
      level: 3
    - array2:
        - key: newVal
        - key: newVal
        - key: bar
          level: 4
      level: 3
  level: 2
level: 1
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
