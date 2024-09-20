minetest.register_entity("mcl_fireworks:rocket_entity", {
    initial_properties = {
        physical = false,
        collide_with_objects = false,
        collisionbox = {0, 0, 0, 0, 0, 0},
        visual = "sprite",
        visual_size = {x = 0.5, y = 0.5},
        textures = {"mcl_fireworks_rocket.png"},
        spritediv = {x = 1, y = 1},
        is_visible = true,
    },
    timer = 0,
    on_step = function(self, dtime)
        self.timer = self.timer + dtime
        if self.timer > 2 then
            -- Explode the rocket
            minetest.add_particlespawner({
                amount = 100,
                time = 0.1,
                minpos = self.object:get_pos(),
                maxpos = self.object:get_pos(),
                minvel = {x = -2, y = -2, z = -2},
                maxvel = {x = 2, y = 2, z = 2},
                minacc = {x = 0, y = 0, z = 0},
                maxacc = {x = 0, y = 0, z = 0},
                minexptime = 1,
                maxexptime = 2,
                minsize = 1,
                maxsize = 2,
                texture = "mcl_fireworks_star.png",
            })
            self.object:remove()
        end
    end,
})