Namespace("davidmatos_triggerteleport");
do -- script TriggerTeleportVolume 
	
	-- get reference to the script
	local TriggerTeleportVolume = LUA.script;
	
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||

	local gameObject_teleportPosition = SerializedField("Teleport Position", GameObject);

	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||

	-- start only called at beginning
	function TriggerTeleportVolume.Start()

	end

	-- update called every frame
	function TriggerTeleportVolume.Update()

	end

    --NOTE: The local player is the only one that will trip these
    function TriggerTeleportVolume.OnTriggerEnter(other)
        if(other.gameObject.IsPlayer()) then
            other.gameObject.GetPlayer().Teleport(gameObject_teleportPosition.transform.position);
        end 
    end
end