local pathHelper = function(path)
  if std.isString(path) then
    std.split(path, '.')
  else if std.isArray(path) then
    path
  else
    error 'Path should be either a string or array!';

{
  matchers:: {

    // NOTE: Change these back to returning a true/false value but still send in mixin to assert if it's possible

    allItems()::
      local fn =
        function(index, item, override, mixin) true;
      fn,

    stringItem(matcher)::
      assert std.isString(matcher) : 'matcher must be a string!';
      local fn =
        function(index, item, override, mixin)
          assert mixin == false : 'mixin is not supported for stringItem! Use withArrayItemAtPath instead.';
          if std.isString(item) && item == matcher then
            true
          else
            false;
      fn,

    itemAtIndex(matcher)::
      assert std.isNumber(matcher) : 'matcher must be a number!';
      local fn =
        function(index, item, override, mixin)
          if index == matcher then
            true
          else
            false;
      fn,

    objectKeyInItem(matcher)::
      assert std.isString(matcher) : 'matcher must be a string!';
      local fn =
        function(index, item, override, mixin)
          if std.isObject(item) && std.objectHas(item, matcher) then
            true
          else
            false;
      fn,

    objectKeyValueInItem(matcher)::
      assert (std.isObject(matcher) && std.length(matcher) == 1) : 'matcher must be an object with a single key-value pair!';
      local fn = function(index, item, override, mixin)
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

  _withArrayItem(arr, override, matcherFn, mixin=false)::
    assert std.isArray(arr) : 'Item must be an array!';
    std.mapWithIndex(
      function(index, item)
        assert std.isFunction(matcherFn) : 'matcherFn must be a function!';
        if matcherFn(index, item, override, mixin) then
          overrideValue(item, override, mixin)
        else
          item,
      arr
    ),

  _withArrayItemMixin(arr, override, matcherFn)::
    $._withArrayItem(arr, override, matcherFn, mixin=true),

  withArrayItemAtPath(path, override, matcherFn=$.matchers.objectKeyValueInItem, mixin=false, depth=0)::
    local pathArray = pathHelper(path);
    local key = pathArray[depth];
    if depth < std.length(pathArray) - 1 then
      { [key]+: $.withArrayItemAtPath(path, override, matcherFn, mixin, (depth + 1)) }
    else if mixin == true then
      { [key]: $._withArrayItemMixin(super[key], override, matcherFn) }
    else
      { [key]: $._withArrayItem(super[key], override, matcherFn) },

  withArrayItemAtPathMixin(path, override, matcherFn=$.matchers.objectKeyValueInItem)::
    $.withArrayItemAtPath(path, override, matcherFn, mixin=true, depth=0),

  withValueAtPath(path, override, mixin=false, depth=0)::
    local pathArray = pathHelper(path);
    local key = pathArray[depth];
    if depth < std.length(pathArray) - 1 then
      { [key]+: $.withValueAtPath(path, override, mixin=mixin, depth=(depth + 1)) }
    else if mixin == true then
      { [key]+: override }
    else
      { [key]: override },

  withValueAtPathMixin(path, override)::
    $.withValueAtPath(path, override, mixin=true, depth=0),
}
