-- TODO: Add network support for custom skins

local mod_path = minetest.get_modpath(minetest.get_current_modname())
local skins_path = mod_path .. "/textures/skins/"
local skin_data_file = mod_path .. "/skin_data.txt"

-- Ensure mcl_skins is initialized
if not mcl_skins then
    mcl_skins = {}
end

-- Function to check if a directory exists
local function directory_exists(path)
    local files = minetest.get_dir_list(path, false)
    return files ~= nil
end

-- Check if the directory exists
if not directory_exists(skins_path) then
    minetest.log("error", "[mcl_skins] Custom skins directory does not exist: " .. skins_path)
    return
end

-- Function to load skin data from a file
local function load_skin_data()
    local file = io.open(skin_data_file, "r")
    if not file then
        return {}
    end
    local data = minetest.deserialize(file:read("*a"))
    file:close()
    return data or {}
end

-- Function to save skin data to a file
local function save_skin_data(data)
    local file = io.open(skin_data_file, "w")
    if file then
        file:write(minetest.serialize(data))
        file:close()
    end
end

-- Load existing skin data
local skin_data = load_skin_data()

-- Function to list PNG files in a directory
local function list_png_files(directory)
    minetest.log("action", "[mcl_skins] Listing PNG files in directory: " .. directory)
    local files = minetest.get_dir_list(directory, false)
    local png_files = {}
    for _, file in ipairs(files) do
        if file:match("%.png$") then
            table.insert(png_files, file)
            minetest.log("action", "[mcl_skins] Found PNG file: " .. file)
        end
    end
    return png_files
end

-- Function to see if the skin is a slim skin
local function is_slim_skin(file)
    local slim = file:find("_slim") ~= nil
    return slim
end

local base_index = 1

-- Function to check if a table contains a value
local function table_contains(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end

local png_files = list_png_files(skins_path)

-- Remove entries from skin_data that do not correspond to existing files
for file, _ in pairs(skin_data) do
    if not table_contains(png_files, file) then
        minetest.log("action", "[mcl_skins] Removing non-existent skin file from data: " .. file)
        skin_data[file] = nil
    end
end

-- Register custom skins
for i, file in ipairs(png_files) do
    if not skin_data[file] then
        local uuid = tostring(os.time())
        skin_data[file] = {
            id = uuid,
            slim_arms = is_slim_skin(file),
        }
    end
    local skin_info = skin_data[file]
    if not skin_info.id then
        skin_info.id = tostring(os.time())
    end
    minetest.log("action", "[mcl_skins] Registering skin: " .. file .. " with ID: " .. skin_info.id)
    mcl_skins.register_simple_skin({
        index = base_index + i,
        texture = file,
        slim_arms = skin_info.slim_arms,
    })
    minetest.log("action", "[mcl_skins] Registered " .. (skin_info.slim_arms and "slim" or "regular") .. " skin: " .. file)
end

-- Save updated skin data
save_skin_data(skin_data)

minetest.log("action", "[mcl_skins] Finished registering custom skins.")