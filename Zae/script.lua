-- Auto generated script file --

--hide vanilla model
vanilla_model.PLAYER:setVisible(false)
vanilla_model.CAPE:setVisible(false)

swing = require("swingingPhysics")
local squapi = require("SquAPI")
local anims = require("JimmyAnims")
local Jumpstart = require("Jumpstart")
anims(animations.model)

squapi.smoothHead:new(models.model.root.torso.Head, 0.75, 0.05 ,1 , true)
squapi.smoothHead:new(models.model.root.torso, 0.25, 0.05 ,1 , false)

swing.body(models.model.root.torso.tail, 360, {0, 0, 0, 90, -30, 30})


function events.render(delta, context)
    animations.model.armor:play()
    
    models.model.root.LeftArm:setVisible(context == "FIRST_PERSON")
    models.model.root.RightArm:setVisible(context == "FIRST_PERSON")
end