do -- script Train 
	
	-- get reference to the script
	local Train = LUA.script;
	
	local trackSystem = SerializedField("trackSystem", TYPE.OBJECT); --GameObject type
    local trainCarParent = SerializedField("trainCarParent", TYPE.OBJECT); --GameObject type

    local trainCarSeperation = SerializedField("trainCarSeperation", TYPE.NUMBER); --float type
    local moveSpeed = SerializedField("moveSpeed", TYPE.NUMBER); --float type
    local useSmoothing = SerializedField("useSmoothing", TYPE.BOOL); --bool type
    local smoothFactor = SerializedField("smoothFactor", TYPE.NUMBER); --float type

    local trackPoints = nil; --List<Transform> type
    local trainCarParts = nil; --List<Transform> type
    local lerpFactor = 0; --float type (NOTE: ONLY NEED THIS TO SYNC THE WHOLE TRAIN)
	--local syncedLerpFactor = SyncVar(Train, "syncedLerpFactor", false);

	local function UpdateTrainCars()
		if trackPoints == nil then
			do return end
		end

		lerpFactor = lerpFactor + (Time.deltaTime * moveSpeed);

		if lerpFactor > #trackPoints - 1 then
			lerpFactor = 0;
		end

		for i = 0, #trackPoints do
			local trainCar = trainCarParts[i]; --Transform type

			local seperationFactor = trainCarSeperation * i; --float type
			local lerpIndex = Mathf.Clamp(lerpFactor + seperationFactor, 0.0, #trackPoints - 1); --int type
			lerpIndex = Mathf.Floor(lerpIndex); --need to make this an "integer" in lua to prevent issues using this as an array index

			if lerpIndex < #trackPoints - 1 then
				local currentTrackPoint = trackPoints[lerpIndex].position; --Vector3 type
				local nextTrackPoint = trackPoints[lerpIndex + 1].position; --Vector3 type
				local direction = currentTrackPoint - nextTrackPoint; --Vector3 type

				local newLerpFactor = (lerpFactor + seperationFactor) - lerpIndex; --float type

				if(trainCar ~= nil) then
					trainCar.position = Vector3.Lerp(currentTrackPoint, nextTrackPoint, newLerpFactor);

					if useSmoothing == true then
						trainCar.rotation = Quaternion.Slerp(trainCar.rotation, Quaternion.LookRotation(direction, Vector3.up), Time.deltaTime * smoothFactor);
					else
						trainCar.rotation = Quaternion.LookRotation(direction, Vector3.up);
					end
				end
			end
		end
	end

	-- start only called at beginning
	function Train.Start()

		trackPoints = {};
        trainCarParts = {};

    	for i = 0, trackSystem.transform.childCount - 1 do
			trackPoints[i] = trackSystem.transform.GetChild(i);
		end

        for i = 0, trainCarParent.transform.childCount - 1 do
			trainCarParts[i] = trainCarParent.transform.GetChild(i);
		end
	
	end

	
	-- update called every frame
	function Train.Update()

		UpdateTrainCars();
	
	end
end