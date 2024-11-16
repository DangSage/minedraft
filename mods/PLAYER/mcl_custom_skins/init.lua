if not minetest.global_exists("mcl_skins") or not mcl_skins.register_simple_skin then
	core.log("warning", "[mcl_custom_skins] mcl_skins.register_simple_skin() does not exist. Most likely MineClone needs to be updated.")
	return
end
mcl_custom_skins = {}

function mcl_custom_skins.read_skins(basedir)
	local dir_list = core.get_dir_list(basedir, true)
	if not dir_list or table.indexof(dir_list, "meta") == -1 or table.indexof(dir_list, "textures") == -1 then
		return
	end
	local textures = core.get_dir_list(basedir .. "/textures")
	table.sort(textures)
	for i, texture in pairs(textures) do
		if texture:find(".png$") then
			local f = io.open(basedir .. "/meta/" .. texture:gsub("png$", "txt"))
			local slim_arms
			if f then
				local data = f:read("*all")
				if data then
					data = core.deserialize("return {" .. data .. "}")
					if data then
						slim_arms = data.gender == "female"
					end
				end
				f:close()
			end
			mcl_skins.register_simple_skin({
				texture = texture,
				slim_arms = slim_arms,
			})
		end
	end
end

mcl_custom_skins.read_skins(core.get_modpath("mcl_custom_skins"))
