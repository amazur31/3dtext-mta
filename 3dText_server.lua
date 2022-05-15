--SERVER

TextsList = {}

local random = math.random
local function uuid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end

--Creates 3D text with specified parameters and assigns unique GUID
function create3dText(x, y, z, content, color, distance, scale, font, los)
	local text = {}

	text.position = {x, y, z}
	text.text = content
	text.color = color
	text.distance = distance or 20.0
	text.scale = scale or 1.0
	text.font = font or "default"
	text.los = los or false
	text.id = uuid()
	TextsList[#TextsList+1] = text

	return text.id
end

--Edits 3D text specified parameters
function edit3dText(id, x, y, z, content, color, distance, scale, font, los)
	
	local newText = {}

	newText.position = {x, y, z}
	newText.text = content
	newText.color = color
	newText.distance = distance or 20.0
	newText.scale = scale or 1.0
	newText.font = font or "default"
	newText.los = los or false
	
	local index = nil
	for i,v in ipairs(TextsList) do
		if v.id == id then
			index = i
			newText.id = v.id
		end
	end
	if index == nil then
		return false
	else
		TextsList[index] = newText
		return true	
	end
end

--Gets 3D text
function get3dTextByID(id)
	for i,v in ipairs(TextsList) do
		if v.id == id then
			return v
		end
	end
	return nil
end

--Removes 3D text
function remove3dTextByID(id)
	local index = nil
	for i,v in ipairs(TextsList) do
		if v.id == id then
			index = i
		end
	end
	if index == nil then
		return false
	else
		table.remove(TextsList, index)
		return true	
	end
end

--handles streaming objects to player
--x, y, z - player coords

function handle3dTextStreaming(radius)
	local textsToBeSentToClient = {}
	local x, y, z = getElementPosition(client)
	textsToBeSentToClient = TextsList
	
	triggerClientEvent( client, "onRequested3dTextDataReceived", root, textsToBeSentToClient)
end

addEvent("onClientRequest3dText", true)
addEventHandler( "onClientRequest3dText", root, handle3dTextStreaming)

--I guess you could call this part Unit Tests lol 
local someId
local someText

function debugAdding()
	outputChatBox ( "Adding 3D Texts" , source, 255, 255, 255 )
	create3dText(-2404, -598, 134, "Dupa1", 0x3486EBFF, 20.0)
	create3dText(-2404, -594, 139, "Dupa2", 0x3486EBFF, 20.0)
	create3dText(-2404, -598, 137, "Dupa3", 0x3486EBFF, 20.0, 1.0, "default", true)
	create3dText(0, 0, 0, "Test string", 0xEB3A34FF, 20.0) --last entry is deleted in tests
	outputChatBox ( "All 3D Texts added" , source, 255, 255, 255 )
	outputChatBox ( "~~~~" , source, 255, 255, 255 )
end

function debugReading()
	outputChatBox ( "Listing all 3D Texts" , source, 255, 255, 255 )
	for i,v in ipairs(TextsList) do
		someId = v.id 
		someText = v
		outputChatBox(v.id) 
	end
	outputChatBox ( "~~~~" , source, 255, 255, 255 )
	outputChatBox ( "Trying to get text with ID: " .. someId , source, 255, 255, 255 )
end

function debugGet()
		local text = get3dTextByID(someId)
		if text then
			outputChatBox ( "Got text with ID " .. someId .. " Content " .. text.text , source, 255, 255, 255 )
		else
			outputChatBox ( "Couldnt get text: " .. someId , source, 255, 255, 255 )
	end
end

function debugRemove()
	outputChatBox ( "Removing id: " .. someId , source, 255, 255, 255 )
	local removeResult = remove3dTextByID(someId)
		if removeResult then
			outputChatBox ( "Removed text with ID " .. someId , source, 255, 255, 255 )
		else
			outputChatBox ( "Couldnt remove text: " .. someId , source, 255, 255, 255 )
		end
end

function debugEdit()
	outputChatBox ( "Editing id: " .. someId , source, 255, 255, 255 )
	someText.content = "EDIT SUCCESS"
	local editResult = edit3dText(someId, someText.position.x, someText.position.y, someText.position.z, someText.content, someText.color, someText.distance, someText.scale, someText.font, someText.los)
		if editResult then
			outputChatBox ( "Edited text with ID " .. someId , source, 255, 255, 255 )
		else
			outputChatBox ( "Couldnt edit text: " .. someId , source, 255, 255, 255 )
		end
end

function firstStartDebug ( ) --a way to test the solution before game
	debugAdding()
	debugReading()
	debugGet()
	debugEdit()
	debugGet()
	debugRemove()
	debugGet()
end

addEventHandler ( "onResourceStart", root, firstStartDebug )