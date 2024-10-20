
vanilla_model.PLAYER:setVisible(false)
vanilla_model.ARMOR:setVisible(false)
vanilla_model.CAPE:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)

swing = require("swingingPhysics")
local squapi = require("SquAPI")
local anims = require("JimmyAnims")
anims(animations.model)


squapi.smoothHead:new(models.model.root.olm.body.neck.neck2.neck3.head, 0.75, 0.05 ,1 , true)
squapi.smoothHead:new(models.model.root.olm.body.neck, 0.25, 0.05 ,1 , false)