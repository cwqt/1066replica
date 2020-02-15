# g

1026, again again.

Inspired by [1066](https://armorgames.com/play/4594/1066).

## Key goals

* Multi-player (P2P/relay)
	- User account server (micro-service architecture)
* Higher entity count (~100 units)
* More eras
* Larger maps (up to 50x150)
* Better skirmish AI
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

### api

`npm start`

Express.js user accounts server written in ES6 compiled by Babel using a MongoDB database -- decoupled from matchmaking server for indepedent use. <https://ftp.cass.si/=UDO2gjMwA.png>

`.env`

* __MONGO_URI__: `mongodb+srv://...`, MongoDB server URL
* __PRIVATE_KEY__: `"string"`, Authentication key

### fe

For purposes of learning Angular