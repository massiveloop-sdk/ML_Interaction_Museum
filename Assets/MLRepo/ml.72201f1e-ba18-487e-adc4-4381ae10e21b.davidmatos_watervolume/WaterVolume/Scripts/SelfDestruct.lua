Namespace("davidmatos_watervolume");
do -- script SelfDestruct 
	
	-- get reference to the script
	local SelfDestruct = LUA.script;

	local number_selfDestructTimeDelay = SerializedField("Time Delay", Number);
	
	-- start only called at beginning
	function SelfDestruct.Start()
		Object.Destroy(SelfDestruct.gameObject, number_selfDestructTimeDelay);
	end

	-- update called every frame
	function SelfDestruct.Update()

	end
end