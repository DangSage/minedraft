local S = minetest.get_translator("mcl_fences")

mcl_fences = {}

-- Node box
local p = { -0.125, -0.5, -0.125, 0.125, 0.5, 0.125 }
local x1 = { -0.5, 0.25, -0.0625, -0.125, 0.4375, 0.0625 }
local x12 = { -0.5, -0.125, -0.0625, -0.125, 0.0625, 0.0625 }
local x2 = { 0.125, 0.25, -0.0625, 0.5, 0.4375, 0.0625 }
local x22 = { 0.125, -0.125, -0.0625, 0.5, 0.0625, 0.0625 }
local z1 = { -0.0625, 0.25, -0.5, 0.0625, 0.4375, -0.125 }
local z12 = { -0.0625, -0.125, -0.5, 0.0625, 0.0625, -0.125 }
local z2 = { -0.0625, 0.25, 0.125, 0.0625, 0.4375, 0.5 }
local z22 = { -0.0625, -0.125, 0.125, 0.0625, 0.0625, 0.5 }

-- Collision box
local cp = { -0.125, -0.5, -0.125, 0.125, 1.01, 0.125 }
local cx1 = { -0.5, -0.5, -0.125, -0.125, 1.01, 0.125 }
local cx2 = { 0.125, -0.5, -0.125, 0.5, 1.01, 0.125 }
local cz1 = { -0.125, -0.5, -0.5, 0.125, 1.01, -0.125 }
local cz2 = { -0.125, -0.5, 0.125, 0.125, 1.01, 0.5 }

local on_rotate
if minetest.get_modpath("screwdriver") then
    on_rotate = screwdriver.rotate_simple
end

local function update_gate(pos, node)
    if node.name:sub(-5) == "_open" then
        node.name = node.name:gsub("_open", "")
    else
        node.name = node.name.."_open"
    end
    minetest.set_node(pos, node)
end

local function play_sound(pos, node, state)
    local sounddefs = {}
    local defs = minetest.registered_nodes[node.name]
    if defs and defs._mcl_fences_sounds then
        sounddefs = defs._mcl_fences_sounds[state]
    end
    local spec = sounddefs.spec or ("doors_fencegate_"..state)
    local gain = sounddefs.gain or 0.3
    minetest.sound_play(spec, { gain = gain, max_hear_distance = 16, pos = pos }, true)
end

local function punch_gate(pos, node)
    local meta = minetest.get_meta(pos)
    local state = meta:get_int("state")
    if state == 1 then
        state = 0
        play_sound(pos, node, "close")
    else
        state = 1
        play_sound(pos, node, "open")
    end
    update_gate(pos, node)
    meta:set_int("state", state)
end

local function handle_textures(definitions)
    local base_item = minetest.registered_nodes[definitions._mcl_fences_baseitem]
    if base_item and base_item.tiles then
        local texture = base_item.tiles[1]
        definitions.tiles = { texture }
        definitions.inventory_image = nil
        definitions.wield_image = nil
		definitions.wield_scale = { x = 1, y = 1, z = 1 }
    end
end

local tpl_fences = {
    _doc_items_longdesc = S("Fences are structures which block the way. Fences will connect to each other and solid blocks. They cannot be jumped over with a simple jump."),
    paramtype = "light",
    is_ground_content = false,
    connect_sides = { "front", "back", "left", "right" },
    sunlight_propagates = true,
    drawtype = "nodebox",
    node_box = {
        type = "connected",
        fixed = { p },
        connect_front = { z1, z12 },
        connect_back = { z2, z22 },
        connect_left = { x1, x12 },
        connect_right = { x2, x22 }
    },
    collision_box = {
        type = "connected",
        fixed = { cp },
        connect_front = { cz1 },
        connect_back = { cz2 },
        connect_left = { cx1 },
        connect_right = { cx2 }
    }
}

