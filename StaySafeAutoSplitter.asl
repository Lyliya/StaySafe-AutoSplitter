/*
** Stay Safe AutoSplitter
** By Lyliya & Faraziel
*/

state("StaySafe")
{
	uint lvl : "mono.dll", 0x00264110, 0x6A0, 0x10, 0x3F0, 0x340, 0xB4;
	uint load : "UnityPlayer.dll", 0x014EB5B0, 0x1B0, 0x18, 0xF8, 0x280, 0x28;
	float timer : "mono.dll", 0x00264110, 0x770, 0xC8;
}

init
{
	vars.igt = 0f;
	vars.save = true;
	vars.oigt = 0f;
	vars.accuracy = 0;
	vars.endLVL = true;
	refreshRate = 30;
}

update
{
}

startup
{
	settings.Add("world1", true, "World 1");
	settings.Add("world2", true, "World 2");
	settings.Add("world3", true, "World 3");
	for(int level = 0; level < 75; level++) {
		int world = (int)((level / 25) + 1);
		int index = (int)((level % 25) + 1);
        settings.Add("level_"+level, true, "Level " + world + "." + index, "world" + world);
	}

	vars.timerResetVars = (EventHandler)((s, e) => {
		vars.igt = 0f;
		vars.save = true;
		vars.oigt = 0f;
		vars.accuracy = 0;
		vars.endLVL = true;
	});
	timer.OnStart += vars.timerResetVars;
}

start
{
	if (current.lvl == 0 && current.load == 1) // Start World 1 (1.1)
	{
		return true;
	}
	else if (current.lvl == 25 && current.load == 1) // Start World 2 (2.1)
	{
		return true;
	}
	else if (current.lvl == 50 && current.load == 1) // Start World 3 (3.1)
	{
		return true;
	}
	else if (current.lvl == 20 && current.load == 1) // Start Secret World 1 (1.21)
	{
		return true;
	}
}

split
{
	if (current.lvl != old.lvl) {
		return settings["level_"+old.lvl];
	}
}

reset
{
}

isLoading
{
	if (current.load == 0) {
		return true;
	}
	else {
		vars.save = false;
		vars.accuracy = 0;
		return false;
	}
}

gameTime {
	if (current.timer > old.timer) {
		vars.endLVL = false;
		vars.igt += (current.timer - old.timer);
	}
	else if (current.timer == old.timer && current.load == 0 && vars.save == false) {
		vars.accuracy += 1;
		if (vars.accuracy == 5) {
			vars.oigt += current.timer;
			vars.save = true;
			vars.endLVL = true;
			if (vars.igt != vars.oigt) {
				vars.igt = vars.oigt;
			}
		}
	}
	else if (current.timer < old.timer && current.load == 1 && current.load == old.load) {
		if (vars.endLVL == false) {
			vars.oigt += old.timer;
			if (vars.igt != vars.oigt) {
				vars.igt = vars.oigt;
			}
		}
	}

	return TimeSpan.FromSeconds(vars.igt);
}

shutdown {
    timer.OnStart -= vars.timerResetVars;
}
