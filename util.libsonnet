{
  getObjectAtIndex(targetIndex, arr)::
    std.prune(
      std.mapWithIndex(
        function(index, item)
          if index == targetIndex
          then item,
        arr
      )
    )[0],

  withArrayItemByMatch(matcher, arr, override, mixin=false)::
    std.map(
      function(item)
        local key = std.objectFields(matcher)[0];
        local val = std.objectValues(matcher)[0];
        if std.objectHas(item, key) && std.get(item, key, default=null, inc_hidden=true) == val
        then
          if mixin == true
          then item + override
          else override
        else item,
      arr
    ),

  withArrayItemByMatchMixin(matcher, arr, override)::
    $.withArrayItemByMatch(matcher, arr, override, mixin=true),

  withArrayItemAtIndex(targetIndex, arr, override, mixin=false)::
    std.mapWithIndex(
      function(index, item)
        if index == targetIndex
        then
          if mixin == true
          then item + override
          else override
        else item,
      arr
    ),

  withArrayItemAtIndexMixin(targetIndex, arr, override)::
    $.withArrayItemAtIndex(targetIndex, arr, override, mixin=true),

  withArrayItemAtPath(path, override, arrayIndex=0, mixin=false, depth=0)::
    local pathArray = std.split(path, '.');
    local key = pathArray[depth];
    if depth < std.length(pathArray) - 1
    then { [key]+: $.withArrayItemAtPath(path, override, arrayIndex, mixin, (depth + 1)) }
    else
      if mixin == true
      then { [key]: $.withArrayItemAtIndexMixin(arrayIndex, super[key], override) }
      else { [key]: $.withArrayItemAtIndex(arrayIndex, super[key], override) },

  withArrayItemAtPathMixin(path, override, arrayIndex=0)::
    $.withArrayItemAtPath(path, override, arrayIndex, mixin=true, depth=0),

  withObjectAtPath(path, override, mixin=false, depth=0)::
    local pathArray = std.split(path, '.');
    local key = pathArray[depth];
    if depth < std.length(pathArray) - 1
    then { [key]+: $.withObjectAtPath(path, override, mixin=mixin, depth=(depth + 1)) }
    else
      if mixin == true
      then { [key]+: override }
      else { [key]: override },

  withObjectAtPathMixin(path, override)::
    $.withObjectAtPath(path, override, mixin=true, depth=0),

}
