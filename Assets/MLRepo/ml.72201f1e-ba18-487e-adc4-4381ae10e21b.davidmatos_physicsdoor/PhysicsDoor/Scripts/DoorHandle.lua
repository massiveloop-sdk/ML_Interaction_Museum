Namespace("davidmatos_physicsdoor");
do -- script DoorHandle 
	
	-- get reference to the script
	local DoorHandle = LUA.script;
	
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||

	local gameObject_originalDoorHandlePosition = SerializedField("Original Door Handle Position", GameObject);
	local number_forceReleaseDistance = SerializedField("Force Release Distance", Number);

	--|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||

	local mlplayer_localPlayer = nil;
	local mlgrab_grab = nil;

	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||

	-- start only called at beginning
	function DoorHandle.Start()
		mlplayer_localPlayer = Room.GetLocalPlayer();

		mlgrab_grab = DoorHandle.gameObject.GetComponent(MLGrab);
	end

	-- update called every frame
	function DoorHandle.Update()
		local distanceFromDoor = Vector3.Distance(DoorHandle.gameObject.transform.position, gameObject_originalDoorHandlePosition.transform.position);

		if(distanceFromDoor > number_forceReleaseDistance) then
			mlgrab_grab.ForceRelease();
		end

		if(mlgrab_grab.CurrentUser == nil) then
			DoorHandle.gameObject.transform.position = gameObject_originalDoorHandlePosition.transform.position;
			DoorHandle.gameObject.transform.localRotation = Quaternion(0, 0, 0, 0);
		end
	end
end