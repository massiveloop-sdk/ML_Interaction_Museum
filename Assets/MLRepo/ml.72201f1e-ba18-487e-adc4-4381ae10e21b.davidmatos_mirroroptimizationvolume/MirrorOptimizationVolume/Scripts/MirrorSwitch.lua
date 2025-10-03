Namespace("davidmatos_mirroroptimizationvolume");
do -- script MirrorSwitch 
	
	-- get reference to the script
	local MirrorSwitch = LUA.script;
	
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--these variables are exposed and accessible through the unity inspector

	local gameObject_activeMirror = SerializedField("Active Mirror", GameObject); 
	local gameObject_fallbackMirror = SerializedField("Fallback Mirror", GameObject); 

	--|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||

	local mlmirror_mirror = nil;

	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||

	-- start only called at beginning
	function MirrorSwitch.Start()
		mlmirror_mirror = gameObject_activeMirror.GetComponent(MLMirror);

		mlmirror_mirror.MirrorActive = false;
		gameObject_activeMirror.SetActive(false);

		if(gameObject_fallbackMirror ~= nil) then
			gameObject_fallbackMirror.SetActive(true);
		end
	end

	-- update called every frame
	function MirrorSwitch.Update()

	end

	--NOTE TO SELF: The local player is the only one that seems to trip these
	function MirrorSwitch.OnTriggerEnter(other)
		--if the object that entered the trigger volume is infact a player
		if(other.gameObject.IsPlayer() == true) then
			gameObject_activeMirror.SetActive(true);

			if(gameObject_fallbackMirror ~= nil) then
				gameObject_fallbackMirror.SetActive(false);
			end

			mlmirror_mirror.MirrorActive = true;
		end
	end

	--NOTE TO SELF: The local player is the only one that seems to trip these
	function MirrorSwitch.OnTriggerExit(other)
		--if the object that entered the trigger volume is infact a player
		if(other.gameObject.IsPlayer() == true) then
			mlmirror_mirror.MirrorActive = false;
			gameObject_activeMirror.SetActive(false);

			if(gameObject_fallbackMirror ~= nil) then
				gameObject_fallbackMirror.SetActive(true);
			end
		end
	end
end