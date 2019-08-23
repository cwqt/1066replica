# g

1026, again again.

Inspired by [1066](https://armorgames.com/play/4594/1066).

## Key goals

* __Logic separated from UI__
* __No UI developed before logic & networking sorted__
* Multi-player
* Higher entity count (~100 units)
* More eras (e.g. Roman, WW1)
* Larger maps (up to 50x150)
* Smarter skirmish AI
* More entity actions
* Map builder
* User-defined paths (not limited to two directions in one movement)

### Server
 
`luarocks install luasocket`
 
```lua
{
	type: SET_INITIAL_UNITS
	payload: {
		{
			type: "CREATE_OBJECT",
			payload: {
				type: "ENTITY",
				payload: { hp: 300 }
			}
		},
		{
			type: "CREATE_OBJECT",
			payload: {
				type: "MAP_OBJECT",
				payload: {}
			}
		}
	}
}
```


### bugs

* love.mousereleased not resolved after mousepress after state change until clicked again

>It's the one thing I hate about hump.gamestate. After switching, no events are forwarded until the next update[source]. You can patch it out, or delay switching. If you do patch it out, you will run into situations where draw will run before update, but if your state is well-designed, that shouldn't be a problem.

https://love2d.org/forums/viewtopic.php?t=82909
https://github.com/vrld/hump/issues/46