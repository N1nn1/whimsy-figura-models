-- version 0.1
-- made by JimmyHelp

local manager = {}
manager.states = {}
manager.syncs = {}
manager.syncs.effects = {}
local hostEffects = {}
manager.syncs.screen = host:getScreen() and host:getScreen():match("[^.]+$") or "None"
manager.states.flying = host:isFlying()

local isUsingFlying = false
local isUsingScreen = false
local isUsingEffects = false

local hitBlock
local oldcFlying = false
local cFlying = false
local screen = host:getScreen() and host:getScreen():match("[^.]+$") or "None"
local oldScreen = host:getScreen() and host:getScreen():match("[^.]+$") or "None"
local updateTimer = 0
local flying
local screens
local oldEffect = 0
local newEffect = 0
local handedness
local rightSwing
local leftSwing

local lastYaw
local yawDiff
function events.entity_init()
    lastYaw = player:getBodyYaw()
    yawDiff = lastYaw
end

local function tableLength(tbl)
    local count = 0
    for _ in pairs(tbl) do count = count + 1 end
    return count
end

local function updateStates(screen,fly,effect)
    if fly ~= nil then flying = fly end
    if screen ~= nil then screens = screen end
    if effect ~= nil then
        manager.syncs.effects = {}
        for name,effects in pairs(effect) do
            manager.syncs.effects[name] = {}
            manager.syncs.effects[name].visible = effects.visible
            manager.syncs.effects[name].amplifier = effects.amplifier
        end
    end
end

pings.updateStates = updateStates

updateStates(manager.syncs.screen,manager.states.flying)

function events.tick()
    if host:isHost() then
        -- start creative flying sync
        if isUsingFlying then
            cFlying = host:isFlying()
            if cFlying ~= oldcFlying then
                pings.updateStates(_,cFlying)
            end
            oldcFlying = cFlying
        end
        -- end creative flying sync

        -- start inventory screen sync
        if isUsingScreen then
            screen = host:getScreen() and host:getScreen():match("[^.]+$") or "None"
            if screen ~= oldScreen then
                pings.updateStates(screen)
            end
            oldScreen = screen
        end
        -- end inventory screen sync

        -- start potion effects sync
        if isUsingEffects then
            hostEffects = {}
            for _, effect in pairs(host:getStatusEffects()) do
                local effectName = effect.name:match("[^.]+$")
                hostEffects[effectName] = {}
                hostEffects[effectName].amplifier = effect.amplifier
                hostEffects[effectName].visible = effect.visible
            end
            newEffect = tableLength(hostEffects)
            if newEffect ~= oldEffect then
                pings.updateStates(_,_,hostEffects)
            end
            oldEffect = newEffect
        end
        -- end potion effects sync

        -- start repeated update
        if isUsingEffects or isUsingFlying or isUsingScreen then
            updateTimer = updateTimer + 1
            if updateTimer % 200 == 0 then
                pings.updateStates(screen,cFlying,hostEffects)
            end
        end
        -- end repreated update
    end

    local velocity = player:getVelocity()
    local moving = velocity.xz:length() > .01
    yawDiff = player:getBodyYaw() - lastYaw
    local pv = velocity:mul(1, 0, 1):normalize()
    local pl = models:partToWorldMatrix():applyDir(0,0,-1):mul(1, 0, 1):normalize()
    local fwd = pv:dot(pl)
    local backwards = fwd < -.8
    local sideways = pv:cross(pl)
    local right = sideways.y > .6
    local left = sideways.y < -.6
    local pose = player:getPose()
    local standing = pose == "STANDING"
    handedness = player:isLeftHanded()
    local rightActive = handedness and "OFF_HAND" or "MAIN_HAND"
    local leftActive = not handedness and "OFF_HAND" or "MAIN_HAND"
    rightSwing = player:getSwingArm() == rightActive
    leftSwing = player:getSwingArm() == leftActive

    -- states
    manager.states.idle = not moving and standing
    manager.states.walk = moving and standing and not player:isSprinting()
    manager.states.backwards = backwards
    manager.states.right = right
    manager.states.left = left
    manager.states.turnRight = yawDiff > 0
    manager.states.turnLeft = yawDiff < 0
    manager.states.flying = flying

    -- easy syncs
    manager.syncs.screen = screens

    lastYaw = player:getBodyYaw()
end

function events.on_play_sound(id, pos)
    if not player:isLoaded() then return end
    if id == "minecraft:entity.firework_rocket.launch" then
        manager.states.launchFirework = player:isSwingingArm()
    end
    if (player:getPos() - pos):length() > 0.5 then return end
    if id == "minecraft:entity.arrow.shoot" then
        manager.states.fireBow = true
    elseif id == "minecraft:item.crossbow.shoot" then
        manager.states.fireCrossbow = true
    elseif id == "minecraft:item.shield.block" and (pos-player:getPos()):length() < 1 then
        manager.states.blockDamage = true
    elseif id:find("potion.throw") then
        manager.states.throwPotion = true
    end
end

local entityAPI = figuraMetatables.EntityAPI.__index
local livingEntityAPI = figuraMetatables.LivingEntityAPI.__index
local playerAPI = figuraMetatables.PlayerAPI.__index

