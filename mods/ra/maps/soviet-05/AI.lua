BaseBuildings =
{
	{ "powr", CVec.New(3, -2), 300 },
	{ "tent", CVec.New(0, 4), 400 },
	{ "hbox", CVec.New(3, 6), 600 },
	{ "proc", CVec.New(4, 2), 1400 },
	{ "powr", CVec.New(5, -3), 300 },
	{ "weap", CVec.New(-5, 3), 2000 },
	{ "hbox", CVec.New(-6, 5), 600 },
	{ "gun", CVec.New(0, 8), 600 },
	{ "gun", CVec.New(-4, 7), 600 },
	{ "powr", CVec.New(-4, -3), 300 },
	{ "proc", CVec.New(-9, 1), 1400 },
	{ "powr", CVec.New(-8, -2), 300 },
	{ "silo", CVec.New(6, 0), 150 },
	{ "agun", CVec.New(-3, 0), 800 },
	{ "powr", CVec.New(-6, -2), 300 },
	{ "agun", CVec.New(4, 1), 800 },
	{ "gun", CVec.New(-9, 5), 600 },
	{ "gun", CVec.New(-2, -3), 600 },
	{ "powr", CVec.New(4, 6), 300 },
	{ "gun", CVec.New(3, -6), 600 },
	{ "hbox", CVec.New(3, -4), 600 },
	{ "gun", CVec.New(2, 3), 600 }
}

BuildBase = function()
	if not CheckForCYard then
		return
	end

	for i = 1, #BaseBuildings, 1 do
		if not BaseBuildings[i][4] then
			BuildBuilding(i)
			return
		end
	end

	Trigger.AfterDelay(DateTime.Seconds(5), BuildBase)
	Media.DisplayMessage("Build Chain Delayed", "Debug")
end

BuildBuilding = function(number)
	local building = BaseBuildings[number]

	Media.DisplayMessage("Building " .. building[1], "Debug")

	Trigger.AfterDelay(Actor.BuildTime(building[1]), function()
		local actor = Actor.Create(building[1], true, { Owner = GoodGuy, Location = MCVDeploy.Location + building[2] })
		GoodGuy.Cash = GoodGuy.Cash - building[3]

		building[4] = true
		Trigger.OnKilled(actor, function() building[4] = false end)

		Trigger.AfterDelay(DateTime.Seconds(1), BuildBase)
	end)
end

ProduceInfantry = function()
	if Barr.IsDead then
		return
	end

	local delay = Utils.RandomInteger(DateTime.Seconds(3), DateTime.Seconds(9))
	local toBuild = { Utils.Random(AlliedInfantryTypes) }
	Greece.Build(toBuild, function(unit)
		GreeceInfAttack[#GreeceInfAttack + 1] = unit[1]

		if #GreeceInfAttack >= 7 then
			SendUnits(GreeceInfAttack, InfantryWaypoints)
			GreeceInfAttack = { }
			Trigger.AfterDelay(DateTime.Minutes(2), ProduceInfantry)
		else
			Trigger.AfterDelay(delay, ProduceInfantry)
		end
	end)
end

ProduceShips = function()
	if Shipyard.IsDead then
		return
	end

	Greece.Build( {"dd"}, function(unit)
		Ships[#Ships + 1] = unit[1]

		if #Ships >= 2 then
			SendUnits(Ships, ShipWaypoints)
			Ships = { }
			Trigger.AfterDelay(DateTime.Minutes(6), ProduceShips)
		else
			Trigger.AfterDelay(Actor.BuildTime("dd"), ProduceShips)
		end
	end)
end

ProduceInfantryGG = function()
	if not BaseBuildings[2][4] then
		return
	end

	local delay = Utils.RandomInteger(DateTime.Seconds(3), DateTime.Seconds(9))
	local toBuild = { Utils.Random(AlliedInfantryTypes) }
	GoodGuy.Build(toBuild, function(unit)
		GGInfAttack[#GGInfAttack + 1] = unit[1]

		if #GGInfAttack >= 10 then
			SendUnits(GGInfAttack, InfantryGGWaypoints)
			GGInfAttack = { }
			Trigger.AfterDelay(DateTime.Minutes(2), ProduceInfantryGG)
		else
			Trigger.AfterDelay(delay, ProduceInfantryGG)
		end
	end)
end

ProduceTanksGG = function()
	if not BaseBuildings[6][4] then
		return
	end

	local delay = Utils.RandomInteger(DateTime.Seconds(12), DateTime.Seconds(17))
	local toBuild = { Utils.Random(AlliedTankTypes) }
	GoodGuy.Build(toBuild, function(unit)
		TankAttackGG[#TankAttackGG + 1] = unit[1]

		if #TankAttackGG >= 6 then
			SendUnits(TankAttackGG, TanksGGWaypoints)
			TankAttackGG = { }
			Trigger.AfterDelay(DateTime.Minutes(3), ProduceTanksGG)
		else
			Trigger.AfterDelay(delay, ProduceTanksGG)
		end
	end)
end

SendUnits = function(units, waypoints)
	Utils.Do(units, function(unit)
		if not unit.IsDead then
			Utils.Do(waypoints, function(waypoint)
				unit.AttackMove(waypoint.Location)
			end)
			unit.Hunt()
		end
	end)
end
