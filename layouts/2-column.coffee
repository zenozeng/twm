###
2-Column Layout

@author Zeno Zeng

 -------
|       |
|   1   |
|       |
 -------

 -------
|   |   |
| 1 | 2 |
|   |   |
 -------

 -------
|   | 2 |
|   | - |
| 1 | 3 |
|   | - |
|   | 4 |
 -------

###

layout = (num) ->
  if num is 1
    [{x: 0, y: 0, width: 1, height: 1}]
  else if num is 2
    [
      {x: 0, y: 0, width: 0.5, height: 1},
      {x: 0.5, y: 0, width: 0.5, height: 1}
    ]
  else
    areas = []
    areas.push {x: 0, y: 0, width: 0.5, height: 1}
    eachHeight = 1 / (num - 1)
    for index in [2..num]
      areas.push {x: 0.5, y: (index - 2) * eachHeight, width: 0.5, height: eachHeight}
    areas

modules.layouts["2-column"] = layout
