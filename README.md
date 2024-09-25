# Minedraft

Minedraft is an unofficial Minecraft-like game for [Minetest](https://github.com/minetest/minetest), forked from Mineclonia. This project focuses on classic Minecraft gameplay and aesthetics, with personal modifications and enhancements.

**Most work is done by the original Mineclonia developers; this fork is a personal project to make the game more like classic Minecraft. For more information on the original project, see the [original Mineclonia repository](https://codeberg.org/mineclonia/mineclonia).**

Based on Mineclonia version: 0.106.0

### Gameplay
You start in a randomly-generated world made entirely of cubes. You can explore the world and dig and build almost every block in the world to create new structures. You can choose to play in a “survival mode” in which you have to fight monsters and hunger for survival and slowly progress through the various other aspects of the game, such as mining, farming, building machines, and so on. Or you can play in “creative mode” in which you can build almost anything instantly.

## Installation
This game requires [Minetest](http://minetest.net) to run (version 5.6 or later). So you need to install Minetest first. Only stable versions of Minetest are officially supported. There is no support for running Minedraft in development versions of Minetest.

To install Minedraft (if you haven't already), move this directory into the “games” directory of your Minetest data directory. Consult the help of Minetest to learn more.

## Project description
The main goal of **Minedraft** is to be an aesthetic and gameplay clone of the popular game Minecraft, with personal modifications and enhancements.

* Minecraft is aimed to be cloned as well as Minetest currently permits without resorting to hacks which are too heavyweight or complicated to maintain.
* Cloning the interface and aesthetics of Minecraft as closely as possible, with some personal touches.

The following main features are available:

* Tools, weapons
* Armor
* Crafting system: 2×2 grid, crafting table (3×3 grid), furnace, including a crafting guide
* Chests, large chests, ender chests, shulker boxes
* Furnaces, hoppers
* Hunger
* Most monsters and animals
* All ores from Minecraft
* Most blocks in the overworld
* Water and lava
* Weather
* 28 biomes + 5 Nether Biomes
* The Nether, a fiery underworld in another dimension
* Redstone circuits (partially)
* Minecarts (partial)
* Status effects (partial)
* Experience
* Enchanting
* Brewing, potions, tipped arrow (partial)
* Boats
* Fire
* Building blocks: Stairs, slabs, doors, trapdoors, fences, fence gates, walls
* Clock
* Compass
* Sponge
* Slime block
* Small plants and saplings
* Dyes
* Banners
* Deco blocks: Glass, stained glass, glass panes, iron bars, hardened clay (and colors), heads and more
* Item frames
* Jukeboxes
* Beds
* Inventory menu
* Creative inventory
* Farming
* Writable books
* Commands
* Villages
* The End
* And more!

The following features are incomplete and might change in the future:

* Some monsters and animals
* Redstone-related things
* Special minecarts
* A couple of non-trivial blocks and items

Bonus features (not found in Minecraft):

* Built-in crafting guide which shows you crafting and smelting recipes
* In-game help system containing extensive help about gameplay basics, blocks, items and more
* Fully moddable (thanks to Minetest's powerful Lua API)
* Bookshelves can be used to store books
* Nether portals can be created with custom shapes
* New blocks and items:
    * Lookup tool, shows you the help for whatever it touches
    * More slabs and stairs
    * Nether Brick Fence Gate
    * Red Nether Brick Fence
    * Red Nether Brick Fence Gate

Technical differences from Minecraft:

* Height limit of ca. 31000 blocks (much higher than in Minecraft)
* Horizontal world size is ca. 62000×62000 blocks (much smaller than in Minecraft, but it is still very large)
* Still incomplete and buggy
* Blocks, items, enemies and other features are missing
* Structure replacements - these small variants of Minecraft structures serve as replacements until we can get large structures working:
    * Woodland Cabin (Mansion)
    * Nether Outpost (Fortress)
    * Ocean Temple (Monument)
    * Nether Bulwark (Bastion)
    * End Shipwreck & End Boat (End City)
    * Ancient Hermitage (Ancient City)
* A few items have slightly different names to make them easier to distinguish
* Different music for jukebox
* Different textures (Pixel Perfection)
* Different sounds (various sources)
* Different engine (Minetest)
* Different easter eggs

## Other readme files (from the original Mineclonia repository on Codeberg)
* [LICENSE](LICENSE): The license of the project.
* [CONTRIBUTING.md](CONTRIBUTING.md): How to contribute to the project.
* [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md): Code of conduct for the project.
* [CHANGELOG.md](CHANGELOG.md): The changelog of the project.
* [TODO.md](TODO.md): The to-do list of the project.