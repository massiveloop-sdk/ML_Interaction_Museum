Namespace("davidmatos_doorbutton");
do -- script DoorButtonClick 
	
	-- get reference to the script
	local DoorButtonClick = LUA.script;
	
    --|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||

	local doorObject = SerializedField("Door Object", GameObject);

    --|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
    
    local clickable = nil;
    local doorObjectScript = nil;

    local function OnClick()
        LuaEvents.InvokeLocalForAll(doorObjectScript, "ToggleDoor");
    end

    --|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
	--|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||

    function DoorButtonClick.Start()
        doorObjectScript = doorObject.GetComponent(davidmatos_doorbutton.DoorButtonBase);
        clickable = DoorButtonClick.gameObject.GetComponent(MLClickable);

        clickable.OnClick.Add(OnClick); --add our handler so it can be fired on click
    end

    function DoorButtonClick.Update()

    end
end