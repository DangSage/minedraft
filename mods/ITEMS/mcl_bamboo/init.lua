mcl_bamboo = {}
local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)
local S = minetest.get_translator("mcl_bamboo")

dofile(modpath .. "/nodes.lua")
dofile(modpath .. "/recipes.lua")

mcl_util.generate_on_place_plant_function(function(pos)
	local node_below = minetest.get_node(vector.offset(pos,0,-1,0))
	return minetest.get_item_group(node_below.name, "soil_bamboo") > 0
end)

mcl_trees.register_wood("bamboo",{
	readable_name = S("Bamboo"),
	sign_color="#FCE6BC",
	sapling = false,
	potted_sapling = false,
	leaves = false,
	tree = { tiles = {"mcl_bamboo_bamboo_bottom.png", "mcl_bamboo_bamboo_bottom.png","mcl_bamboo_bamboo_block.png" }},
	stripped = { tiles = {"mcl_bamboo_bamboo_bottom_stripped.png", "mcl_bamboo_bamboo_bottom_stripped.png","mcl_bamboo_bamboo_block_stripped.png" }},
	bark = { tiles = {"mcl_bamboo_bamboo_block.png"}},
	wood = { tiles = {"mcl_bamboo_bamboo_plank.png"}},
	stripped_bark = { tiles = {"mcl_bamboo_bamboo_block_stripped.png"} },
	fence = { tiles = { "mcl_bamboo_fence_bamboo.png" },},
	fence_gate = { tiles = { "mcl_bamboo_fence_gate_bamboo.png" }, },
	door = {
		inventory_image = "mcl_bamboo_door_wield.png",
		tiles_bottom = {"mcl_bamboo_door_bottom.png","mcl_bamboo_door_bottom.png"},
		tiles_top = {"mcl_bamboo_door_top.png","mcl_bamboo_door_bottom.png"},
	},
	trapdoor = {
		tile_front = "mcl_bamboo_bamboo_trapdoor.png",
		tile_side = "mcl_bamboo_bamboo_trapdoor.png",
		wield_image = "mcl_bamboo_bamboo_trapdoor.png",
	},
	boat = {
		item = {
			description = S("Bamboo Raft"),
		},
		object = {
			collisionbox = {-0.5, -0.15, -0.5, 0.5, 0.25, 0.5},
			selectionbox = {-0.7, -0.15, -0.7, 0.7, 0.25, 0.7},
		},
	}, --needs different model
	chest_boat = {
		item = {
			description = S("Chest Bamboo Raft"),
		},
		object = {
			collisionbox = {-0.5, -0.15, -0.5, 0.5, 0.25, 0.5},
			selectionbox = {-0.7, -0.15, -0.7, 0.7, 0.25, 0.7},
		},
	},
})

minetest.register_abm({
	label = "Bamboo growth",
	nodenames = {"group:bamboo_tree"},
	neighbors = {"group:soil_sapling","group:soil_bamboo"},
	interval = 15,
	chance = 10,
	action = function(pos,node)
		mcl_bamboo.grow(pos)
	end,
})
