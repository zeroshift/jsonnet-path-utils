local overrideValue = function(item, override, mixin)
  if mixin == true then
    item + override
  else
    override;

local pathHelper = function(path)
  if std.isString(path) then
    std.split(path, '.')
  else if std.isArray(path) then
    path
  else
    error 'Path should be either a string or array!';

{
  _withArrayItem(arr, override, matcher, mixin=false)::
    std.mapWithIndex(
      function(index, item)
        if matcher == '*' then
          overrideValue(item, override, mixin)
        else if std.isNumber(matcher) then
          if index == matcher then
            overrideValue(item, override, mixin)
          else
            item
        else if std.isObject(matcher) then
          local key = std.objectFields(matcher)[0];
          local val = std.objectValues(matcher)[0];
          if std.objectHas(item, key) && std.get(item, key, default=null, inc_hidden=true) == val then
            overrideValue(item, override, mixin)
          else
            item
        else
          error 'unkown matcher!',
      arr
    ),

  _withArrayItemMixin(arr, override, matcher)::
    $._withArrayItem(arr, override, matcher, mixin=true),

  withArrayItemAtPath(path, override, matcher, mixin=false, depth=0)::
    local pathArray = pathHelper(path);
    local key = pathArray[depth];
    if depth < std.length(pathArray) - 1 then
      { [key]+: $.withArrayItemAtPath(path, override, matcher, mixin, (depth + 1)) }
    else if mixin == true then
      { [key]: $._withArrayItemMixin(super[key], override, matcher) }
    else
      { [key]: $._withArrayItem(super[key], override, matcher) },

  withArrayItemAtPathMixin(path, override, matcher)::
    $.withArrayItemAtPath(path, override, matcher, mixin=true, depth=0),

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
