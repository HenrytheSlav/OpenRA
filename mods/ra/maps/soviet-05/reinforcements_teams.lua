sov1 = {"e2", "e2"}
sov1Path = { waypoint0.Location, waypoint1.Location }

arty1reinf = { "e3", "e3", "e3", "arty", "arty" }
if Map.Difficulty == "Easy" then
	gguy2 = { "jeep", "1tnk", "1tnk" }
else
	gguy2 = {"jeep", "jeep", "1tnk", "1tnk", "1tnk" }
end
gguy1 = { "e1", "e1", "e1", "e1", "e1" }
gguyPath = { waypoint69.Location, waypoint53.Location, waypoint49.Location }

AlliedInfantryTypes = { "e1", "e3" }
AlliedTankTypes = { "jeep", "1tnk" }
AlliedAttackPath = {waypoint3.Location, waypoint2.Location, waypoint48.Location, waypoint49.Location }

Ships = { }
GreeceInfAttack = { }
GGInfAttack = { }
TankAttackGG = { }
islanders1 = { "e1", "e1", "e3", "e1", "e3" }

Para = function()
	local powerproxy = Actor.Create("powerproxy.paratroopers", false, { Owner = player })
	local units = powerproxy.SendParatroopers(waypointPara.CenterPosition, false, 32)
	Utils.Do(units, function(unit)
		IdleHunt(unit)
	end)
	powerproxy.Destroy()
end

Para2 = function()
	local powerproxy = Actor.Create("powerproxy.paratroopers", false, { Owner = player })
	local units = powerproxy.SendParatroopers(waypoint39.CenterPosition, false, 32)
	Utils.Do(units, function(unit)
		IdleHunt(unit)
	end)
	powerproxy.Destroy()
end

Gguy1 = function()
	Reinforcements.Reinforce(GoodGuy, gguy1, gguyPath, 0, function(soldier)
		soldier.Hunt()
	end)
end

Gguy2 = function()
	Reinforcements.Reinforce(GoodGuy, gguy2, gguyPath, 0, function(soldier)
		soldier.Hunt()
	end)
end

IslandTroops = function()
	local unit = Reinforcements.ReinforceWithTransport(GoodGuy, "lst", islanders1, { waypoint44.Location, waypoint6.Location, waypoint92.Location }, { waypoint44.Location })[2]
	Utils.Do(unit, function(unit) Trigger.OnIdle(unit, function(idk) idk.Move(waypoint11.Location) end) end)

	Trigger.AfterDelay(DateTime.Minutes(3), function()
		local units = Reinforcements.ReinforceWithTransport(GoodGuy, "lst", gguy2, { waypoint44.Location, waypoint6.Location, waypoint92.Location }, { waypoint44.Location })[2]
		Utils.Do(units, function(unit)
			Trigger.OnIdle(unit, function(idk)
				idk.Patrol({ waypoint19.Location, waypoint29.Location, waypoint31.Location, waypoint20.Location }, true, 150)
			end)
		end)
	end)

	Trigger.AfterDelay(DateTime.Minutes(6), function()
		local units = Reinforcements.ReinforceWithTransport(GoodGuy, "lst", {"2tnk", "2tnk", "e3", "e3", "e3"}, { waypoint44.Location, waypoint7.Location, waypoint9.Location, waypoint26.Location, waypoint18.Location, waypoint54.Location }, { waypoint44.Location })[2]
		Utils.Do(units, function(unit)
			Trigger.OnIdle(unit, function(idk)
				idk.AttackMove(waypoint39.Location)
			end)
		end)
	end)
end
