Namespace("davidmatos_objectspawner");
do -- script ObjectSpawnerClick 
	
	-- get reference to the script
	local ObjectSpawnerClick = LUA.script;
	
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||

	local spawnPosition = SerializedField("Spawn Position", GameObject);
	local spawnedObject = SerializedField("Object To Spawn", GameObject);

	--|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||

	local clickable = nil;
	local localPlayer = nil;

	--|||||||||||||||||||||||||||||||||||||||||||||| MAIN LOGIC ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| MAIN LOGIC ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| MAIN LOGIC ||||||||||||||||||||||||||||||||||||||||||||||

	local function SpawnObject()
		if(localPlayer.isMasterClient == true) then
			Object.Instantiate(spawnedObject, spawnPosition.transform.position, spawnPosition.transform.rotation);
		end
	end

	local function Click()
		LuaEvents.InvokeLocalForAll(ObjectSpawnerClick, "A");
	end

	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||

	-- start only called at beginning
	function ObjectSpawnerClick.Start()
		localPlayer = Room.GetLocalPlayer();

		clickable = ObjectSpawnerClick.gameObject.GetComponent(MLClickable);
		clickable.OnClick.Add(Click);

		LuaEvents.AddLocal(ObjectSpawnerClick, "A", SpawnObject);
	end

	-- update called every frame
	function ObjectSpawnerClick.Update()

	end
end