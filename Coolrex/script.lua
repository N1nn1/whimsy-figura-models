-- Auto generated script file --

vanilla_model.PLAYER:setVisible(false)
vanilla_model.ARMOR:setVisible(false)
vanilla_model.HELMET:setVisible(true)
vanilla_model.HELMET_ITEM:setVisible(true)
vanilla_model.CAPE:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)

swing = require("swingingPhysics")
local squapi = require("SquAPI")
local anims = require("JimmyAnims")
local Jumpstart = require("Jumpstart")

anims(animations.model)

squapi.randimation:new(animations.model.shake, 2400, true)
squapi.randimation:new(animations.model.sniff, 400, true)

squapi.smoothHead:new(models.model.root.wolf.torso.mane.Head, 0.75, 0.05 ,1 , true)
squapi.smoothHead:new(models.model.root.wolf.torso, 0.25, 0.05 ,1 , false)

squapi.ear:new(
    models.model.root.wolf.torso.mane.Head.leftEar,
    models.model.root.wolf.torso.mane.Head.rightEar,
    1, true, 2, true, 400, 0.1, 0.8
)

function events.render(delta, context)
    -- armor modifiers
    animations.model.armor:play()

    
    -- custom arm
    models.model.root.LeftArm:setVisible(context == "FIRST_PERSON")
    models.model.root.RightArm:setVisible(context == "FIRST_PERSON")
end
