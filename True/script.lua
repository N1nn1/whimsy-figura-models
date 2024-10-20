
--vanilla model

vanilla_model.PLAYER:setVisible(false)
vanilla_model.ARMOR:setVisible(false)
vanilla_model.HELMET_ITEM:setVisible(false)
vanilla_model.CAPE:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)

swing = require("swingingPhysics")
local squapi = require("SquAPI")
local anims = require("JimmyAnims")
anims(animations.model)

--swinging animations

squapi.smoothHead:new(models.model.root.torso.neck.head, 0.75, 0.05 ,1 , true)
squapi.smoothHead:new(models.model.root.torso.neck, 0.25, 0.05 ,1 , false)
swing.head(models.model.root.torso.neck.head.trunk, 180, {60, 15, -90, 90, -30, 30})

function events.render(_, context)
    local eyeOffset = 0.7;
    renderer:offsetCameraPivot(0, eyeOffset, 0)
    renderer:setEyeOffset(0, eyeOffset, 0)
end