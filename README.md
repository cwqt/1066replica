# g

1026, again again.

Inspired by [1066](https://armorgames.com/play/4594/1066).

## Key goals

* __Logic separated from UI__
* __No UI developed before logic & networking sorted__
* Multi-player
	- User account server
* Higher entity count (~100 units)
* More eras (e.g. Roman, WW1)
* Larger maps (up to 50x150)
* Smarter skirmish AI
* More entity actions
* Map builder
* User-defined paths (not limited to two directions in one movement)

---

## Client

`./run.sh -c`

The game itself, written in MoonScript using the [LÖVE](https://love2d.org/) framework.

## Server

`./run.sh -s`

Matchmaking server written in MoonScript using a forked version of [Affair](https://gitlab.com/cxss/Affair).

## Users-Server

`npm start`

Express.js user accounts server written in ES6 compiled by Babel using a MongoDB database -- decoupled from matchmaking server for indepedent use.

![](https://ftp.cass.si/=UDO2gjMwA.png)