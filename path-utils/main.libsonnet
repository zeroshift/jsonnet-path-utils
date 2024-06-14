local d = import 'doc-util/main.libsonnet';

local pathHelper = function(path)
  if std.isString(path) then
    std.split(path, '.')
  else if std.isArray(path) then
    path
  else
    error 'Path should be either a string or array!';

{
  // package declaration
  '#': d.pkg(
    name='jsonnet-path-utils',
    url='github.com/zeroshift/jsonnet-path-utils/utils/main.libsonet',
    help='',
  ),

  '#matchers': d.obj('Matcher functions used to match items in an array or object. These functions are used in conjunction with withArrayItemAtPath and withValueAtPath to match items in an array or object.'),
  matchers:: {

    // NOTE: Change these back to returning a true/false value but still send in mixin to assert if it's possible

    '#allItems': d.fn('A matcher function that matches all items in an array or object.'),
    allItems()::
      local fn =
        function(index, item, mixin) true;
      fn,

    '#stringItem': d.fn('A matcher function that matches a string item in an array.', [d.arg('matcher', d.T.string)]),
    stringItem(matcher)::
      assert std.isString(matcher) : 'matcher must be a string!';
      local fn =
        function(index, item, mixin)
          assert mixin == false : 'mixin is not supported for stringItem! Use withArrayItemAtPath instead.';
          if std.isString(item) && item == matcher then
            true
          else
            false;
      fn,

    '#itemAtIndex': d.fn('A matcher function that matches an item at a specific index.', [d.arg('matcher', d.T.number)]),
    itemAtIndex(matcher)::
      assert std.isNumber(matcher) : 'matcher must be a number!';
      local fn =
        function(index, item, mixin)
          if index == matcher then
            true
          else
            false;
      fn,

    '#objectKeyInItem': d.fn('A matcher function that matches an object that contains a specific key name.', [d.arg('matcher', d.T.string)]),
    objectKeyInItem(matcher)::
      assert std.isString(matcher) : 'matcher must be a string!';
      local fn =
        function(index, item, mixin)
          if std.isObject(item) && std.objectHas(item, matcher) then
            true
          else
            false;
      fn,

    '#objectKeyValueInItem': d.fn('A matcher function that matches an object that contains a specific key:value pair.', [d.arg('matcher', d.T.object)]),
    objectKeyValueInItem(matcher)::
      assert (std.isObject(matcher) && std.length(matcher) == 1) : 'matcher must be an object with a single key-value pair!';
      local fn = function(index, item, mixin)
        local key = std.objectFields(matcher)[0];
        local val = std.objectValues(matcher)[0];
        if std.isObject(item) && std.objectHas(item, key) && std.get(item, key, default=null, inc_hidden=true) == val then
          true
        else
          false;
      fn,

  },

  local overrideValue = function(item, override, mixin)
    if mixin == true then
      item + override
    else
      override,

  local overrideArrayItem = function(arr, matcherFn, override, mixin=false)
    assert std.isArray(arr) : 'Item must be an array!';
    assert std.isFunction(matcherFn) : 'matcherFn must be a function!';
    std.mapWithIndex(
      function(index, item)
        if matcherFn(index, item, mixin) then
          overrideValue(item, override, mixin)
        else
          item,
      arr
    ),

  '#withArrayItemAtPath': d.fn('Function to replace an item inside an array based on the result of the provided matcher function.', [d.arg('path', d.T.string), d.arg('matcherFn', d.T.func), d.arg('override', d.T.any)]),
  withArrayItemAtPath(path, matcherFn, override, mixin=false, depth=0)::
    local pathArray = pathHelper(path);
    local key = pathArray[depth];
    if depth < std.length(pathArray) - 1 then
      { [key]+: $.withArrayItemAtPath(path, matcherFn, override, mixin, (depth + 1)) }
    else
      { [key]: overrideArrayItem(super[key], matcherFn, override, mixin) },

  '#withArrayItemAtPathMixin': d.fn('Function to patch an item inside an array based on the result of the provided matcher function.', [d.arg('path', d.T.string), d.arg('matcherFn', d.T.func), d.arg('override', d.T.any)]),
  withArrayItemAtPathMixin(path, matcherFn, override)::
    $.withArrayItemAtPath(path, matcherFn, override, mixin=true, depth=0),

  '#withValueAtPath': d.fn('Function to replace an item at the provided path.', [d.arg('path', d.T.string), d.arg('override', d.T.any)]),
  withValueAtPath(path, override, mixin=false, depth=0)::
    local pathArray = pathHelper(path);
    local key = pathArray[depth];
    if depth < std.length(pathArray) - 1 then
      { [key]+: $.withValueAtPath(path, override, mixin=mixin, depth=(depth + 1)) }
    else if mixin == true then
      { [key]+: override }
    else
      { [key]: override },

  '#withValueAtPathMixin': d.fn('Function to patch an item at the provided path.', [d.arg('path', d.T.string), d.arg('override', d.T.any)]),
  withValueAtPathMixin(path, override)::
    $.withValueAtPath(path, override, mixin=true, depth=0),
}
