Namespace("davidmatos_physicsdoor");
do -- script IgnoreCollisions 
	
	-- get reference to the script
	local IgnoreCollisions = LUA.script;
	
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||

	local baseColliders = SerializedField("Base Colliders", Collider, 16);
	local collidersToIgnore = SerializedField("Colliders To Ignore", Collider, 16);

	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||

	-- start only called at beginning
	function IgnoreCollisions.Start()
		for index1, baseCollider in ipairs(baseColliders) do
			if(baseCollider ~= nil) then
				for index2, colliderToIgnore in ipairs(collidersToIgnore) do
					if(colliderToIgnore ~= nil) then
						Physics.IgnoreCollision(baseCollider, colliderToIgnore);
					end
				end
			end
		end
	end

	-- update called every frame
	function IgnoreCollisions.Update()

	end
end