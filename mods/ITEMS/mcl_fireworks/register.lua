local S = minetest.get_translator(minetest.get_current_modname())
local description = S("Firework Rocket")

-- Ensure mcl_fireworks table is initialized
mcl_fireworks = mcl_fireworks or {}

-- Load other necessary files
dofile(minetest.get_modpath("mcl_fireworks") .. "/entities.lua")

-- Define the shoot_rocket function
function mcl_fireworks.shoot_rocket(rocket_item, pos, dir, yaw, shooter, power, damage, is_critical, crossbow_stack, collectable)
    local obj = minetest.add_entity({x=pos.x, y=pos.y, z=pos.z}, "mcl_fireworks:rocket_entity")
    if not obj or not obj:get_pos() then return end
    if power == nil then
        power = BOW_MAX_SPEED --19
    end
    if damage == nil then
        damage = 3
    end
    if crossbow_stack then
        local enchantments = mcl_enchanting.get_enchantments(crossbow_stack)
        if enchantments.piercing then
            -- Apply piercing effect
        end
    end
    obj:set_velocity({x=dir.x * power, y=dir.y * power, z=dir.z * power})
    obj:set_acceleration({x=dir.x * -3, y=-10, z=dir.z * -3})
end

-- Define the use_rocket function (assuming it is defined elsewhere in your code)
local function use_rocket(itemstack, user, duration)
    -- Your implementation of use_rocket
    -- Example:
    local elytra = user:get_meta():get("elytra")
    if elytra and elytra.active then
        elytra.rocketing = duration
        if not minetest.is_creative_enabled(user:get_player_name()) then
            itemstack:take_item()
        end
        minetest.sound_play("mcl_fireworks_rocket", {pos = user:get_pos()})
    elseif elytra.active then
        mcl_title.set(user, "actionbar", { text = S("@1s power left. Not using rocket.", string.format("%.1f", elytra.rocketing)), color = "white", stay = 60 })
    elseif minetest.get_item_group(user:get_inventory():get_stack("armor", 3):get_name(), "elytra") ~= 0 then
        mcl_title.set(user, "actionbar", { text = S("Elytra not deployed. Jump while falling down to deploy."), color = "white", stay = 60 })
    else
        mcl_title.set(user, "actionbar", { text = S("Elytra not equipped."), color = "white", stay = 60 })
    end
    return itemstack
end

-- Register rockets
local function register_rocket(n, duration, force)
    minetest.register_craftitem("mcl_fireworks:rocket_" .. n, {
        description = S("Firework Rocket"),
        _tt_help = S("Flight Duration: @1s", string.format("%.1f", duration)),
        inventory_image = "mcl_fireworks_rocket.png",
        on_use = function(itemstack, user, pointed_thing)
            return use_rocket(itemstack, user, duration)
        end,
        on_secondary_use = function(itemstack, user, pointed_thing)
            return use_rocket(itemstack, user, duration)
        end,
    })
end

register_rocket(1, 2.2, 10)
register_rocket(2, 4.5, 20)
register_rocket(3, 6, 30)

-- Register alias for rocket
minetest.register_alias("mcl_bows:rocket", "mcl_fireworks:rocket_2")