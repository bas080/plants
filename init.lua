-- Must have
--Growing abm for soil. checking if water nearby and if crop is ontop.

--Grow in different terrains for example
--cliffs
--near water
--in open fields far from trees
--in dessert environtments
--beneath trees
--next to stone
--near sand
--near dessert
--in dessert?

--Should do
--Function which gives possibilty to add crops

--A simple farming mod

--mod name

--variable and function definitions
local mod_name = "harvest"

local mod_update = 4 --amount of seconds between growing plants on dirt

local crop_names = {
	"cotton",
	"potato",
	"wheat",
	"corn",
	"lavender",
	"weed",
}

local crop_phases = {
    "seedling",
    "sapling",
    "plant",
    "harvest",
    "wild"
}

local grow_surfaces = {
    "default:dirt",
    "default:dirt_with_grass"
}

local wild_crops = {}
local wild_crop_count = 1

local name = 1
local phase = 1

local node_name
local node_tile

local is_node_in_cube = function(nodenames, node_pos, radius)

    local name = 1

    repeat
        if minetest.env:find_node_near(node_pos, radius, nodenames[name]) ~= nil then
            return true
        end
        name = name + 1
    until nodenames[name] == nil
    
    return false
end

local add_farm_plant = function(name_plant, spacing, spawning, grow_nodes, near_nodes, near_distance, growing_speed) --register a farming plant
    
    local name = mod_name..":"..name_plant
    local img = mod_name.."_"..name_plant
    
    minetest.register_node(name.."_wild", {--register wild plant
        tile_images = {img.."_wild.png"},
        drawtype = "plantlike",
        paramtype = "light",
        sunlight_propagates = true,
        walkable = false,
        groups = { snappy = 3},
        drop = { items = { name.."_seedling"},
		    max_items = 1,
		    items = {
			    {
				    items = {name.."_seedling"},
				    rarity = 30,
			    },
		    }
	    },
    })
    
    minetest.register_node(name.."_seedling", {--register seedling
        tile_images = {img.."_seedling.png"},
        wield_image = img.."_seeds.png",
        inventory_image = img.."_seeds.png",
        drawtype = "plantlike",
        paramtype = "light",
        sunlight_propagates = true,
        walkable = false,
        groups = { snappy = 3},
        drop = "",
    })
    
    minetest.register_node(name.."_sapling", {--register sapling
        tile_images = {img.."_sapling.png"},
        drawtype = "plantlike",
        paramtype = "light",
        sunlight_propagates = true,
        walkable = false,
        groups = { snappy = 3},
        drop = "",
    })
    
    minetest.register_node(name.."_plant", {--register plant
        tile_images = {img.."_plant.png"},
        drawtype = "plantlike",
        paramtype = "light",
        sunlight_propagates = true,
        walkable = false,
        groups = { snappy = 3},
        drop = "",
    })
    
    minetest.register_node(name.."_harvest", {--register plant
        tile_images = {img.."_harvest.png"},
        drawtype = "plantlike",
        paramtype = "light",
        sunlight_propagates = true,
        walkable = false,
        groups = { snappy = 3},
        drop = "",
    })
    
    minetest.register_abm({
        nodenames = grow_nodes,
        interval = mod_update,
        chance = spawning,
        action = function(pos, node)
            local p = {x=pos.x, y=pos.y+1, z=pos.z}
            local n = minetest.env:get_node(p)

            if n.name == "air" then
                if is_node_in_cube(near_nodes, pos, near_distance) and is_node_in_cube({name.."_wild"}, pos, spacing)==false then
		            minetest.env:add_node(p, {name=name.."_wild"})
		        end
		    end
            
        end
    })
    
end

local add_plant = function(name_plant, spacing, spawning, grow_nodes, near_nodes, near_distance) -- register a wild plant

    local name = mod_name..":"..name_plant
    local img = mod_name.."_"..name_plant

    minetest.register_node(name.."_wild", {--register wild plant
        tile_images = {img.."_wild.png"},
        drawtype = "plantlike",
        inventory_image = "",
        paramtype = "light",
        sunlight_propagates = true,
        walkable = false,
        groups = { snappy = 3},
        drop = "",
    })
    
    minetest.register_abm({
        nodenames = grow_nodes,
        interval = mod_update,
        chance = spawning,
        action = function(pos, node)
            local p = {x=pos.x, y=pos.y+1, z=pos.z}
            local n = minetest.env:get_node(p)

            if n.name == "air" then
                if is_node_in_cube(near_nodes, pos, near_distance) and is_node_in_cube({name.."_wild"}, pos, spacing)==false then
		            minetest.env:add_node(p, {name=name.."_wild"})
		        end
		    end
            
        end
    })
end

--plant registration
--Just wild plant

--node registration



--make tools with which dirt can be prepared for growing
minetest.register_tool(mod_name..":hoe_wood", {
	description = "Sickle",
	inventory_image = "harvest_hoe_wood.png",
	
	on_use = function(itemstack, user, pointed_thing)
        
        -- Must be pointing to node
		if pointed_thing.type ~= "node" then
			return
		end
		-- Check if pointing to dirt or dirt_with_grass
		n = minetest.env:get_node(pointed_thing.under)
		
		if n.name == "default:dirt" or n.name == "default:dirt_with_grass" then
		    minetest.env:add_node(pointed_thing.under, {name=mod_name..":soil"})
		end
        
        
	end,
})