local tpl_fence_gates = {
    _tt_help = S("Openable by players and redstone power"),
    _doc_items_longdesc = S("Fence gates can be opened or closed and can't be jumped over. Fences will connect nicely to fence gates."),
    _doc_items_usagehelp = S("Right-click the fence gate to open or close it."),
    paramtype = "light",
    is_ground_content = false,
    paramtype2 = "facedir",
    sunlight_propagates = true,
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {
            { -0.5, -0.1875, -0.0625, -0.375, 0.5, 0.0625 },
            { 0.375, -0.1875, -0.0625, 0.5, 0.5, 0.0625 },
            { -0.125, -0.125, -0.0625, 0, 0.4375, 0.0625 },
            { 0, -0.125, -0.0625, 0.125, 0.4375, 0.0625 },
            { -0.5, 0.25, -0.0625, -0.125, 0.4375, 0.0625 },
            { -0.5, -0.125, -0.0625, -0.125, 0.0625, 0.0625 },
            { 0.125, 0.25, -0.0625, 0.5, 0.4375, 0.0625 },
            { 0.125, -0.125, -0.0625, 0.5, 0.0625, 0.0625 }
        }
    },
    collision_box = {
        type = "fixed",
        fixed = {{ -0.5, -0.1875, -0.125, 0.5, 1, 0.125 }}
    },
    selection_box = {
        type = "fixed",
        fixed = {{ -0.5, -0.1875, -0.0625, 0.5, 0.5, 0.0625 }}
    },
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_int("state", 0)
    end,
    mesecons = {effector = {
        action_on = (function(pos, node)
            punch_gate(pos, node)
        end),
    }},
    on_rotate = on_rotate,
    on_rightclick = function(pos, node, _)
        punch_gate(pos, node)
    end,
    _on_wind_charge_hit = function(pos)
        local node = minetest.get_node(pos)
            punch_gate(pos, node)
        return true
    end
}

local tpl_fence_gates_open = {
    paramtype = "light",
    paramtype2 = "facedir",
    is_ground_content = false,
    sunlight_propagates = true,
    walkable = false,
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {
            { -0.5, -0.1875, -0.0625, -0.375, 0.5, 0.0625 },
            { 0.375, -0.1875, -0.0625, 0.5, 0.5, 0.0625 },
            { -0.5, 0.25, 0.0625, -0.375, 0.4375, 0.375 },
            { -0.5, -0.125, 0.0625, -0.375, 0.0625, 0.375 },
            { 0.375, 0.25, 0.0625, 0.5, 0.4375, 0.5 },
            { 0.375, -0.125, 0.0625, 0.5, 0.0625, 0.5 },
            { -0.5, -0.125, 0.375, -0.375, 0.4375, 0.5 },
            { 0.375, 0.0625, 0.5, 0.5, 0.25, 0.375 }
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {{ -0.5, -0.1875, -0.0625, 0.5, 0.5, 0.0625 }}
    },
    on_rightclick = function(pos, node, _)
        punch_gate(pos, node)
    end,
    mesecons = {effector = {
        action_off = (function(pos, node)
            punch_gate(pos, node)
        end),
    }},
    on_rotate = on_rotate,
    _on_wind_charge_hit = function(pos)
        local node = minetest.get_node(pos)
            punch_gate(pos, node)
        return true
    end
}

function mcl_fences.register_fence_def(name, definitions)
    local fence_name = "mcl_fences:"..name
    if not definitions.groups then definitions.groups = {} end
    definitions.groups.fence = 1
    definitions.groups.deco_block = 1
    if not definitions.connects_to then
        definitions.connects_to = { fence_name, "group:fence", "group:fence_gate", "group:solid" }
    end
    handle_textures(definitions)
    definitions.wield_scale = { x = 1, y = 1, z = 1 } -- Adjust the scale if necessary
    minetest.register_node(":"..fence_name, table.merge(tpl_fences, definitions))
    if definitions._mcl_fences_baseitem then
        local stick = "mcl_core:stick"
        local material = definitions._mcl_fences_baseitem
        local amount = definitions._mcl_fences_output_amount or 3
        if definitions._mcl_fences_stickreplacer then
            stick = definitions._mcl_fences_stickreplacer
        end
        minetest.register_craft({
            output = fence_name.." "..tostring(amount),
            recipe = {
                { material, stick, material },
                { material, stick, material }
            }
        })
    end
    return fence_name
end

