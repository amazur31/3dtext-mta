--CLIENT
local playerVisibleTextEntities = {}
local streamingRadius = 50 --perhaps a way to change streaming radius can be introduced per client

function streaming()
	local px,py,pz = getElementPosition(getLocalPlayer())
	triggerServerEvent("onClientRequest3dText", root, streamingRadius)
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
			if distance <= text.distance then 
				local sx,sy = getScreenFromWorldPosition ( v.position[1], v.position[2], v.position[3]+0.95, 0.06 ) 
					if not sx then return end 
				local scale = text.scale/(0.3 * (distance / text.distance)) 
				dxDrawText ( v.text, sx, sy - 30, sx, sy - 30, tocolor(255,255,255,255), math.min ( 0.4*(150/distance)*1.4,4), v.font, "center", "bottom", false, false, false ) 
		end
	end 
end 
) 

setTimer ( streaming, 5000, 0)
addEvent("onRequested3dTextDataReceived", true) 
addEventHandler("onRequested3dTextDataReceived", root, textDataReceived)