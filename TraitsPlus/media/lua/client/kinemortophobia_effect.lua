local voiceLines = {
	"F##K a walker!",
	"Aaahhh! A zed!",
	"That corspe is walking?!",
	"Ugghhh that smell!",
	"WTF!",
	"Get away from me!"
}

local function getRandomLine() --gets a random voiceline;
	return voiceLines[ZombRand(#voiceLines)];
end

local function inRange(player, zombie) --Gets the distance of the zombie from the player
	local result = false;
	
	local pX = player:getX();
	local pY = player:getY();
	local pZ = player:getZ();
	
	local zX = zombie:getX();
	local zY = zombie:getY();
	local zZ = zombie:getZ();
	
	local dist = math.sqrt(math.pow((zX-pX), 2) + math.pow((zY-pY), 2) + math.pow((zZ-pZ), 2));
	
	if(dist <= 4) then
		result = true;
	end
	
	return result;
end

local panicTime = 30;
local pS0 = os.time();
local pS1 = os.time();
local panic = false;
local function handlePanic() --Manages how long the player should panic for
	pS1 = os.time();
	delta = os.difftime(pS1, pS0);
	if(delta >= 1) then
		pS0 = pS1;
		panicTime = panicTime-1;
	end
	
	if(panic == true) then
		local player = getPlayer();
		local stats = player:getStats();
		local panic = stats:getPanic();
		local fear = stats:getFear();
	
		if(panic < 16) then
			stats:setPanic(16);
		end
	
		if(fear < 16) then
			stats:setFear(16);
		end
	end
	
	if(panicTime < 0) then
		panicTime = 30
		panic = false;
	end
end

local zombies = {};
local function effect(player, zombie)
	
	if(zombies[zombie] == nil) then --instantiates zombieData object
		local zombieData = {};
		zombieData.yelledAt = false;
		zombieData.isNear = inRange(player, zombie);
		zombieData.inView = player:CanSee(zombie);
		zombieData.timeSinceYell = os.time();
		zombies[zombie] = zombieData;
	end
	
	zombies[zombie].inView = player:CanSee(zombie);
	if(zombies[zombie].inView == true) then
		zombies[zombie].isNear = inRange(player, zombie); --update zombieData
		if(zombies[zombie].isNear == true) then
			panicTime = 30;
			if(zombies[zombie].yelledAt == false) then
				zombies[zombie].yelledAt = true;
				
				zombies[zombie].timeSinceYell = os.time();
				if(panic == false) then
					panic = true;
				end
				
				player:Say(getRandomLine());
				zombie:spotted(player, true);
			end
		end
	end
	
	local s1 = os.time(); --Determines if zombie can be yelled at again or not.
	local delta = os.difftime(s1, zombies[zombie].timeSinceYell);
	if(delta >= 60 and delta <= 120) then
		if(zombies[zombie].yelladAt == true) then
			zombies[zombie].yelledAt = false;
		end
	end
	
	if(delta > 120) then --Determines if zombie has become irrelevant.
		zombies[zombie] = nil;
	end
end

local function handleEffect(zombie)
	local player = getPlayer();
	
	if(player:HasTrait("kinemortophobia") == true) then
		effect(player, zombie);
	end
end

Events.OnZombieUpdate.Add(handleEffect);
Events.OnTick.Add(handlePanic);