
vanilla_model.PLAYER:setVisible(false)
vanilla_model.ARMOR:setVisible(false)
vanilla_model.HELMET_ITEM:setVisible(true)
vanilla_model.HELMET:setVisible(true)
vanilla_model.BOOTS:setVisible(true)
vanilla_model.CHESTPLATE:setVisible(true)
vanilla_model.CAPE:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)

swing = require("swingingPhysics")
local squapi = require("SquAPI")
local anims = require("JimmyAnims")
local Jumpstart = require("Jumpstart")
anims(animations.model)

squapi.smoothHead:new(models.model.root.torso.Head, 0.75, 0.05 ,1 , true)
squapi.smoothHead:new(models.model.root.torso, 0.25, 0.05 ,1 , false)

function events.render(delta, context)
    animations.model.modifiers:play()

    models.model.LeftArm2:setVisible(context == "FIRST_PERSON")
    models.model.RightArm2:setVisible(context == "FIRST_PERSON")
    models.model.root.torso.LeftArm:setVisible(context ~= "FIRST_PERSON")
    models.model.root.torso.RightArm:setVisible(context ~= "FIRST_PERSON")
end
