Namespace("davidmatos_doortrigger");
do -- script DoorBase 
	
	-- get reference to the script
	local DoorBase = LUA.script;
	
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||

    local doorObject = SerializedField("Door Object", GameObject);
    local doorOpenedPosition = SerializedField("Open Position", GameObject);
    local doorClosedPosition = SerializedField("Closed Position", GameObject);
    local doorSpeed = SerializedField("Speed", Number);

    local audioClip_openSound = SerializedField("Open Sound", AudioClip);
    local audioClip_closeSound = SerializedField("Close Sound", AudioClip);

    --|||||||||||||||||||||||||||||||||||||||||||||| SERVER VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| SERVER VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| SERVER VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||

    local serverDoorState = SyncVar(DoorBase, "doorState");

    --|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||

    local localDoorState = false;
    local localPlayer = nil;
    local audioSource = nil;

    --|||||||||||||||||||||||||||||||||||||||||||||| MAIN LOGIC ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| MAIN LOGIC ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| MAIN LOGIC ||||||||||||||||||||||||||||||||||||||||||||||

    local function UpdateDoorState()
        if(localDoorState == true) then
            doorObject.transform.position = Vector3.Lerp(doorObject.transform.position, doorOpenedPosition.transform.position, Time.deltaTime * doorSpeed);
        else
            doorObject.transform.position = Vector3.Lerp(doorObject.transform.position, doorClosedPosition.transform.position, Time.deltaTime * doorSpeed);
        end
    end

    local function OpenDoor()
        if(localPlayer.isMasterClient == true) then
            localDoorState = true;
            serverDoorState.SyncSet(localDoorState);
        end
    end

    local function CloseDoor()
        if(localPlayer.isMasterClient == true) then
            localDoorState = false;
            serverDoorState.SyncSet(localDoorState);
        end
    end

    local function serverDoorState_OnVariableSet(value)
        localDoorState = value;

        if(localDoorState == true) then
            audioSource.PlayOneShot(audioClip_openSound);
        else
            audioSource.PlayOneShot(audioClip_closeSound);
        end
    end

    --|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||

    function DoorBase.Start()
        localPlayer = Room.GetLocalPlayer();

        audioSource = DoorBase.gameObject.GetComponent(AudioSource);

        serverDoorState.OnVariableSet.Add(serverDoorState_OnVariableSet);

        LuaEvents.AddLocal(DoorBase, "OpenDoor", OpenDoor);
        LuaEvents.AddLocal(DoorBase, "CloseDoor", CloseDoor);

        if(SyncVar.Exists(DoorBase, "doorState") == true) then
            localDoorState = serverDoorState.SyncGet();
        end
    end

    function DoorBase.Update()
        UpdateDoorState();
    end
end