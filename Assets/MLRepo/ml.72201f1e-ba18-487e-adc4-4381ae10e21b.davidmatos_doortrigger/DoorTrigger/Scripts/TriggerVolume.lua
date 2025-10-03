Namespace("davidmatos_doortrigger");
do -- script TriggerVolume 
	
	-- get reference to the script
	local TriggerVolume = LUA.script;
	
    --|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||

	local doorObject = SerializedField("Door Object", GameObject);

    --|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||

    function TriggerVolume.Start()

    end

    function TriggerVolume.Update()

    end

    --NOTE: The local player is the only one that will trip these
    function TriggerVolume.OnTriggerEnter(other)
        if(other.gameObject.IsPlayer()) then
            local doorObjectScript = doorObject.GetComponent(davidmatos_doortrigger.DoorBase); -- get the script

            LuaEvents.InvokeLocalForAll(doorObjectScript, "OpenDoor"); --call the event on all clients
        end 
    end

    --NOTE: The local player is the only one that will trip these
    function TriggerVolume.OnTriggerExit(other)
        if(other.gameObject.IsPlayer()) then
            local doorObjectScript = doorObject.GetComponent(davidmatos_doortrigger.DoorBase); -- get the script

            LuaEvents.InvokeLocalForAll(doorObjectScript, "CloseDoor");--call the event on all clients
        end 
    end
end