--Make node in which dirt changes after hoe preperation
minetest.register_node(mod_name..":soil", {
	description = "Soil",
	tile_images = {"harvest_soil.png", "default_dirt.png"},
	groups = {crumbly=3},
	drop = 'default:dirt',
	after_dig_node = function(pos)
	    
	end,
})

--ABM's for placing wild versions of the plant on dirt tiles
function test()


repeat
    phase = 1
    node_name = mod_name..":"..crop_names[name].."_"..crop_phases[phase]
    node_tile = mod_name.."_"..crop_names[name].."_"..crop_phases[phase] .. ".png"
minetest.env:find_node_near(p_top, spawnradius, spawnavoid)
    
    minetest.register_node(node_name, {--register seedling
        tile_images = {node_tile},
        description = crop_names[name].." seeds",
        wield_image = "",
        drawtype = "plantlike",
        inventory_image = "",
        paramtype = "light",
        sunlight_propagates = true,
        walkable = false,
        groups = { snappy = 3},
        after_place_node = function(pos, placer)
            p  = {x = pos.x, y= pos.y-1, z=pos.z}
            n = minetest.env:get_node(p)
            if n.name ~= "harvest:soil" then
                minetest.env:remove_node(pos)
            end
        end,
    })
    
    phase = phase + 1
    node_name = mod_name..":"..crop_names[name].."_"..crop_phases[phase]
    node_tile = mod_name.."_"..crop_names[name].."_"..crop_phases[phase] .. ".png"

    minetest.register_node(node_name, {
        description = crop_names[name].." "..crop_phases[phase],
        wield_image = "",
        drawtype = "plantlike",
        inventory_image = "",
        tile_images = {node_tile},
        paramtype = "light",
        groups = { snappy = 3},
        sunlight_propagates = true,
        walkable = false,
    })
    
    phase = phase + 1
    node_name = mod_name..":"..crop_names[name].."_"..crop_phases[phase]
    node_tile = mod_name.."_"..crop_names[name].."_"..crop_phases[phase] .. ".png"
    minetest.register_node(node_name, {
        description = crop_names[name].." "..crop_phases[phase],
        wield_image = "",
        drawtype = "plantlike",
        inventory_image = "",
        tile_images = {node_tile},
        paramtype = "light",
        groups = { snappy = 3},
        sunlight_propagates = true,
        walkable = false,
    })
    
    phase = phase + 1
    node_name = mod_name..":"..crop_names[name].."_"..crop_phases[phase]
    node_tile = mod_name.."_"..crop_names[name].."_"..crop_phases[phase] .. ".png"

    minetest.register_node(node_name, {
        description = crop_names[name].." "..crop_phases[phase],
        wield_image = "",
        drawtype = "plantlike",
        inventory_image = "",
        tile_images = {node_tile},
        paramtype = "light",
        groups = { snappy = 3},
        sunlight_propagates = true,
        walkable = false,
    })
    
    phase = phase + 1 --wild
    node_name = mod_name..":"..crop_names[name].."_"..crop_phases[phase]
    node_tile = mod_name.."_"..crop_names[name].."_"..crop_phases[phase] .. ".png"

    
    minetest.register_node(node_name, {
        description = crop_names[name].." "..crop_phases[phase],
        wield_image = "",
        drawtype = "plantlike",
        inventory_image = "",
        tile_images = {node_tile},
        paramtype = "light",
        groups = { snappy = 3},
        sunlight_propagates = true,
        walkable = false,
        drop = { items = { mod_name..":"..crop_names[name].."_seedling"},
		    max_items = 1,
		    items = {
			    {
				    items = {mod_name..":"..crop_names[name].."_seedling"},
				    rarity = 30,
			    },
		    }
	    },
    })
    
    --end of node registration continue the looping for other types of crops
    
    wild_crops[wild_crop_count] = node_name
    wild_crop_count = wild_crop_count + 1
    
    name = name + 1
until crop_names[name] == nil


    minetest.register_abm({
        nodenames = {"default:dirt_with_grass"},
        interval = mod_update,
        chance = 10,
        action = function(pos, node)
        
            local p = {x=pos.x, y=pos.y+1, z=pos.z}
            local n = minetest.env:get_node(p)

            if n.name == "air" then
                if is_node_in_cube({"default:stone"}, pos, 1) then
		            minetest.env:add_node(p, {name = wild_crops[math.floor(math.random((wild_crop_count-1)))]})
		        end
		    end
            
        end
    })
end

--test()
add_farm_plant("cotton", 4, 40, {"default:dirt_with_grass"}, {"default:desert_sand"}, 5)
add_farm_plant("corn", 4, 50, {"default:dirt_with_grass"}, {"default:water_source"}, 3,10)
add_plant("lavender", 1, 5, {"default:dirt_with_grass"}, {"default:sand"}, 2)

print("[Harvest] Loaded!")


