BuildBase = function()
	local clock = Map.ActorsInCircle(Map.CenterOfCell(MCVDeploy.Location), WRange.New(512))[1]

	if not CheckForCYard then
		return

	--Build a Power Plant
	elseif not b1 then
	clock.Wait(Actor.BuildTime("powr"))
	clock.CallFunc(function() powr1 = Actor.Create("powr", true, { Owner = GoodGuy, Location = MCVDeploy.Location + CVec.New(3,-2) }) b1 = true GoodGuy.Cash = GoodGuy.Cash - 300 Trigger.OnKilledOrCaptured(powr1, function() b1 = false end) end)
	Trigger.AfterDelay(Actor.BuildTime("powr") + 25, BuildBase)

	--Build a Barracks then Pillbox
	elseif b1 and not b2 then
	clock.Wait(Actor.BuildTime("tent"))
	clock.CallFunc(function() tent = Actor.Create("tent", true, { Owner = GoodGuy, Location = MCVDeploy.Location + CVec.New(0,4) }) b2 = true GoodGuy.Cash = GoodGuy.Cash - 400 Trigger.OnKilledOrCaptured(tent, function() b2 = false end) end)
	Trigger.AfterDelay(Actor.BuildTime("tent") + 25, BuildBase)

	elseif b1 and b2 and not b3 then
	clock.Wait(Actor.BuildTime("hbox"))
	clock.CallFunc(function() hbox1 = Actor.Create("hbox", true, { Owner = GoodGuy, Location = MCVDeploy.Location + CVec.New(3,6) }) b3 = true GoodGuy.Cash = GoodGuy.Cash - 600 Trigger.OnKilledOrCaptured(hbox1, function() b3 = false end) end)
	Trigger.AfterDelay(Actor.BuildTime("hbox") + 25, BuildBase)

	-- Build a Refinery
	elseif b1 and b2 and not b4 then
	clock.Wait(Actor.BuildTime("proc"))
	clock.CallFunc(function() proc1 = Actor.Create("proc", true, { Owner = GoodGuy, Location = MCVDeploy.Location + CVec.New(4,2) }) b4 = true GoodGuy.Cash = GoodGuy.Cash - 1400 Trigger.OnKilledOrCaptured(proc1, function() b4 = false end) end)
	Trigger.AfterDelay(Actor.BuildTime("proc") + 25, BuildBase)

	-- Build another Power Plant
	elseif b1 and b2 and b3 and b4 and not b5 then
	clock.Wait(Actor.BuildTime("powr"))
	clock.CallFunc(function() powr2 = Actor.Create("powr", true, { Owner = GoodGuy, Location = MCVDeploy.Location + CVec.New(5,-3) }) b5 = true GoodGuy.Cash = GoodGuy.Cash - 300 Trigger.OnKilledOrCaptured(powr2, function() b5 = false end) end)
	Trigger.AfterDelay(Actor.BuildTime("powr") + 25, BuildBase)

	-- Build a War Factory
	elseif b2 and b4 and b5 and not b6 then
	clock.Wait(Actor.BuildTime("weap"))
	clock.CallFunc(function() weap1 = Actor.Create("weap", true, { Owner = GoodGuy, Location = MCVDeploy.Location + CVec.New(-5,3) }) b6 = true GoodGuy.Cash = GoodGuy.Cash - 2000 Trigger.OnKilledOrCaptured(weap1, function() b6 = false end) end)
	Trigger.AfterDelay(Actor.BuildTime("weap") + 25, BuildBase)

	-- Some defences
	elseif b1 and b2 and b6 and not b7 then
	clock.Wait(Actor.BuildTime("hbox"))
	clock.CallFunc(function() hbox2 = Actor.Create("hbox", true, { Owner = GoodGuy, Location = MCVDeploy.Location + CVec.New(-6,5) }) b7 = true GoodGuy.Cash = GoodGuy.Cash - 600 Trigger.OnKilledOrCaptured(hbox2, function() b7 = false end) end)
	Trigger.AfterDelay(Actor.BuildTime("hbox") + 25, BuildBase)

	elseif b1 and b2 and b7 and not b8 then
	clock.Wait(Actor.BuildTime("gun"))
	clock.CallFunc(function() gun1 = Actor.Create("gun", true, { Owner = GoodGuy, Location = MCVDeploy.Location + CVec.New(0,8) }) b8 = true GoodGuy.Cash = GoodGuy.Cash - 600 Trigger.OnKilledOrCaptured(gun1, function() b8 = false end) end)
	Trigger.AfterDelay(Actor.BuildTime("gun") + 25, BuildBase)

	elseif b1 and b2 and b8 and not b9 then
	clock.Wait(Actor.BuildTime("gun"))
	clock.CallFunc(function() gun2 = Actor.Create("gun", true, { Owner = GoodGuy, Location = MCVDeploy.Location + CVec.New(-4,7) }) b9 = true GoodGuy.Cash = GoodGuy.Cash - 600 Trigger.OnKilledOrCaptured(gun2, function() b9 = false end) end)
	Trigger.AfterDelay(Actor.BuildTime("gun") + 25, BuildBase)

	-- Build another Power Plant
	elseif b1 and b5 and b6 and b4 and b9 and not b10 then
	clock.Wait(Actor.BuildTime("powr"))
	clock.CallFunc(function() powr3 = Actor.Create("powr", true, { Owner = GoodGuy, Location = MCVDeploy.Location + CVec.New(-4,-3) }) b10 = true GoodGuy.Cash = GoodGuy.Cash - 300 Trigger.OnKilledOrCaptured(powr3, function() b10 = false end) end)
	Trigger.AfterDelay(Actor.BuildTime("powr") + 25, BuildBase)

	-- Build another Refinery
	elseif b4 and b6 and b5 and b1 and b10 and not b11 then
	clock.Wait(Actor.BuildTime("proc"))
	clock.CallFunc(function() proc2 = Actor.Create("proc", true, { Owner = GoodGuy, Location = MCVDeploy.Location + CVec.New(-9,1) }) b11 = true GoodGuy.Cash = GoodGuy.Cash - 1400 Trigger.OnKilledOrCaptured(proc2, function() b11 = false end) end)
	Trigger.AfterDelay(Actor.BuildTime("proc") + 25, BuildBase)

	-- Build another Power Plant and a silo
	elseif b1 and b5 and b6 and b4 and b11 and not b12 then
	clock.Wait(Actor.BuildTime("powr"))
	clock.CallFunc(function() powr4 = Actor.Create("powr", true, { Owner = GoodGuy, Location = MCVDeploy.Location + CVec.New(-8,-2) }) b12 = true GoodGuy.Cash = GoodGuy.Cash - 300 Trigger.OnKilledOrCaptured(powr4, function() b12 = false end) end)
	Trigger.AfterDelay(Actor.BuildTime("powr") + 25, BuildBase)

	elseif b1 and b5 and b11 and b4 and b12 and not b13 then
	clock.Wait(Actor.BuildTime("silo"))
	clock.CallFunc(function() silo = Actor.Create("silo", true, { Owner = GoodGuy, Location = MCVDeploy.Location + CVec.New(6,0) }) b13 = true GoodGuy.Cash = GoodGuy.Cash - 150 Trigger.OnKilledOrCaptured(silo, function() b13 = false end) end)
	Trigger.AfterDelay(Actor.BuildTime("silo") + 25, BuildBase)

	-- Some defences
	elseif b1 and b2 and b13 and not b14 then
	clock.Wait(Actor.BuildTime("agun"))
	clock.CallFunc(function() aa1 = Actor.Create("agun", true, { Owner = GoodGuy, Location = MCVDeploy.Location + CVec.New(-3,0) }) b14 = true GoodGuy.Cash = GoodGuy.Cash - 800 Trigger.OnKilledOrCaptured(aa1, function() b14 = false end) end)
	Trigger.AfterDelay(Actor.BuildTime("agun") + 25, BuildBase)

	-- Build another Power Plant
	elseif b1 and b5 and b6 and b4 and b10 and b14 and not b15 then
	clock.Wait(Actor.BuildTime("powr"))
	clock.CallFunc(function() powr5 = Actor.Create("powr", true, { Owner = GoodGuy, Location = MCVDeploy.Location + CVec.New(-6,-2) }) b15 = true GoodGuy.Cash = GoodGuy.Cash - 300 Trigger.OnKilledOrCaptured(powr5, function() b15 = false end) end)
	Trigger.AfterDelay(Actor.BuildTime("powr") + 25, BuildBase)

	-- Some defences
	elseif b1 and b2 and b15 and not b16 then
	clock.Wait(Actor.BuildTime("agun"))
	clock.CallFunc(function() aa2 = Actor.Create("agun", true, { Owner = GoodGuy, Location = MCVDeploy.Location + CVec.New(4,1) }) b16 = true GoodGuy.Cash = GoodGuy.Cash - 800 Trigger.OnKilledOrCaptured(aa2, function() b16 = false end) end)
	Trigger.AfterDelay(Actor.BuildTime("agun") + 25, BuildBase)

	elseif b1 and b2 and b16 and not b17 then
	clock.Wait(Actor.BuildTime("gun"))
	clock.CallFunc(function() gun3 = Actor.Create("gun", true, { Owner = GoodGuy, Location = MCVDeploy.Location + CVec.New(-9,5) }) b17 = true GoodGuy.Cash = GoodGuy.Cash - 600 Trigger.OnKilledOrCaptured(gun3, function() b17 = false end) end)
	Trigger.AfterDelay(Actor.BuildTime("gun") + 25, BuildBase)

	elseif b1 and b2 and b17 and not b18 then
	clock.Wait(Actor.BuildTime("gun"))
	clock.CallFunc(function() gun4 = Actor.Create("gun", true, { Owner = GoodGuy, Location = MCVDeploy.Location + CVec.New(-2,-3) }) b18 = true GoodGuy.Cash = GoodGuy.Cash - 600 Trigger.OnKilledOrCaptured(gun4, function() b18 = false end) end)
	Trigger.AfterDelay(Actor.BuildTime("gun") + 25, BuildBase)

	-- Build another Power Plant
	elseif b1 and b5 and b6 and b4 and b10 and b14 and b18 and not b22 then
	clock.Wait(Actor.BuildTime("powr"))
	clock.CallFunc(function() powr6 = Actor.Create("powr", true, { Owner = GoodGuy, Location = MCVDeploy.Location + CVec.New(4,-6) }) b22 = true GoodGuy.Cash = GoodGuy.Cash - 300 Trigger.OnKilledOrCaptured(powr6, function() b22 = false end) end)
	Trigger.AfterDelay(Actor.BuildTime("powr") + 25, BuildBase)

	elseif b1 and b2 and b18 and b22 and not b19 then
	clock.Wait(Actor.BuildTime("gun"))
	clock.CallFunc(function() gun5 = Actor.Create("gun", true, { Owner = GoodGuy, Location = MCVDeploy.Location + CVec.New(3,-6) }) b19 = true GoodGuy.Cash = GoodGuy.Cash - 600 Trigger.OnKilledOrCaptured(gun5, function() b19 = false end)  end)
	Trigger.AfterDelay(Actor.BuildTime("gun") + 25, BuildBase)

	elseif b1 and b2 and b19 and not b20 then
	clock.Wait(Actor.BuildTime("hbox"))
	clock.CallFunc(function() hbox3 = Actor.Create("hbox", true, { Owner = GoodGuy, Location = MCVDeploy.Location + CVec.New(3,-4) }) b20 = true GoodGuy.Cash = GoodGuy.Cash - 600 Trigger.OnKilledOrCaptured(hbox3, function() b20 = false end) end)
	Trigger.AfterDelay(Actor.BuildTime("hbox") + 25, BuildBase)

	elseif b1 and b2 and b20 and not b21 then
	clock.Wait(Actor.BuildTime("gun"))
	clock.CallFunc(function() gun6 = Actor.Create("gun", true, { Owner = GoodGuy, Location = MCVDeploy.Location + CVec.New(2,3) }) b20 = true GoodGuy.Cash = GoodGuy.Cash - 600 Trigger.OnKilledOrCaptured(gun6, function() b20 = false end)  end)
	Trigger.AfterDelay(Actor.BuildTime("gun") + 25, BuildBase)

	else
		Trigger.AfterDelay(DateTime.Seconds(5), BuildBase)
	end
	-- Media.DisplayMessage("Debug: Build Chain Triggered")
