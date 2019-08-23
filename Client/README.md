```moonscript
xxx = {}
xxx.init = () =>
	self.__name__ = "xxx"
	log.state("Initialised xxx")

xxx.enter  = (previous)   =>
	log.state("Entered xxx")

--LOGIC============================================================
xxx.update = (dt) =>
xxx.draw   = ()   =>

--INPUT============================================================
xxx.mousemoved = (x, y, dx, dy) =>
xxx.mousereleased = (x, y, button) =>
xxx.mousepressed = (x, y, button) =>
xxx.keypressed = (key) =>
xxx.textinput = (t) =>

--POP  ============================================================
xxx.resume = () =>
	log.state("Resumed xxx")

xxx.leave = () =>
	log.state("Left xxx")

xxx.quit = () =>
	log.state("Quit xxx")

return xxx
```


```moonscript
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
