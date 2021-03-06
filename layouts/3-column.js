// Generated by CoffeeScript 1.7.1

/*
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
 */
var layout;

layout = function(num) {
  var areas, column, columnWidth, columns, index, _i, _ref;
  columnWidth = 1 / 3;
  if (num === 1) {
    return [
      {
        x: 0,
        y: 0,
        width: 1,
        height: 1
      }
    ];
  } else if (num === 2) {
    return [
      {
        x: 0,
        y: 0,
        width: 0.5,
        height: 1
      }, {
        x: 0.5,
        y: 0,
        width: 0.5,
        height: 1
      }
    ];
  } else if (num === 3) {
    return [
      {
        x: 0,
        y: 0,
        width: columnWidth,
        height: 1
      }, {
        x: columnWidth,
        y: 0,
        width: columnWidth,
        height: 1
      }, {
        x: columnWidth * 2,
        y: 0,
        width: columnWidth,
        height: 1
      }
    ];
  } else {
    areas = [];
    columns = [[], [], []];
    columns[0].push(0);
    columns[1].push(1);
    columns[2].push(2);
    for (index = _i = 3, _ref = num - 1; 3 <= _ref ? _i <= _ref : _i >= _ref; index = 3 <= _ref ? ++_i : --_i) {
      if (index % 2 === 0) {
        columns[1].push(index);
      } else {
        columns[2].push(index);
      }
    }
    column = columns.forEach(function(column, columnIndex) {
      var count, eachHeight;
      count = column.length;
      eachHeight = 1 / count;
      return column.forEach(function(areaIndex, winIndex) {
        var area;
        area = {
          x: columnIndex * columnWidth,
          y: winIndex * eachHeight,
          width: columnWidth,
          height: eachHeight
        };
        return areas[areaIndex] = area;
      });
    });
    return areas;
  }
};
