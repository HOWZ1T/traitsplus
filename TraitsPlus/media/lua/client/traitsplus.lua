require('NPCs/MainCreationMethods');
local function initTest()
	local blademaster = TraitFactory.addTrait("blademaster", getText("UI_trait_blademaster"), 5, getText("UI_trait_blademasterdesc"), false, false);
	blademaster:addXPBoost(Perks.Melee, 4);
	blademaster:addXPBoost(Perks.BladeGuard, 5);
	blademaster:addXPBoost(Perks.BladeMaintenance, 5);
	blademaster:addXPBoost(Perks.BladeParent, 5);
	
	local freerunner = TraitFactory.addTrait("freerunner", getText("UI_trait_freerunner"), 8, getText("UI_trait_freerunnerdesc"), false, false);
	freerunner:addXPBoost(Perks.Agility, 6);
	freerunner:addXPBoost(Perks.Fitness, 4);
	freerunner:addXPBoost(Perks.Lightfoot, 3);
	freerunner:addXPBoost(Perks.Nimble, 3);
	freerunner:addXPBoost(Perks.Sprinting, 3);
	
	local kinemortophobia = TraitFactory.addTrait("kinemortophobia", getText("UI_trait_kinemortophobia"), -4, getText("UI_trait_kinemortophobiadesc"), false, false);
	TraitFactory.setMutualExclusive("kinemortophobia", "Brave");
	TraitFactory.setMutualExclusive("kinemortophobia", "Graceful");
	TraitFactory.setMutualExclusive("kinemortophobia", "Inconspicuous");
	
	print("ADDED TRAITS:");
	print("Blademaster");
	print("Freerunner");
	print("Kinemortophobia");
end

Events.OnGameBoot.Add(initTest);