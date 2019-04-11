# ui

```
ui = require("ui")
```

## Master

```
Master(bw, bh, elements)
```
* __bw__: box width
* __bh__: box height
* __bs__: box space
* __elements__: table containing containers *ONLY*.

*ui* operates on a grid system, with child containers having a box-space of 1/2 their immediate parent.

For e.g. `bw=10, bh=4, bs=100`, would result in a window of dimensions: `w=1000, h=400` since the grid is 10 boxes width of width:height 100px, and 4 boxes high of width:height 100px.

![](https://ftp.cass.si/==gMxQjMwA.png) 

## Container

```
Container(x, y, bw, bh, elements)
```

Containers go inside the Master, Containers can be embedded into other Containers for finer box-spaces.

* __x__: x position (from top-left) inside the master/container
* __y__: y position (from top-left) inside the master/container
* __elements__: table containing *Elements* or other Containers
