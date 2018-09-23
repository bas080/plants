local mod_name = "plants"
local name
local img

plants = {}

plants.default_node_def = {--register wild plant
  tiles = {img},
  inventory_image = img,
  description = "A plant",
  drop = nil,
  drawtype = "plantlike",
  paramtype = 'light',
  sunlight_propagates = true,
  buildable_to = true,
  walkable = false,
  visual_scale = 1.3,
  groups = { snappy = 3,flammable=2, attached_node=1},
  sounds = default.node_sound_leaves_defaults(),
  selection_box = {
    type = "fixed",
    fixed = { -0.25, -0.5, -0.25, 0.25, -3/16, 0.25 },
  }
}

plants.register_plant = function(def)
  print("Plant register: "..def.name)
end

local add_plant = function(name_plant, drop) -- register a wild plant
  local name = mod_name..":"..name_plant
  local img = mod_name.."_"..name_plant.."_wild.png"
  local drops
  if drop ~= nil then
    drops = {}
    drops.max_items = drop.max_items
    drops.items = {}
    local item
    local default
    for _, item in ipairs(drop.items) do
      if item == "default" then
	default = { items = {name.."_wild"}}
      else
	-- verify if requested nodes exist. If not, don't use them
	local node
	local nodelist = {}
	for _, node in ipairs(item.items) do
	  if minetest.registered_nodes[node] then
	    table.insert(nodelist, node)
	  end
	end
	if next(nodelist) ~= nil then
	  item.items = nodelist
	  table.insert(drops.items, item)
	end
      end
    end
    -- Don't know whether this is necessary, but put the default at the end
    if default then
      table.insert(drops.items, default)
    end
  end
  minetest.register_node(name.."_wild", {--register wild plant
    tiles = {img},
    inventory_image = img,
    description = name_plant,
    drop = drops,
    drawtype = "plantlike",
    paramtype = 'light',
    sunlight_propagates = true,
    walkable = false,
    buildable_to = true,
    visual_scale = 1.3,
    groups = { snappy = 3,flammable=2, attached_node=1},
    sounds = default.node_sound_leaves_defaults(),
    selection_box = {
      type = "fixed",
      fixed = { -0.25, -0.5, -0.25, 0.25, -3/16, 0.25 },
    },
    after_dig_node = function(pos, node, meta, digger)
      --if wielding a shovel, don't regenerate
      if nil == string.find(digger:get_wielded_item():get_name(), ":shovel_") then
	--regenerate plant only if exact location is not compromized
	local on = minetest.env:get_node({x=pos.x,y=pos.y-1,z=pos.z}).name
	minetest.after(5, function()
	  print("Dig plant: trying to regenerate")
	  local n = minetest.env:get_node({x=pos.x,y=pos.y,z=pos.z}).name
	  local b = minetest.env:get_node({x=pos.x,y=pos.y-1,z=pos.z}).name
	  if (n == "air" and b ~= "air" and b == on) then
	    minetest.env:add_node(pos, node)
	  end
	end)
      end
    end,
  })
end

add_plant("aloe")
add_plant("cotton",{max_items = 1,items = {"default", { items = {'farming:seed_cotton'}, rarity = 10}, { items = {'farming:cotton_seed'}, rarity = 10}}})
add_plant("corn")
add_plant("lavender")
add_plant("potato")
add_plant("redshroom")
add_plant("cacao")
add_plant("brownshroom")
add_plant("chamomile")
add_plant("colchicum")
add_plant("poppy")
add_plant("grasstall",{max_items = 1,items = {"default", { items = {'farming:seed_wheat'}, rarity = 40}, { items = {'farming:wheat_seed'}, rarity = 40}}})
add_plant("grass",{max_items = 1,items = {"default", { items = {'farming:seed_wheat'}, rarity = 60}, { items = {'farming:wheat_seed'}, rarity = 40}}})

