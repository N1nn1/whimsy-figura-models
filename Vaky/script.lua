-- Auto generated script file --

vanilla_model.PLAYER:setVisible(false)
vanilla_model.ARMOR:setVisible(true)
vanilla_model.CAPE:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)

swing = require("swingingPhysics")
local squapi = require("SquAPI")
local anims = require("JimmyAnims")
local Jumpstart = require("Jumpstart")
anims(animations.model)

squapi.smoothHead:new(models.model.root.harpy.torso.Head, 0.75, 0.05 ,1 , true)
squapi.smoothHead:new(models.model.root.harpy.torso, 0.25, 0.05 ,1 , false)


function events.render(delta, context)
    animations.model.helmet:play()

    models.model.root.LeftArm:setVisible(context == "FIRST_PERSON")
    models.model.root.RightArm:setVisible(context == "FIRST_PERSON")

    models.model.root.harpy.torso.leftWing.leftWingClose:setVisible(not player:isFlying() and not player:isGliding())
    models.model.root.harpy.torso.rightWing.rightWingClose:setVisible(not player:isFlying() and not player:isGliding())
    models.model.root.harpy.torso.leftWing.leftWingOpen:setVisible(player:isFlying() or player:isGliding())
    models.model.root.harpy.torso.rightWing.rightWingOpen:setVisible(player:isFlying() or player:isGliding())
end
