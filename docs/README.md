# jsonnet-path-utils


## Install

```
jb install github.com/zeroshift/jsonnet-path-utils/utils/main.libsonet@master
```

## Usage

```jsonnet
local jsonnet-path-utils = import "github.com/zeroshift/jsonnet-path-utils/utils/main.libsonet"
```


## Index

* [`fn withArrayItemAtPath(path, matcherFn, override)`](#fn-witharrayitematpath)
* [`fn withArrayItemAtPathMixin(path, matcherFn, override)`](#fn-witharrayitematpathmixin)
* [`fn withValueAtPath(path, override)`](#fn-withvalueatpath)
* [`fn withValueAtPathMixin(path, override)`](#fn-withvalueatpathmixin)
* [`obj matchers`](#obj-matchers)
  * [`fn allItems()`](#fn-matchersallitems)
  * [`fn itemAtIndex(matcher)`](#fn-matchersitematindex)
  * [`fn objectKeyInItem(matcher)`](#fn-matchersobjectkeyinitem)
  * [`fn objectKeyValueInItem(matcher)`](#fn-matchersobjectkeyvalueinitem)
  * [`fn stringItem(matcher)`](#fn-matchersstringitem)

## Fields

### fn withArrayItemAtPath

```jsonnet
withArrayItemAtPath(path, matcherFn, override)
```

PARAMETERS:

* **path** (`string`)
* **matcherFn** (`function`)
* **override** (`any`)

Function to replace an item inside an array based on the result of the provided matcher function.
### fn withArrayItemAtPathMixin

```jsonnet
withArrayItemAtPathMixin(path, matcherFn, override)
```

PARAMETERS:

* **path** (`string`)
* **matcherFn** (`function`)
* **override** (`any`)

Function to patch an item inside an array based on the result of the provided matcher function.
### fn withValueAtPath

```jsonnet
withValueAtPath(path, override)
```

PARAMETERS:

* **path** (`string`)
* **override** (`any`)

Function to replace an item at the provided path.
### fn withValueAtPathMixin

```jsonnet
withValueAtPathMixin(path, override)
```

PARAMETERS:

* **path** (`string`)
* **override** (`any`)

Function to patch an item at the provided path.
### obj matchers

Matcher functions used to match items in an array or object. These functions are used in conjunction with withArrayItemAtPath and withValueAtPath to match items in an array or object.

#### fn matchers.allItems

```jsonnet
matchers.allItems()
```


A matcher function that matches all items in an array or object.
#### fn matchers.itemAtIndex

```jsonnet
matchers.itemAtIndex(matcher)
```

PARAMETERS:

* **matcher** (`number`)

A matcher function that matches an item at a specific index.
#### fn matchers.objectKeyInItem

```jsonnet
matchers.objectKeyInItem(matcher)
```

PARAMETERS:

* **matcher** (`string`)

A matcher function that matches an object that contains a specific key name.
#### fn matchers.objectKeyValueInItem

```jsonnet
matchers.objectKeyValueInItem(matcher)
```

PARAMETERS:

* **matcher** (`object`)

A matcher function that matches an object that contains a specific key:value pair.
#### fn matchers.stringItem

```jsonnet
matchers.stringItem(matcher)
```

PARAMETERS:

* **matcher** (`string`)

A matcher function that matches a string item in an array.