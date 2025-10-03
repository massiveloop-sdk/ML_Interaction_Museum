Namespace("davidmatos_watervolume");
do -- script VolumeWater 
	
	-- get reference to the script
	local VolumeWater = LUA.script;
	
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||

	--------------- Buoyancy ---------------
	local bool_doBuoyancy = SerializedField("Do Buoyancy", Bool);

	--increase value to make object more buoyant, default 8.
	local number_buoyancyForce = SerializedField("Buoyancy Force", Number);

	--value 0 mean no additional Buoyant Force underwater, 1 mean Double buoyant Force underwater (underwater pressure)
	local number_depthPower = SerializedField("Depth Power", Number);

	--------------- Splashes ---------------
	local bool_doSplashes = SerializedField("Do Splashes", Bool);
	local gameObject_waterSplashEnterPrefab = SerializedField("Water Splash Enter Prefab", GameObject);
	local gameObject_waterSplashExitPrefab = SerializedField("Water Splash Exit Prefab", GameObject);
	local gameObject_waterSurfaceHeight = SerializedField("Surface Height Anchor", GameObject);

	--|||||||||||||||||||||||||||||||||||||||||||||| MAIN LOGIC ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| MAIN LOGIC ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| MAIN LOGIC ||||||||||||||||||||||||||||||||||||||||||||||

	local function SpawnWaterSplashPrefab(prefabSpawnPosition, index)
		if(index == true) then
			Object.Instantiate(gameObject_waterSplashEnterPrefab, prefabSpawnPosition, Quaternion(0, 0, 0, 0));
		else
			Object.Instantiate(gameObject_waterSplashExitPrefab, prefabSpawnPosition, Quaternion(0, 0, 0, 0));
		end
	end

	local function ComputeBouyancyOnRigidbody(collider, rigidbody)
		local number_objectYPosition = collider.bounds.center.y;

		local number_buoyantForceMass = number_buoyancyForce * rigidbody.mass;
		local number_underWaterBuoyantForce = Mathf.Clamp01((gameObject_waterSurfaceHeight.transform.position.y - number_objectYPosition) * number_depthPower);
		local number_buoyancy = number_buoyantForceMass + (number_buoyantForceMass * number_underWaterBuoyantForce);

		rigidbody.AddForce(Vector3(0, number_buoyancy, 0), ForceMode.Force);
	end

	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||

	-- start only called at beginning
	function VolumeWater.Start()
		LuaEvents.AddLocal(VolumeWater, "A", SpawnWaterSplashPrefab);
	end

	-- update called every frame
	function VolumeWater.Update()

	end

	--NOTE: The local player is the only one that will trip these
	function VolumeWater.OnTriggerEnter(other)
		if(bool_doSplashes == false) then
			return
		end

		local prefabSpawnPosition = Vector3(other.gameObject.transform.position.x, gameObject_waterSurfaceHeight.transform.position.y, other.gameObject.transform.position.z);

		--if the object that entered the trigger volume is infact a player
		if(other.gameObject.IsPlayer() == true) then
			LuaEvents.InvokeLocalForAll(VolumeWater, "A", prefabSpawnPosition, true); --Invoke SpawnWaterSplashPrefab
		else
			local mlgrabParentTest = other.gameObject.GetComponent(MLGrab);
			local rigidbodyParentTest = other.gameObject.GetComponent(Rigidbody);

			local rigidbodyChildren = other.gameObject.GetComponentsInChildren(Rigidbody);
			local rigidbodyChildrenTest = false;

			if(rigidbodyChildren ~= nil) then
				for index1, rigidbodyChild in ipairs(rigidbodyChildren) do
					if(rigidbodyChild ~= nil) then
						rigidbodyChildrenTest = true;
					end
				end
			end

			local mlgrabChildren = other.gameObject.GetComponentsInChildren(MLGrab);
			local mlgrabChildrenTest = false;

			if(mlgrabChildren ~= nil) then
				for index2, mlgrabChild in ipairs(mlgrabChildren) do
					if(mlgrabChild ~= nil) then
						mlgrabChildrenTest = true;
					end
				end
			end

			--if there is a rigidbody, then do a splash
			if(rigidbodyParentTest ~= nil) or (rigidbodyChildrenTest == true) or (mlgrabParentTest ~= nil) or (mlgrabChildrenTest == true) then
				LuaEvents.InvokeLocalForAll(VolumeWater, "A", prefabSpawnPosition, true); --Invoke SpawnWaterSplashPrefab
			end
		end
	end

	--NOTE: The local player is the only one that will trip these
	function VolumeWater.OnTriggerExit(other)
		if(bool_doSplashes == false) then
			return
		end

		local prefabSpawnPosition = Vector3(other.gameObject.transform.position.x, gameObject_waterSurfaceHeight.transform.position.y, other.gameObject.transform.position.z);

		--if the object that entered the trigger volume is infact a player
		if(other.gameObject.IsPlayer() == true) then
			LuaEvents.InvokeLocalForAll(VolumeWater, "A", prefabSpawnPosition, false); --Invoke SpawnWaterSplashPrefab
		else
			local mlgrabParentTest = other.gameObject.GetComponent(MLGrab);
			local rigidbodyParentTest = other.gameObject.GetComponent(Rigidbody);

			local rigidbodyChildren = other.gameObject.GetComponentsInChildren(Rigidbody);
			local rigidbodyChildrenTest = false;

			if(rigidbodyChildren ~= nil) then
				for index1, rigidbodyChild in ipairs(rigidbodyChildren) do
					if(rigidbodyChild ~= nil) then
						rigidbodyChildrenTest = true;
					end
				end
			end

			local mlgrabChildren = other.gameObject.GetComponentsInChildren(MLGrab);
			local mlgrabChildrenTest = false;

			if(mlgrabChildren ~= nil) then
				for index2, mlgrabChild in ipairs(mlgrabChildren) do
					if(mlgrabChild ~= nil) then
						mlgrabChildrenTest = true;
					end
				end
			end

			--if there is a rigidbody, then do a splash
			if(rigidbodyParentTest ~= nil) or (rigidbodyChildrenTest == true) or (mlgrabParentTest ~= nil) or (mlgrabChildrenTest == true) then
				LuaEvents.InvokeLocalForAll(VolumeWater, "A", prefabSpawnPosition, false); --Invoke SpawnWaterSplashPrefab
			end
		end
	end

	--NOTE: The local player is the only one that will trip these
	function VolumeWater.OnTriggerStay(other)
		if(bool_doBuoyancy == false) then
			return
		end

		local rigidbodyParentTest = other.gameObject.GetComponent(Rigidbody);
		local rigidbodyChildren = other.gameObject.GetComponentsInChildren(Rigidbody);

		local totalRigidbodyList = {};

		if(rigidbodyParentTest ~= nil) then
			table.insert(totalRigidbodyList, rigidbodyParentTest);
		end

		if(rigidbodyChildren ~= nil) then
			for index1, rigidbodyChild in ipairs(rigidbodyChildren) do
				table.insert(totalRigidbodyList, rigidbodyChild);
			end
		end

		for index2, rigidbody in ipairs(totalRigidbodyList) do
			ComputeBouyancyOnRigidbody(other, rigidbody);
		end
	end
end