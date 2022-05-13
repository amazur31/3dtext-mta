--CLIENT
local drawDistance = 150
local playerVisibleTextEntities = {}

function streaming()
	local px,py,pz = getElementPosition(getLocalPlayer())
	triggerServerEvent("onClientRequest3dText", root, px,py,pz,10,150)
end

function textDataReceived(receivedTexts) 
	outputConsole("textDataReceived")
	playerVisibleTextEntities = receivedTexts
end 
  
addEventHandler("onClientRender",getRootElement(), 
function() 
	for i,v in ipairs(playerVisibleTextEntities) do
    local px,py,pz = getElementPosition(getLocalPlayer()) 
    local distance = getDistanceBetweenPoints3D ( v.position[1], v.position[2], v.position[3],px,py,pz ) 
		if distance <= 150 then 
			local sx,sy = getScreenFromWorldPosition ( v.position[1], v.position[2], v.position[3]+0.95, 0.06 ) 
			if not sx then return end 
			local scale = 1/(0.3 * (distance / 150)) 
			dxDrawText ( v.text, sx, sy - 30, sx, sy - 30, tocolor(255,255,255,255), math.min ( 0.4*(150/distance)*1.4,4), "bankgothic", "center", "bottom", false, false, false ) 
		end
	end 
end 
) 

setTimer ( streaming, 5000, 0)
addEvent("onRequested3dTextDataReceived", true) 
addEventHandler("onRequested3dTextDataReceived", root, textDataReceived)