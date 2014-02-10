###
3-Column Layout

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

 -----------
|   |   |   |
| 1 | 2 | 3 |
|   |   |   |
 -----------

 -----------
|   |   | 3 |
| 1 | 2 |---|
|   |   | 4 |
 -----------

 -----------
|   | 2 | 3 |
| 1 |---|---|
|   | 5 | 4 |
 -----------

 -----------
|   | 2 | 3 |
|   |   | - |
| 1 | - | 4 |
|   | 5 | - |
|   |   | 6 |
 -----------

-----------
|   | 2 | 3 |
|   | - | - |
| 1 | 5 | 4 |
|   | - | - |
|   | 7 | 6 |
 -----------


###

layout = (num) ->
  if num is 1
    [{x: 0, y: 0, width: 1, height: 1}]
  else if num is 2
    [
      {x: 0, y: 0, width: 0.5, height: 1},
      {x: 0.5, y: 0, width: 0.5, height: 1}
    ]
  else if num is 3
    [
      {x: 0, y: 0, width: 0.3333, height: 1},
      {x: 0.3333, y: 0, width: 0.3333, height: 1},
      {x: 0.6666, y: 0, width: 0.3333, height: 1},
    ]
  else
    areas = []
    areas.push {x: 0, y: 0, width: 0.3333, height: 1}

    # TO BE CONTINUED

    # eachHeight = 1 / (num - 1)
    # for index in [2..num]
    #   areas.push {x: 0.5, y: (index - 2) * eachHeight, width: 0.5, height: eachHeight}
    # areas
