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