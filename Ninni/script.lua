-- Auto generated script file --

vanilla_model.PLAYER:setVisible(false)
vanilla_model.ARMOR:setVisible(false)
vanilla_model.HELMET_ITEM:setVisible(true)
vanilla_model.HELMET:setVisible(true)
vanilla_model.CHESTPLATE:setVisible(true)
vanilla_model.CAPE:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)

swing = require("swingingPhysics")
local squapi = require("SquAPI")
local anims = require("JimmyAnims")
local Jumpstart = require("Jumpstart")

anims(animations.model)

squapi.randimation:new(animations.model.rotate, 2400, true)

squapi.smoothHead:new(models.model.root.harpy.torso.Head, 0.75, 0.05 ,1 , true)
squapi.smoothHead:new(models.model.root.harpy.torso, 0.25, 0.05 ,1 , false)


function events.item_render(item, mode, pos, rot, scale, left)

    if item.id:find("sword") then
        animations.model.sword:play()
    else
        animations.model.sword:stop()
    end

    if item.id:find("axe") or item.id:find("shovel") or item.id:find("hoe") then
        animations.model.tool:play()
    else
        animations.model.tool:stop()
    end

    if item.id == "minecraft:bow" or item.id == "alexscaves:dreadbow" then
        animations.model.bow:play()
    else
        animations.model.bow:stop()
    end

    if item.id == "minecraft:crossbow" then
        animations.model.crossbow:play()
    else
        animations.model.crossbow:stop()
    end

-- disable shield

    if item.id:find("shield") then
        return models.items.Item
    end

end

function events.render(delta, context)
    -- armor modifiers
    animations.model.helmet:play()

    -- close eyes
    if world.getLightLevel(player:getPos()) < 5 then
        animations.model.lowlight:stop()
    else
        animations.model.lowlight:play()
    end

    -- custom arm
    models.model.root.LeftArm:setVisible(context == "FIRST_PERSON" and not player:isFlying())
    models.model.root.RightArm:setVisible(context == "FIRST_PERSON" and not player:isFlying())

    -- wings
    models.model.root.harpy.torso.leftWing.leftWingClose:setVisible(not player:isFlying())
    models.model.root.harpy.torso.rightWing.rightWingClose:setVisible(not player:isFlying())
    models.model.root.harpy.torso.leftWing.leftWingOpen:setVisible(player:isFlying())
    models.model.root.harpy.torso.rightWing.rightWingOpen:setVisible(player:isFlying())
end
