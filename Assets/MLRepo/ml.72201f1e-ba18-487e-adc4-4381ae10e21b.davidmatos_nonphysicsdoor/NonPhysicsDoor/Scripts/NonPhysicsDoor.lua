Namespace("davidmatos_nonphysicsdoor");
do -- script NonPhysicsDoorBase 
	
	-- get reference to the script
	local NonPhysicsDoorBase = LUA.script;
	
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||

	local gameObject_doorObject = SerializedField("Door Object", GameObject);
	local gameObject_invisibleHandle = SerializedField("Grabbable Handle", GameObject);
	local gameObject_originalHandlePosition = SerializedField("Original Handle Position", GameObject);

	local bool_doorAxisPositiveX = SerializedField("Door Axis Positive X", Bool);
	local bool_doorAxisNegativeX = SerializedField("Door Axis Negative X", Bool);
	local bool_doorAxisPositiveZ = SerializedField("Door Axis Positive Z", Bool);
	local bool_doorAxisNegativeZ = SerializedField("Door Axis Negative Z", Bool);

	local vector3_rotationOffset = SerializedField("Rotation Offset", Vector3);
	local vector3_rotationAxis = SerializedField("Rotation Axis", Vector3);

	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||

	-- start only called at beginning
	function NonPhysicsDoorBase.Start()

	end

	-- update called every frame
	function NonPhysicsDoorBase.Update()
        local vector3_originPosition = gameObject_doorObject.transform.position;
        local vector3_doorGrabbableHandlePosition = Vector3(gameObject_invisibleHandle.transform.position.x, vector3_originPosition.y, gameObject_invisibleHandle.transform.position.z);

        if(bool_doorAxisPositiveX) then
            vector3_doorGrabbableHandlePosition.x = Mathf.Clamp(vector3_doorGrabbableHandlePosition.x, gameObject_doorObject.transform.position.x, Mathf.Infinity);
		end

        if(bool_doorAxisNegativeX) then
            vector3_doorGrabbableHandlePosition.x = Mathf.Clamp(vector3_doorGrabbableHandlePosition.x, Mathf.NegativeInfinity, gameObject_doorObject.transform.position.x);
        end

        if (bool_doorAxisPositiveZ) then
            vector3_doorGrabbableHandlePosition.z = Mathf.Clamp(vector3_doorGrabbableHandlePosition.z, gameObject_doorObject.transform.position.z, Mathf.Infinity);
        end

        if(bool_doorAxisNegativeZ) then
            vector3_doorGrabbableHandlePosition.z = Mathf.Clamp(vector3_doorGrabbableHandlePosition.z, Mathf.NegativeInfinity, gameObject_doorObject.transform.position.z);
        end

        local vector3_directionToHandle = vector3_originPosition - vector3_doorGrabbableHandlePosition;

        local quaternion_newRotation = Quaternion.LookRotation(vector3_directionToHandle, vector3_rotationAxis);

        quaternion_newRotation = quaternion_newRotation * Quaternion.Euler(vector3_rotationOffset);

        gameObject_doorObject.transform.rotation = quaternion_newRotation;
	end
end