end

ProduceInfantry = function()
	if Barr.IsDead then
		return
	end

	if StopInfantry then
		Trigger.AfterDelay(DateTime.Minutes(2), ProduceInfantry)
		StopInfantry = false
		GreeceInfAttack = { }
		return
	end

	local delay = Utils.RandomInteger(DateTime.Seconds(3), DateTime.Seconds(9))
	local toBuild = { Utils.Random(AlliedInfantryTypes) }
	Greece.Build(toBuild, function(unit)
		GreeceInfAttack[#GreeceInfAttack + 1] = unit[1]
		Trigger.AfterDelay(delay, ProduceInfantry)

		if #GreeceInfAttack >= 7 then
			SendInfantry()
			StopInfantry = true
		end
	end)
end

ProduceShips = function()
	if Shipyard.IsDead then
		return
	end

	if StopShips then
		Trigger.AfterDelay(DateTime.Minutes(6), ProduceShips)
		StopShips = false
		Ships = { }
		return
	end

	Greece.Build( {"dd"}, function(unit)
		Ships[#Ships + 1] = unit[1]
		Trigger.AfterDelay(Actor.BuildTime("dd"), ProduceShips)

		if #Ships >= 2 then
			SendShips()
			StopShips = true
		end
	end)
end

SendShips = function()
	Utils.Do(Ships, function(ship)
		if not ship.IsDead then
			ship.AttackMove(waypoint77.Location)
			ship.AttackMove(waypoint14.Location)
			ship.AttackMove(waypoint51.Location)
			IdleHunt(ship)
		end
	end)
end

SendInfantry = function()
	Utils.Do(GreeceInfAttack, function(inf)
		if not inf.IsDead then
			inf.AttackMove(waypoint2.Location)
			inf.AttackMove(waypoint48.Location)
			inf.AttackMove(waypoint49.Location)
			inf.AttackMove(waypoint1.Location)
			IdleHunt(inf)
		end
	end)
end

ProduceInfantryGG = function()
	if not b2 then
		return
	end

	if StopInfantryGG then
		Trigger.AfterDelay(DateTime.Minutes(2), ProduceInfantryGG)
		StopInfantryGG = false
		GGInfAttack = { }
		return
	end

	local delay = Utils.RandomInteger(DateTime.Seconds(3), DateTime.Seconds(9))
	local toBuild = { Utils.Random(AlliedInfantryTypes) }
	GoodGuy.Build(toBuild, function(unit)
		GGInfAttack[#GGInfAttack + 1] = unit[1]
		Trigger.AfterDelay(delay, ProduceInfantryGG)

		if #GGInfAttack >= 10 then
			SendInfantryGG()
			StopInfantryGG = true
		end
	end)
end

SendInfantryGG = function()
	Utils.Do(GGInfAttack, function(inf)
		if not inf.IsDead then
			inf.AttackMove(waypoint29.Location)
			inf.AttackMove(waypoint30.Location)
			inf.AttackMove(waypoint40.Location)
			IdleHunt(inf)
		end
	end)
end

ProduceTanksGG = function()
	if not b6 then
		return
	end

	if StopTanksGG then
		Trigger.AfterDelay(DateTime.Minutes(3), ProduceTanksGG)
		StopTanksGG = false
		TankAttackGG = { }
		return
	end

	local delay = Utils.RandomInteger(DateTime.Seconds(12), DateTime.Seconds(17))
	local toBuild = { Utils.Random(AlliedTankTypes) }
	GoodGuy.Build(toBuild, function(unit)
		TankAttackGG[#TankAttackGG + 1] = unit[1]
		Trigger.AfterDelay(delay, ProduceTanksGG)

		if #TankAttackGG >= 6 then
			SendTanksGG()
			StopTanksGG = true
		end
	end)
end

SendTanksGG = function()
	Utils.Do(TankAttackGG, function(tnk)
		if not tnk.IsDead then
			tnk.AttackMove(waypoint29.Location)
			tnk.AttackMove(waypoint30.Location)
			tnk.AttackMove(waypoint40.Location)
			IdleHunt(tnk)
		end
	end)
end
