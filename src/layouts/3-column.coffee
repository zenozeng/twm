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
  columnWidth = 1/3

  if num is 1
    [{x: 0, y: 0, width: 1, height: 1}]
  else if num is 2
    [
      {x: 0, y: 0, width: 0.5, height: 1},
      {x: 0.5, y: 0, width: 0.5, height: 1}
    ]
  else if num is 3
    [
      {x: 0, y: 0, width: columnWidth, height: 1},
      {x: columnWidth, y: 0, width: columnWidth, height: 1},
      {x: columnWidth * 2, y: 0, width: columnWidth, height: 1},
    ]
  else
    areas = []

    columns = [ [], [], [] ]

    columns[0].push 0
    columns[1].push 1
    columns[2].push 2

    for index in [3..(num-1)]
      if index % 2 is 0
        columns[1].push index
      else
        columns[2].push index

    column = columns.forEach (column, columnIndex) ->
      count = column.length
      eachHeight = 1 / count
      column.forEach (areaIndex, winIndex) ->
        area =
          x: columnIndex * columnWidth
          y: winIndex * eachHeight
          width: columnWidth
          height: eachHeight
        areas[areaIndex] = area

    areas