name_plant = "glowshroom"
name = mod_name..":"..name_plant.."_wild"
img = mod_name.."_"..name_plant.."_wild.png"
minetest.register_node(name, {
  tiles = {img},
  inventory_image = img,
  description = name_plant,
  drop = {max_items = 1,items = {{ items = {name}}}},
  drawtype = "plantlike",
  paramtype = 'light',
  sunlight_propagates = true,
  buildable_to = true,
  walkable = false,
  visual_scale = 1.3,
  light_source = 11,
  groups = { snappy = 3,flammable=2, attached_node=1},
  sounds = default.node_sound_leaves_defaults(),
  selection_box = {
    type = "fixed",
    fixed = { -0.25, -0.5, -0.25, 0.25, -3/16, 0.25 },
  },
})

name_plant = "lavashroom"
name = mod_name..":"..name_plant.."_wild"
img = mod_name.."_"..name_plant.."_wild.png"
minetest.register_node(name, {
  tiles = {img},
  inventory_image = img,
  description = name_plant,
  drop = {max_items = 1,items = {{ items = {name}}}},
  drawtype = "plantlike",
  paramtype = 'light',
  sunlight_propagates = true,
  buildable_to = true,
  walkable = false,
  light_source = 7,
  visual_scale = 1.3,
  groups = { snappy = 3,flammable=2, attached_node=1},
  sounds = default.node_sound_leaves_defaults(),
  selection_box = {
    type = "fixed",
    fixed = { -0.25, -0.5, -0.25, 0.25, -3/16, 0.25 },
  },
})

--plants
habitat:generate("plants:lavender_wild", "default:dirt_with_grass", nil, nil, 2, 60, 4, 4, {"default:sand"},0,{""})
habitat:generate("plants:corn_wild", "default:dirt_with_grass", nil, nil, 2, 60, 8, 10, {"default:water_source"},0,{""})
habitat:generate("plants:cotton_wild", "default:dirt_with_grass", nil, nil, 2, 60, 8, 10, {"default:desert_sand"},0,{""})
habitat:generate("plants:aloe_wild", "default:desert_sand", nil, nil, 5, 40, 12, 20, {"default:water_source", "default:cactus", "default:dirt_with_grass"},0,{""})
habitat:generate("plants:potato_wild", "default:dirt_with_grass", nil, nil, 20, 90, 20, 2, {"default:dirt_with_grass"},30,{"default:junglegrass", "default:jungletree"})
habitat:generate("plants:cacao_wild", "default:dirt_with_grass", nil, nil, 20, 90, 8, 20, {"default:desert_sand"},0,{""})
habitat:generate("plants:grasstall_wild", "default:dirt_with_grass", nil, nil, 2, 20, 3, 20, {"default:water_source"},0,{""})
habitat:generate("plants:grass_wild", "default:dirt_with_grass", nil, nil, 2, 20, 3, 40, {"default:water_source"},0,{""})

--flowers
habitat:generate("plants:chamomile_wild", "default:dirt_with_grass", nil, nil, 2, 40, 8, 4, {"default:stone_with_coal"},0,{""})
habitat:generate("plants:colchicum_wild", "default:dirt_with_grass", nil, nil, 2, 40, 4, 4, {"default:stone_with_iron"},0,{""})
habitat:generate("plants:poppy_wild", "default:desert_sand", nil, nil, 2, 20, 4, 10, {"default:water_source"},0,{""})

--shrooms
habitat:generate("plants:lavashroom_wild", "default:stone", nil, nil, -1000, -130, 5, 10, {"default:lava_source"},0,{""})
habitat:generate("plants:glowshroom_wild", "default:stone", nil, nil, -5, 20, 7, 40, {"default:stone_with_coal"},0,{""})
habitat:generate("plants:redshroom_wild", "default:dirt_with_grass", nil, nil, 2, 60, 20, 8, {"default:leaves"},0,{""})
habitat:generate("plants:brownshroom_wild", "default:stone", nil, nil, -40, 2, 2, 10, {"default:water_source"},0,{""})

print("[Plants] Loaded!")