function mcl_fences.register_fence_gate_def(name, definitions)
    local fence_gate_name = "mcl_fences:"..name.."_gate"
    local fence_gate_name_open = fence_gate_name.."_open"

    if not definitions.groups then definitions.groups = {} end

    definitions.groups.fence_gate = 1
    definitions.groups.deco_block = 1

    handle_textures(definitions)

    minetest.register_node(":"..fence_gate_name, table.merge(tpl_fence_gates, definitions))

    local opendefinitions = table.copy(definitions)
    opendefinitions.description = nil
    opendefinitions.inventory_image = nil
    opendefinitions.wield_image = nil
    opendefinitions._mcl_burntime = nil

    opendefinitions.groups.not_in_creative_inventory = 1
    opendefinitions.mesecon_ignore_opaque_dig = 1
    opendefinitions.mesecon_effector_on = 1

    minetest.register_node(":"..fence_gate_name_open, table.merge(tpl_fence_gates_open, {
        drop = fence_gate_name
    }, opendefinitions))

    if definitions._mcl_fences_baseitem then
        local stick = "mcl_core:stick"
        local material = definitions._mcl_fences_baseitem
        local amount = definitions._mcl_fences_output_amount or 1

        if definitions._mcl_fences_stickreplacer then
            stick = definitions._mcl_fences_stickreplacer
        end

        minetest.register_craft({
            output = fence_gate_name.." "..tostring(amount),
            recipe = {
                { stick, material, stick },
                { stick, material, stick }
            }
        })
    end

    if minetest.get_modpath("doc") then
        doc.add_entry_alias("nodes", fence_gate_name, "nodes", fence_gate_name_open)
    end

    return fence_gate_name, fence_gate_name_open
end

function mcl_fences.register_fence_and_fence_gate_def(name, commondefs, fencedefs, gatedefs)
    local fence, gate, gate_open

    fence = mcl_fences.register_fence_def(name, table.merge(commondefs, fencedefs))
    gate, gate_open = mcl_fences.register_fence_gate_def(name, table.merge(commondefs, gatedefs))

    return fence, gate, gate_open
end

-- Support for old definitions

function mcl_fences.register_fence(id, fence_name, texture, groups, hardness, blast_resistance, connects_to, sounds, burntime, baseitem, stickreplacer)
    return mcl_fences.register_fence_def(id, {
        description = fence_name,
        tiles = { texture },
        groups = groups,
        _mcl_blast_resistance = blast_resistance,
        _mcl_hardness = hardness,
        connects_to = connects_to,
        sounds = sounds,
        _mcl_burntime = burntime,
        _mcl_fences_baseitem = baseitem,
        _mcl_fences_stickreplacer = stickreplacer
    })
end

function mcl_fences.register_fence_gate(id, fence_gate_name, texture, groups, hardness, blast_resistance, sounds, sound_open, sound_close, sound_gain_open, sound_gain_close, burntime, baseitem, stickreplacer)
    return mcl_fences.register_fence_gate_def(id, {
        description = fence_gate_name,
        tiles = { texture },
        groups = groups,
        _mcl_blast_resistance = blast_resistance,
        _mcl_hardness = hardness,
        sounds = sounds,
        _mcl_burntime = burntime,
        _mcl_fences_sounds = {
            open = {
                spec = sound_open,
                gain = sound_gain_open
            },
            close = {
                spec = sound_close,
                gain = sound_gain_close
            }
        },
        _mcl_fences_baseitem = baseitem,
        _mcl_fences_stickreplacer = stickreplacer
    })
end

function mcl_fences.register_fence_and_fence_gate(id, fence_name, fence_gate_name, texture_fence, groups, hardness, blast_resistance, connects_to, sounds, sound_open, sound_close, sound_gain_open, sound_gain_close, texture_fence_gate)
    if texture_fence_gate == nil then
        texture_fence_gate = texture_fence
    end
    local fence_id = mcl_fences.register_fence(id, fence_name, texture_fence, groups, hardness, blast_resistance, connects_to, sounds)
    local gate_id, open_gate_id = mcl_fences.register_fence_gate(id, fence_gate_name, texture_fence_gate, groups, hardness, blast_resistance, sounds, sound_open, sound_close, sound_gain_open, sound_gain_close)
    return fence_id, gate_id, open_gate_id
end