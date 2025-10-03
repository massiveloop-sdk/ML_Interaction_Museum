Namespace("davidmatos_canfluid");
do -- script FluidCan 
	
	--[[
	This is a script that handles logic for water cans.
	These can be spawned from a vending machine.
    As for interaction the player can grab these, open with trigger, and tilt the can to a specific angle where "water" will be drained.

	As for server code, only events are syncronized which set the "bool_localLiftState".
	]]--

	-- get reference to the script
	local FluidCan = LUA.script;

    --|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
    --these variables are exposed and accessible through the unity inspector

    local gameObject_closedMesh = SerializedField("Closed Mesh", GameObject); --gameobject with the closed can mesh
    local gameObject_openedMesh = SerializedField("Opened Mesh", GameObject); --gameobject with the opened can mesh
    local bool_limitedAmount = SerializedField("Limited Amount", Bool);
    local number_fluidDrainRate = SerializedField("Fluid Drain Rate", Number); --how quickly the fluid "drains" from the can
    local number_fluidMaxAmount = SerializedField("Fluid Amount", Number); --how much "fluid" is in the can
    local number_fluidDrainAngle = SerializedField("Fluid Drain Angle", Number); --the angle at which the can will start draining when emptied
    local textmesh_fluidText = SerializedField("Fluid Text", TextMesh);
    local audioSource_openAudio = SerializedField("Open Audio", AudioSource); --the audio source to use when the can is opened
    local audioSource_pourAudio = SerializedField("Drain Audio", AudioSource); --the audio source to use when the can is pouring.
    local playableDirector_particleTimeline = SerializedField("Particle Drain Timeline", PlayableDirector); --the sequence to play for when the can is pouring (since there is no particle SDK support, we can use sequences and "signal" assets to tell the water particle system to start/stop)

    --|||||||||||||||||||||||||||||||||||||||||||||| SERVER VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| SERVER VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| SERVER VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||

    local bool_canServerState = SyncVar(FluidCan, "a");
    local bool_canServerFluidAmount = SyncVar(FluidCan, "b");

	--|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||

    local bool_isOpened = false; --the current state of the can
    local number_fluidAmount = 0;
    local mlgrab_grab = nil;
    local mlplayer_localPlayer = nil;

    --|||||||||||||||||||||||||||||||||||||||||||||| MAIN ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| MAIN ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| MAIN ||||||||||||||||||||||||||||||||||||||||||||||

    --Added to LuaEvents so this can be called across clients.
    local function LocalForceRelease()
		mlgrab_grab.ForceRelease();
	end

	local function OpenFluidCan()
        audioSource_openAudio.Play();
        bool_isOpened = true;

        gameObject_closedMesh.SetActive(false);
        gameObject_openedMesh.SetActive(true);
	end

    --properly plays a looping audio source
	local function PlayLoopingAudio(audioSource_source)
        if (audioSource_source.isActiveAndEnabled == true) then
            --if loop is set to false for some reason, then set it back to true
            if (audioSource_source.loop == false) then
                audioSource_source.loop = true;
			end

            --if its not playing, make sure it plays
            if (audioSource_source.isPlaying == false) then
                audioSource_source.Play();
			end
		end
    end

    --|||||||||||||||||||||||||||||||||||||||||||||| MLGRAB CALLBACKS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| MLGRAB CALLBACKS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| MLGRAB CALLBACKS ||||||||||||||||||||||||||||||||||||||||||||||

    local function OnGrabBegin()
        if(textmesh_fluidText ~= nil) then
            textmesh_fluidText.gameObject.SetActive(true);
        end
    end

    local function OnGrabEnd()
        if(textmesh_fluidText ~= nil) then
            textmesh_fluidText.gameObject.SetActive(false);
        end
    end

	local function OnClick()
        OpenFluidCan();
	end

    --|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||

    function FluidCan.ForceRelease()
        --Invoke LocalForceRelease() across clients to be absolutely sure that we forcibly release this object.
        LuaEvents.InvokeLocalForAll(WeaponScript, "A");
	end

	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||

	-- start only called at beginning
	function FluidCan.Start()
        mlplayer_localPlayer = Room.GetLocalPlayer();

		mlgrab_grab = FluidCan.gameObject.GetComponent(MLGrab);

        mlgrab_grab.OnPrimaryTriggerDown.Add(OnClick);
        mlgrab_grab.OnPrimaryGrabBegin.Add(OnGrabBegin);
        mlgrab_grab.OnPrimaryGrabEnd.Add(OnGrabEnd);

        --NOTE: kept names small since they can affect server sync performance (I would prefer to have readable names... but they are costly)
        LuaEvents.AddLocal(FluidCan, "A", LocalForceRelease);

        number_fluidAmount = number_fluidMaxAmount;

        gameObject_closedMesh.SetActive(true);
        gameObject_openedMesh.SetActive(false);

        if(textmesh_fluidText ~= nil) then
            textmesh_fluidText.gameObject.SetActive(false);
        end
	end

	-- update called every frame
	function FluidCan.Update()
        if(textmesh_fluidText ~= nil) then
            textmesh_fluidText.text = tostring(number_fluidAmount);
        end

		if (number_fluidAmount <= 0.0) then
            audioSource_pourAudio.enabled = false;

            if(playableDirector_particleTimeline ~= nil) then
                playableDirector_particleTimeline.Stop();
                playableDirector_particleTimeline.RebuildGraph();
            end

            do return end
		end

        if (bool_isOpened == true) then
            local number_canAngle = Vector3.Angle(-FluidCan.gameObject.transform.up, -Vector3.up);

            if (number_canAngle > number_fluidDrainAngle) then
                audioSource_pourAudio.enabled = true;
                PlayLoopingAudio(audioSource_pourAudio);

                if(playableDirector_particleTimeline ~= nil) then
                    if not (playableDirector_particleTimeline.state == PlayState.Playing) then
                        playableDirector_particleTimeline.RebuildGraph();
                        playableDirector_particleTimeline.Play();
                    end
                end

                if(bool_limitedAmount) then
                    number_fluidAmount = number_fluidAmount - (number_fluidDrainRate * Time.deltaTime);
                end
            else

                if(playableDirector_particleTimeline ~= nil) then
                    playableDirector_particleTimeline.Stop();
                    playableDirector_particleTimeline.RebuildGraph();
                end

                audioSource_pourAudio.enabled = false;
			end
        end
	end
end