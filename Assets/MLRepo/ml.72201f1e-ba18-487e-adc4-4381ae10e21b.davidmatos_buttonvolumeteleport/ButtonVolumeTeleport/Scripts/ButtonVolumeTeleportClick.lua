Namespace("davidmatos_buttonvolumeteleport");
--[[
	This script is a part of the "TeleportClick" package.

	This specific script is responsible for handling the button
	input from the player to call another script that handles
	the main player teleporting interaction.
]]

do -- script TeleportClick
	
	-- get reference to the script
	local TeleportClick = LUA.script;
	
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--These variables can be accessed through the unity inspector.

	--a reference to the trigger volume gameobject that the player will enter
	local gameObject_teleportVolume = SerializedField("Teleport Volume", GameObject);

	--|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||

	--local clickable component reference 
	local mlclickable = nil;

	--|||||||||||||||||||||||||||||||||||||||||||||| MAIN LOGIC ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| MAIN LOGIC ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| MAIN LOGIC ||||||||||||||||||||||||||||||||||||||||||||||

	--cick callback when the local player clicks the button
	local function TeleportOnClick()
		--get a new reference to the script teleport (note: we could precache this in the start method... however the script reference sometimes can be lost so we will do this every time to make sure we have it)
		local script = gameObject_teleportVolume.GetComponent(davidmatos_buttonvolumeteleport.TeleportVolume);

		--call the main method on script thats on our trigger volume to teleport the player
		script.TeleportPlayer();
	end

	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||

	-- start only called at beginning
	function TeleportClick.Start()
		mlclickable = TeleportClick.gameObject.GetComponent(MLClickable);

		--add our handler function for calling teleport logic
		mlclickable.OnClick.Add(TeleportOnClick);
	end

	-- update called every frame
	function TeleportClick.Update()

	end
end