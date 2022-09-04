{
  getObjectForIndex(targetIndex, arr)::
    std.prune(
      std.mapWithIndex(
        function(index, item)
          if index == targetIndex
          then item,
        arr
      )
    )[0],

  overrideArrayIndex(targetIndex, arr, override)::
    std.mapWithIndex(
      function(index, item)
        if index == targetIndex
        then override
        else item,
      arr
    ),

  overrideArrayAtPath(path, override, arrayIndex=0, depth=0)::
    local pathArray = std.split(path, '.');
    local key = pathArray[depth];
    if depth < std.length(pathArray) - 1
    then { [key]+: $.overrideArrayAtPath(path, override, arrayIndex=arrayIndex, depth=(depth + 1)) }
    else { [key]: $.overrideArrayIndex(arrayIndex, super[key], override) },

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