---@return ItemStack
entityAPI.getHelmetItem = function(self) return player:getItem(6) end
---@return ItemStack
entityAPI.getChestplateItem = function(self) return player:getItem(5) end
---@return ItemStack
entityAPI.getLeggingsItem = function(self) return player:getItem(4) end
---@return ItemStack
entityAPI.getBootsItem = function(self) return player:getItem(3) end
---@return boolean
entityAPI.isGrounded = function(self) 
    local below = world.getBlockState(self:getPos():add(0,-.1,0)):isSolidBlock()
    return (below or self:isOnGround()) and true or false 
end
---@return ItemStack
---@param hand string
livingEntityAPI.getHandItem = function(self,hand)   
    if hand == "LEFT" then
        return self:getHeldItem(not handedness)
    elseif hand == "RIGHT" then
        return self:getHeldItem(handedness)
    else
        error("Invalid hand '" .. tostring(hand) .. "'- use \"LEFT\" or \"RIGHT\".", 2)
    end
end
---@return ItemStack
livingEntityAPI.getRightItem = function(self) return self:getHandItem("RIGHT") end
---@return ItemStack
livingEntityAPI.getLeftItem = function(self) return self:getHeldItem("LEFT") end
---@return boolean
playerAPI.isWalking = function(self) return manager.states.walk end
---@return boolean
playerAPI.isIdling = function(self) return manager.states.idle end
---@return boolean
playerAPI.isCrawling = function(self) return player:getPose() == "SWIMMING" and not player:isInWater() end
---@return boolean
playerAPI.isSwimmingInWater = function(self) return player:getPose() == "SWIMMING" and player:isInWater() end
---@return boolean
playerAPI.isFlying = function(self) isUsingFlying = true return manager.states.flying end
---@return boolean
playerAPI.isSitting = function(self) return player:getPose() == "SITTING" or (player:getVehicle() and true or false) end
---@return boolean
playerAPI.isMovingBackwards = function(self) return manager.states.backwards end
---@return boolean
playerAPI.isMovingRight = function(self) return manager.states.right end
---@return boolean
playerAPI.isMovingLeft = function(self) return manager.states.left end
---@return boolean
playerAPI.isSwingingRightArm = function(self) return rightSwing and self:isSwingingArm() end
---@return boolean
playerAPI.isSwingingLeftArm = function(self) return leftSwing and self:isSwingingArm() end
---@return boolean
playerAPI.isTurningRight = function(self) return manager.states.turnRight end
---@return boolean
playerAPI.isTurningLeft = function(self) return manager.states.turnLeft end
---@return boolean
playerAPI.wasHurt = function(self) return self:getNbt().HurtTime == 9 end
---@return boolean
playerAPI.firedBow = function(self) if manager.states.fireBow == true then manager.states.fireBow = false return true else return false end end
---@return boolean
playerAPI.firedCrossbow = function(self) if manager.states.fireCrossbow == true then manager.states.fireCrossbow = false return true else return false end end
---@return boolean
playerAPI.blockedDamage = function(self) if manager.states.blockDamage == true then manager.states.blockDamage = false return true else return false end end
---@return boolean
playerAPI.launchedFirework = function(self) if manager.states.launchFirework == true then manager.states.launchFirework = false return true else return false end end
---@return boolean
playerAPI.threwPotion = function(self) if manager.states.throwPotion == true then manager.states.throwPotion = false return true else return false end end
---@return boolean
---@param range number
playerAPI.isTargetingBlock = function(self,range) 
    local targetBlock = self:getTargetedBlock(true, range or (self:getGamemode() and 5 or 4.5))
    local blockSuccess, blockResult = pcall(targetBlock.getTextures, targetBlock)
    if blockSuccess then hitBlock = not (next(blockResult) == nil) else hitBlock = true end
    return hitBlock 
end
---@return boolean
---@param range number
---@param living boolean
playerAPI.isTargetingEntity = function(self,range,living)
    local entity = self:getTargetedEntity(range or (self:getGamemode() and 5 or 3))
    if living then
        return type(entity) == "PlayerAPI" or type(entity) == "LivingEntityAPI"
    else
        return entity and true or false
    end
end
---@return table
playerAPI.getStatusEffects = function(self) isUsingEffects = true return manager.syncs.effects end
---@return string
playerAPI.getScreen = function(self) isUsingScreen = true return manager.syncs.screen end

local ItemStack_index = figuraMetatables.ItemStack.__index

local ItemStackMethods = {}
---@return boolean
function ItemStackMethods:isLoadedCrossbow()
    return self.id == "minecraft:crossbow" and self.tag and self.tag["Charged"] == 1
end

function figuraMetatables.ItemStack:__index(key)
    return ItemStackMethods[key] or ItemStack_index(self, key)
end

local SoundAPI_index = figuraMetatables.SoundAPI.__index

local SoundAPIMethods = {}
---@param soundID string
---@param replacement string
---@param range number
function SoundAPIMethods:replaceSound(soundID,replacement,range)
    if type(soundID) ~= "string" then
        error("Sound id was not provided or is not a string")
    end
    if type(replacement) ~= "string" then
        error("Replacement sound not provided or not a string")
    end
    events.on_play_sound:remove(soundID)
    events.on_play_sound:register(
        function(id,pos,vol,pitch,_,_,path)
            local r = range or 0.5
            if not path then return end
            if not player:isLoaded() then return end 
            if (player:getPos() - pos):length() > r then return end
            if id:find(soundID) then 
                sounds:playSound(replacement, pos, vol, pitch)
                return true
            end
        end,
    soundID)
    return self
end

function figuraMetatables.SoundAPI:__index(key)
    return SoundAPIMethods[key] or SoundAPI_index(self, key)
end

return manager