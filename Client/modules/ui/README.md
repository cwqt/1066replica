# ui

```moon
    UI = require("ui")
    
	export ui = UI.Master(8, 5, 160, {
		UI.Container(2,1,6,4, {
			with UI.Text("alias", 1,2,12,2)
				.text.font = GAME.fonts.title[216]
				.text.alignh = "center"
				.text.alignv = "center"
				.p = {10,10,10,10}
				.m = {10,10,10,10}
			with UI.TextInput("localhost", 4,5,4,1, "ip")
				.text.font = GAME.fonts.default[27]
				.text.alignv = "center"
			UI.Button("Connect", 8,5,2,1, "connect")
			UI.Button("Relay", 8,6,2,1, "relay")
			UI.Button("Msg sv", 8,7,2,1, "sv")
		})
	})

	UI.id["connect"].onClick = ->
		z = NM.startClient(UI.id["ip"].value)

	UI.id["relay"].onClick = ->
		NM.sendDataToPeer("ACK #{love.timer.getTime()}")

	UI.id["sv"].onClick = ->
		NM.sendDataToServer("Hello Server.")
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
Extends Master

```
Container(x, y, bw, bh, elements)
```

Containers go inside the Master, Containers can be embedded into other Containers for finer box-spaces.

* __x__: x position (from top-left) inside the master/container
* __y__: y position (from top-left) inside the master/container
* __elements__: table containing *Elements* or other Containers

![](https://ftp.cass.si/=ITN2ADMwA.png)

## Element

```
Element(x, y, bw, bh, id)
```

* __x__: <int> x position inside the container
* __y__: <int> y position inside the container
* __id__: <string> custom id used to access elements functions (i.e. what to do when clicked)

* __getMarginDimensions__: returns tuple of width, height of margin area
* __getPaddedDimensions__: returns tuple of width, heigh of padded area
* __onClick__: function to be executed when object is clicked
* __destroy__: destroys the object and its timer

### id's

Since elements are created in a table, they have no variable in which to be accessed. ID's are used in *ui* to access elements values and perform actions.

e.g.

```moon
    UI = require("ui")
	export ui = UI.Master(10, 4, 100, {
		UI.Container(2,2,3,2, {
		    UI.Text("My value", 1,1,2,1, "my_id")
		    UI.Button(1,2,2,2, "clicker")
		})
	})
	
	UI.id["clicker"].onClick = -> print UI.id["my_id"].value --> prints "My value"
```