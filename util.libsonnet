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

  overrideArrayAtIndex(targetIndex, arr, override)::
    std.mapWithIndex(
      function(index, item)
        if index == targetIndex
        then override
        else item,
      arr
    ),

  mixinArrayAtIndex(targetIndex, arr, override)::
    std.mapWithIndex(
      function(index, item)
        if index == targetIndex
        then item + override
        else item,
      arr
    ),

  overrideArrayAtPath(path, override, arrayIndex=0, mixin=false, depth=0)::
    local pathArray = std.split(path, '.');
    local key = pathArray[depth];
    if depth < std.length(pathArray) - 1
    then { [key]+: $.overrideArrayAtPath(path, override, arrayIndex, mixin, (depth + 1)) }
    else
      if mixin == true
      then { [key]: $.mixinArrayAtIndex(arrayIndex, super[key], override) }
      else { [key]: $.overrideArrayAtIndex(arrayIndex, super[key], override) },

  mixinArrayAtPath(path, override, arrayIndex=0)::
    $.overrideArrayAtPath(path, override, arrayIndex, mixin=true, depth=0),

  overridePath(path, override, mixin=false, depth=0)::
    local pathArray = std.split(path, '.');
    local key = pathArray[depth];
    if depth < std.length(pathArray) - 1
    then { [key]+: $.overridePath(path, override, mixin=mixin, depth=(depth + 1)) }
    else
      if mixin == true
      then { [key]+: override }
      else { [key]: override },

  mixinPath(path, override)::
    $.overridePath(path, override, mixin=true, depth=0),

}
