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
+ u.withObjectAtPath('key1.key2.key3.key4', { test: 'valOverride' })

// Mixin data to key4
+ u.withObjectAtPathMixin('key1.key2.key3.key4', { testMixin: 'valMixin' })
```

Renders as:

```json
{
   "key1": {
      "key2": {
         "key3": {
            "key4": {
               "test": "valOverride",
               "testMixin": "valMixin"
            }
         }
      }
   },
   "anotherKey": {
      "subkey": "value"
   },
}
```

## Working with Arrays

```js
local u = import 'util.libsonnet';
// We have an array nested  in an object
{
  topkey1: {
    arr1: [
      { key1: {} },
      { key2: { subkey1: 'val' } },
    ],
  },
} +
// Mixin an object into an array at a specific index
u.withArrayItemByIndexAtPathMixin(
  'topkey1.arr1',
  u.withObjectAtPathMixin('mixinSubkey1.mixinSubkey2', 'mixinByIndex'),
  arrayIndex=0
)
// Override an object at a specific index
+ u.withArrayItemByIndexAtPath(
  'topkey1.arr1',
  {overrideSubkey1: {overrideSubkey2: 'override'}}, // This can just be ab object as well
  arrayIndex=1
)
// Mixin an object into an array by selecting items that match a certain {key: value} pair.
+ u.withArrayItemByMatchAtPathMixin(
  'topkey1.arr1',
  u.withObjectAtPath('key1', 'mixinByMatch'),
  matcher={ key1: {} }
)
```

Renders as:

```json
{
   "topkey1": {
      "arr1": [
         {
            "key1": "mixinByMatch",
            "mixinSubkey1": {
               "mixinSubkey2": "mixinByIndex"
            }
         },
         {
            "overrideSubkey1": {
               "overrideSubkey2": "override"
            }
         }
      ]
   }
}
```

## Known issues

- All of the keys in the dot notated path string will be expanded as a patch. For instance:

  ```js
  'key1.key2' = {key1+: { key2+: {} } }
  ```

  This means that you need to have the key you want to override as part of your override object. For instance if I wanted to replace what's in key2, I would need to specify:

  ```js
  + u.withObjectAtPath(
    'key1',
    { key2: { test: 'value' } }
  )
  ```
