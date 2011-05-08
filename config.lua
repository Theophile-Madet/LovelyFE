--config.lua

pathToMame="MAME"

romsNotToInclude = { --can be used for bios for example
"neogeo",
"nemesis",
"cpzn2",
"trackfld",
"tdragon2",
"dynablst",
"ddp3",
"decocass",
"stvbios",
"dlair",
"gauntlet",
"vulcan",
"kinst2",
"marble",
"naomigd",
"puckman",
"rampart",
"tgm2",
"tmnt",
"konamigx",
"atarisy1",
"crusnexo"}

function group(L)
    local function f(groupName, gameList)
        print(" Creating group " .. groupName)
        local tableEntry = {}
        tableEntry["xarg"] = {}
        tableEntry["xarg"]["name"] = groupName
        tableEntry["label"] = "group"
        
        local groupList = {}
        for _, gameName in pairs(gameList) do
            print("     Adding " .. gameName .. " to group")
            groupList[#groupList+1] = deepcopy(getGameByName(L, gameName))
        end
        tableEntry[1] = groupList
        
        L[#L+1] = tableEntry
        removeRoms(L, gameList)
    end
    
    f("Metal Slug", {"mslug", "mslug2", "mslugx", "mslug3", "mslug4", "mslug5"})
    f("19XX", {"1941", "1942", "1943", "1944", "19xx"})
    f("Gradius", {"Gradius", "Gradius 2", "Gradius 3", "Gradius 4"})
    f("Mortal Kombat", {"mk", "mk2", "mk3", "mk4"})
    f("Puzzle Bobble", {"pbobble", "pbobble2", "pbobble3", "pbobble4"})
    f("R-Type", {"rtype", "rtype2", "rtypeleo"})
    f("Samurai Shodown", {"samsho", "samsho2", "samsho3", "samsho4", "samsho5"})
    f("Street Fighter", {"sf", "sf2", "sfiii3n", "ssf2t"})
    f("Strikers 1945", {"s1945", "s1945ii", "s1945iii", "s1945p"})
    f("Tapper", {"tapper", "rbtapper", "sutapper"})
    f("King of Fighter", {"kof94", "kof95", "kof96", "kof97", "kof99", "kof2000", "kof2001", "kof2002"})
end

function removeRoms (xmlTable, romsToRemove)
	for k, rom in pairs(xmlTable) do
		romName = getName(rom)
		for _, v in pairs(romsToRemove) do
			if romName == v then
				xmlTable[k] = nil
				print("    Removing " .. romName)
			end
		end
	end
end

function custom(L) --used to customize game names
	local function f(name, description)
		print("	Changing " .. name .. " description to " .. description)
		local game = getGameByName(L, name)
		if game ~= nil then
			setTagValue(game, "description", description)
		end
	end
	f("1941", "1941 : Counter Attack")
	f("1942", "1942")
	f("1943", "1943 : The Battle of Midway")
	f("1944", "1944 : The Loop Master")
	f("19xx", "19XX : The War Against Destiny")
	f("sonicwi3", "Aero Fighters 3")
	f("altbeast", "Altered Beast")
	f("arabianm", "Arabian Magic")
	f("arkanoid", "Arkanoid")
	f("arknoid2", "Arkanoid 2 - Revenge of DOH")
	f("asterix", "Asterix")
	f("asteroid", "Asteroids")
	f("baddudes", "Bad Dudes vs. Dragonninja")
	f("batsugunsp", "Batsugun (version speciale)")
	f("bkraidu", "Battle Bakraid (unlimited version)")
	f("bgaregga", "Battle Garegga")
	f("bzone", "Battle Zone")
	f("bmfinal", "Beatmania - The Final")
	f("bigbang", "Big Bang")
	f("bigrun", "Big Run")
	f("blazer", "Blazer")
	f("blockcar", "Block Carnival")
	f("blockout", "Block Out")
	f("bloodbro", "Blood Bros")
	f("bombjack", "Bomb Jack")
	f("bombrman", "Bomber Man")
	f("bnzabros", "Bonanza Bros")
	f("bottom9", "Bottom of the Ninth")
	f("cbdash", "Boulder Dash")
	f("bouldash", "Boulder Dash - Part 2")
	f("boxyboy", "Boxy Boy")
	f("cabal", "Cabal")
	f("dino", "Cadillacs and Dinosaurs")
	f("cameltry", "Cameltry")
	f("captaven", "Captain America and The Avengers")
	f("cninja", "Caveman Ninja")
	f("csprint", "Championship Sprint")
	f("circus", "Circus")
	f("combatsc", "Combat School")
	f("commando", "Commando")
	f("defender", "Defender")
	f("diehard", "Die Hard Arcade")
	f("ddonpach", "Dodonpachi")
	f("dkong", "Donkey Kong")
	f("donpachi", "Donpachi")
	f("ddragon", "Double Dragon")
	f("ddragon2", "Double Dragon II")
	f("eggventr", "Egg Venture")
	f("esprade", "ESP Ra.De.")
	f("espgal", "ESP Galuda")
	f("fatfury1", "Fatal Fury")
	f("ffight", "Final Fight")
	f("galaga", "Galaga")
	f("galaxian", "Galaxian")
	f("galpans2", "Gals Panic S2")
	f("galpansu", "Gals Panic SU")
	f("gauntlet2p", "Gauntlet (2 joueurs)")
	f("gigawing", "Giga Wing")
	f("goldnaxe", "Golden Axe")
	f("gradius2", "Gradius II")
	f("gradius3", "Gradius III")
	f("gunbird", "Gunbird")
	f("guwange", "Guwange")
	f("hook", "Hook")
	f("inthunt", "In The Hunt")
	f("jack", "Jack The Giantkiller")
	f("joust", "Joust")
	f("junglek", "Jungle King")
	f("ket", "Ketsui")
	f("kinst", "Killer Instinct")
	f("klax", "Klax")
	f("knights", "Knights of the Round")
    f("kof94", "King of Fighter '94")
    f("kof95", "King of Fighter '95")
    f("kof96", "King of Fighter '96")
    f("kof97", "King of Fighter '97")
    f("kof98", "King of Fighter '98")
    f("kof99", "King of Fighter '99")
    f("kof2000", "King of Fighter 2000")
    f("kof2002", "King of Fighter 2002")
	f("liquidk", "Liquid Kids")
	f("ldrun", "Lode Runner")
	f("llander", "Lunar Lander")
	f("mshvsf", "Marvel Super Heroes Vs. Street Fighter")
	f("mvsc", "Marvel Vs. Capcom : Clash of Super Heroes")
	f("mtwins", "Mega Twins")
	f("metalb", "Metal Black")
	f("mslug2", "Metal Slug 2")
	f("mslug4", "Metal Slug 4")
	f("missile", "Missile Command")
	f("mk", "Mortal Kombat")
	f("mk3", "Mortal Kombat 3")
	f("mk4", "Mortal Kombat 4")
	f("mk2", "Mortal Kombat 2")
	f("pow", "Prisoners of War")
	f("pacman", "Pac-Man")
	f("sxyreact", "Pachinko Sexy Reaction")
	f("sxyreac2", "Pachinko Sexy Reaction 2")
	f("pang", "Pang")
	f("paperboy", "Paperboy")
	f("parodius", "Parodius DA!")
	f("pigskin", "Pigskin 621AD")
	f("pipedrm", "Pipe Dream")
	f("popeye", "Popeye")
	f("progear", "Progear")
	f("puyo", "Puyo Puyo")
	f("puyopuy2", "Puyo Puyo 2")
	f("pbobble", "Puzzle Bobble")
	f("pbobble2", "Puzzle Bobble 2")
	f("pbobble3", "Puzzle Bobble 3")
	f("pbobble4", "Puzzle Bobble 4")
	f("qbert", "Q*bert")
	f("rtype", "R-Type")
	f("rtypeleo", "R-Type Leo")
	f("rsgun", "Radient Silvergun")
	f("raiden2", "Raiden II")
	f("rainbow", "Rainbow Islands")
	f("rampage", "Rampage")
	f("rampart2p", "Rampart")
	f("ridgerac", "Ridge Racer")
	f("ridgera2", "Ridge Racer 2")
	f("roadrunn", "Road Runner")
	f("robocop", "Robocop")
	f("rthunder", "Rolling Thunder")
	f("safari", "Safari")
	f("samsho", "Samurai Shodown")
	f("samsho2", "Samurai Shodown II")
	f("samsho3", "Samurai Shodown III")
	f("samsho4", "Samurai Shodown IV")
	f("samsho5", "Samurai Shodown V")
	f("sexyparo", "Sexy Parodius")
	f("shinobi", "Shinobi")
	f("silkworm", "Silk Worm")
	f("slyspy", "Sly Spy")
	f("sonicwi", "Sonic Winds")
	f("invaders", "Space Invaders")
	f("starcas", "Star Castle")
	f("sf", "Street Fighter")
	f("sf2", "Street Fighter II : The World Warrior")
	f("sfiii3n", "Street Fighter III 3rd Strike: Fight for the Future")
	f("strhoop", "Street Hoop")
	f("s1945", "Strikers 1945")
	f("s1945iii", "Strickers 1945 III")
	f("sbrkout", "Super Breakout")
	f("shangon", "Super Hang-On")
	f("ssf2t", "Super Street Fighter II Turbo")
	f("ssozumo", "Syusse OOsumo")
	f("tapper", "Tapper (Budweiser)")
	f("tmnt2pj", "Teenage Mutant Ninja Turtles (2 joueurs)")
	f("tmnt2", "Teenage Mutant Ninja Turtles - Turtles in Time")
	f("tempest", "Tempest")
	f("tetris", "Tetris")
	f("tgm2p", "Tetris : The Grand Master 2 Plus")
	f("tgmj", "Tetris : The Grand Master")
	f("gametngk", "The Game Paradise")
	f("kof2001", "The King of Fighters 2001")
	f("punisher", "The Punisher")
    f("toobin", "Toobin'")
    f("tophuntr", "Top Hunter")
	f("trog", "Trog")
	f("tron", "Tron")
	f("truxton", "Truxton")
	f("truxton2", "Truxton II")
	f("xmcota", "X-Men : Children of the Atom")
end

