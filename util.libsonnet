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

  withArrayItemAll(arr, override, mixin=false)::
    std.map(
      function(item)
        if mixin == true
        then item + override
        else override,
      arr
    ),

  withArrayItemAllMixin(arr, override)::
    $.withArrayItemAll(arr, override, mixin=true),

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

  withArrayItemByIndex(targetIndex, arr, override, mixin=false)::
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

  withArrayItemByIndexMixin(targetIndex, arr, override)::
    $.withArrayItemByIndex(targetIndex, arr, override, mixin=true),

  withArrayItemAllAtPath(path, override, mixin=false, depth=0)::
    local pathArray = std.split(path, '.');
    local key = pathArray[depth];
    if depth < std.length(pathArray) - 1
    then { [key]+: $.withArrayItemAllAtPath(path, override, mixin, (depth + 1)) }
    else
      if mixin == true
      then { [key]: $.withArrayItemAllMixin(super[key], override) }
      else { [key]: $.withArrayItemAll(super[key], override) },

  withArrayItemAllAtPathMixin(path, override)::
    $.withArrayItemAllAtPath(path, override, mixin=true, depth=0),

  withArrayItemByMatchAtPath(path, override, matcher, mixin=false, depth=0)::
    local pathArray = std.split(path, '.');
    local key = pathArray[depth];
    if depth < std.length(pathArray) - 1
    then { [key]+: $.withArrayItemByMatchAtPath(path, override, matcher, mixin, (depth + 1)) }
    else
      if mixin == true
      then { [key]: $.withArrayItemByMatchMixin(matcher, super[key], override) }
      else { [key]: $.withArrayItemByMatch(matcher, super[key], override) },

  withArrayItemByMatchAtPathMixin(path, override, matcher)::
    $.withArrayItemByMatchAtPath(path, override, matcher, mixin=true, depth=0),

  withArrayItemByIndexAtPath(path, override, arrayIndex=0, mixin=false, depth=0)::
    local pathArray = std.split(path, '.');
    local key = pathArray[depth];
    if depth < std.length(pathArray) - 1
    then { [key]+: $.withArrayItemByIndexAtPath(path, override, arrayIndex, mixin, (depth + 1)) }
    else
      if mixin == true
      then { [key]: $.withArrayItemByIndexMixin(arrayIndex, super[key], override) }
      else { [key]: $.withArrayItemByIndex(arrayIndex, super[key], override) },

  withArrayItemByIndexAtPathMixin(path, override, arrayIndex=0)::
    $.withArrayItemByIndexAtPath(path, override, arrayIndex, mixin=true, depth=0),

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
