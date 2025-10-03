Namespace("davidmatos_buttonvolumeteleport");
do -- script TeleportVolume 
	
	-- get reference to the script
	local TeleportVolume = LUA.script;
	
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||

	--the gameobject reference to the position that the local player will be teleported to
	local gameObject_teleportPosition = SerializedField("Teleport Position", GameObject);

	--|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||

	--a reference to the mlplayer that is currently inside the trigger volume
	local mlplayer_playerInTriggerVolume = nil;

	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||

	--the main public function that is called when button is clicked to teleport the local player
	function TeleportVolume.TeleportPlayer()

		--if there isn't a player currently in the volume, then dont continue
		if(mlplayer_playerInTriggerVolume == nil) then
			return
		end

		--use the MLPlayer API to teleport the local player to the given position
		mlplayer_playerInTriggerVolume.Teleport(gameObject_teleportPosition.transform.position);
	end

	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||

	--start only called at beginning
	function TeleportVolume.Start()
		--not used (dont remove)
	end

	--update called every frame
	function TeleportVolume.Update()
		--not used (dont remove)
	end

    --NOTE: The local player is the only one that will trip these (since they have a rigidbody component, and other players don't in a client)
    function TeleportVolume.OnTriggerEnter(other)

		--check if its a player
        if(other.gameObject.IsPlayer()) then

			--get the current player that is in the volume
			mlplayer_playerInTriggerVolume = other.gameObject.GetPlayer();

        end 

    end

    --NOTE: The local player is the only one that will trip these
    function TeleportVolume.OnTriggerExit(other)

		--check if its a player
        if(other.gameObject.IsPlayer()) then

			--remove the reference to the current player that was in the volume
            mlplayer_playerInTriggerVolume = nil;

        end 

    end
end