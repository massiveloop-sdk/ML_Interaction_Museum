Namespace("davidmatos_physicssound");
do -- script PhysicsSound 
	
	-- get reference to the script
	local PhysicsSoundAudio = LUA.script;
	
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||

	local number_lowImpactMagnitudeThreshold = SerializedField("Low Impact Magnitude Threshold", Number);
	local number_highImpactMagnitudeThreshold = SerializedField("High Impact Magnitude Threshold", Number);
	local audioClips_lowImpactSounds = SerializedField("Low Impact Sounds", AudioClip, 5);
	local audioClips_highImpactSounds = SerializedField("High Impact Sounds", AudioClip, 5);

	--|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||

	local audioSource = nil;

	--|||||||||||||||||||||||||||||||||||||||||||||| MAIN LOGIC ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| MAIN LOGIC ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| MAIN LOGIC ||||||||||||||||||||||||||||||||||||||||||||||

	local function PlayPhysicsSound(playHighImpact)
		local selectedAudioClip = nil;

		if(playHighImpact == true) then
			--local selectedHighImpactIndex = math.random(1, #audioClips_highImpactSounds);
			local selectedHighImpactIndex = math.random(1, 5);

			selectedAudioClip = audioClips_highImpactSounds[selectedHighImpactIndex];
		else
			--local selectedLowImpactIndex = math.random(1, #audioClips_lowImpactSounds);
			local selectedLowImpactIndex = math.random(1, 5);

			selectedAudioClip = audioClips_lowImpactSounds[selectedLowImpactIndex];
		end

		if(selectedAudioClip ~= nil) then
			audioSource.PlayOneShot(selectedAudioClip);
		end
	end

	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||

	-- start only called at beginning
	function PhysicsSoundAudio.Start()
		audioSource = PhysicsSoundAudio.gameObject.GetComponent(AudioSource);

		LuaEvents.AddLocal(PhysicsSoundAudio, "A", PlayPhysicsSound);
	end

	-- update called every frame
	function PhysicsSoundAudio.Update()

	end

	function PhysicsSoundAudio.OnCollisionEnter(collision)
		--if the impact is strong enough to elicit a sound at all
		if(collision.impulse.magnitude > number_lowImpactMagnitudeThreshold) then

			--if the impact is hard enough to elict a strong sound
			if(collision.impulse.magnitude > number_highImpactMagnitudeThreshold) then
				LuaEvents.InvokeLocalForAll(PhysicsSoundAudio, "A", true);
			else --otherwise play a low impact sound
				LuaEvents.InvokeLocalForAll(PhysicsSoundAudio, "A", false);
			end

		end
	end
end