/*
** Stay Safe AutoSplitter
** By Lyliya
*/

state("StaySafe")
{
	uint lvl : "mono.dll", 0x00264110, 0x6A0, 0x10, 0x3F0, 0x340, 0xB4;
	uint load : "UnityPlayer.dll", 0x014EB5B0, 0x1B0, 0x18, 0xF8, 0x280, 0x28;
}

init
{
}

update
{
}

startup
{
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
		return true;
	}
}

reset
{
}

isLoading
{
	if (current.load == 0)
		return true;
	else
		return false;
}
