-- Auto generated script file --

vanilla_model.PLAYER:setVisible(false)
vanilla_model.CAPE:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)
vanilla_model.BOOTS:setVisible(false)

swing = require("swingingPhysics")
local squapi = require("SquAPI")
local anims = require("JimmyAnims")
local Jumpstart = require("Jumpstart")
anims(animations.model)

squapi.ear:new(
    models.model.root.Head.leftEar,
    models.model.root.Head.rightEar,
    1, true, 2, true, 400, 0.1, 0.8
)

function events.render(delta, context)
    animations.model.armor:play()
end

local myPage = action_wheel:newPage()
action_wheel:setPage(myPage)

local leaves = true

function pings.toggleLeaves()
    leaves = not leaves
  end

  myPage:newAction():title("Toggle Leaves"):item("minecraft:oak_leaves")
  :onLeftClick(function ()
    pings.toggleLeaves()
  end)

local saved_c

function events.entity_init()

if player:isLoaded() then
saved_c = world.getBiome(player:getPos()):getFoliageColor()
end

end

function events.Post_render(dt)

local biome = world.getBiome(player:getPos()):getFoliageColor()

if leaves then
    models.model.root.Body.bodyLeaves.toggleable:setVisible(true)
    models.model.root.Body.bodyLeaves.leaf:setVisible(false)
    models.model.root.Body.LeggingsPivot:setVisible(false)
  else
    models.model.root.Body.bodyLeaves.toggleable:setVisible(false)
    models.model.root.Body.bodyLeaves.leaf:setVisible(true)
    models.model.root.Body.LeggingsPivot:setVisible(true)
  end


models.model.root.Head.headLeaves:setColor(saved_c)
models.model.root.Body.bodyLeaves:setColor(saved_c)
models.model.root.Body.tail.tailLeaves:setColor(saved_c)
models.model.root.RightArm.rightArmLeaves:setColor(saved_c)
models.model.root.LeftArm.leftArmLeaves:setColor(saved_c)

if saved_c ~= biome then
saved_c = math.lerp(saved_c, biome, dt/16)

end

end
