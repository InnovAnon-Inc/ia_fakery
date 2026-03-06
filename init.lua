minetest.register_craftitem("fakery:diamond", {
	description = "Diamond",
	inventory_image = "default_diamond.png",
})
minetest.register_craftitem("fakery:mese", {
	description = "Mese Crystal",
	inventory_image = "default_mese_crystal.png",
})
minetest.register_craftitem("fakery:obsidian", {
	description = "Obsidian Shard",
	inventory_image = "default_obsidian_shard.png",
})
minetest.register_craftitem("fakery:gold", {
	description = "Gold Ingot",
	inventory_image = "default_gold_ingot.png",
})
if minetest.get_modpath("moreores") then
	minetest.register_craftitem("fakery:mithril", {
		description = "Mithril Ingot",
		inventory_image = "moreores_mithril_ingot.png",
	})
end
if minetest.get_modpath("cloud_items") then
	minetest.register_craftitem("fakery:cloud", {
		description = "Cloud Ingot",
		inventory_image = "cloud_items_cloud_ingot.png",
	})
end
if minetest.get_modpath("lavastuff") then
	minetest.register_craftitem("fakery:lava", {
		description = "Lava Ingot",
		inventory_image = "lavastuff_ingot.png",
	})
end
if minetest.get_modpath("overpowered") then
	minetest.register_craftitem("fakery:op", {
		description = "OP Alloy Ingot",
		inventory_image = "overpowered_ingot.png",
	})
end
if minetest.get_modpath("technic_worldgen") then
	minetest.register_craftitem("fakery:uranium", {
		description = "Uranium Lump",
		inventory_image = "technic_uranium_lump.png",
	})
end
--formspecs
if minetest.get_modpath("basic_materials") then
	fake_item = "basic_materials:plastic_sheet"
else
	fake_item = "default:steel_ingot"
end
local function get_formspec_bench()
	if fake_item == "basic_materials:plastic_sheet" then
	return "size[10,10]"..
		"image[4.5,2;1,1;sfinv_crafting_arrow.png]"..
		"list[context;metal;2,1.5;1,1;1]"..
		"image[2,1.5;1,1;fakery_plastic.png]"..
		"list[context;dye;2,2.5;1,1;1]"..
		"image[2,2.5;1,1;fakery_dye.png]"..
		"list[context;dest;7,2;1,1;1]"..
		"list[current_player;main;1,5;8,4;]"
	else
    return "size[10,10]"..
		"image[4.5,2;1,1;sfinv_crafting_arrow.png]"..
		"list[context;metal;2,1.5;1,1;1]"..
		"image[2,1.5;1,1;fakery_ingot.png]"..
		"list[context;dye;2,2.5;1,1;1]"..
		"image[2,2.5;1,1;fakery_dye.png]"..
		"list[context;dest;7,2;1,1;1]"..
		"list[current_player;main;1,5;8,4;]"
	end
end
local function get_formspec_working()
	return "size[10,10]"..
		"label[4,2;Forgery in process...]"..
		"list[current_player;main;1,5;8,4;]"
end
--workbench
local function register_recipe(dye,metal,result,pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local timer = minetest.get_node_timer(pos)
		if inv:contains_item("dye", dye) == true and inv:contains_item("metal", metal) == true and inv:is_empty("dest") then
			inv:remove_item("dye", dye)
			inv:remove_item("metal", metal)
			local dye_s = inv:get_stack("dye", 2)
			local metal_s = inv:get_stack("metal", 2)
			inv:set_stack("dye", 2, dye_s)
			inv:set_stack("metal", 2, metal_s)
			inv:set_stack("dest", 2, result)
			meta:set_string("formspec", get_formspec_working())
			timer:start(7)
		end
end
local function craft(pos)
	register_recipe("dye:yellow",fake_item,"fakery:mese",pos) -- default:mese_crystal
	register_recipe("dye:cyan",fake_item,"fakery:diamond",pos)
	register_recipe("dye:black",fake_item,"fakery:obsidian",pos) -- default:obsidian_shard
	register_recipe("dye:orange",fake_item,"fakery:gold",pos) -- default:gold_ingot
	if minetest.get_modpath("moreores") then register_recipe("dye:blue",fake_item,"fakery:mithril",pos) end
	if minetest.get_modpath("cloud_items") then register_recipe("dye:white",fake_item,"fakery:cloud",pos) end
	if minetest.get_modpath("lavastuff") then register_recipe("dye:red",fake_item,"fakery:lava",pos) end
	if minetest.get_modpath("overpowered") then register_recipe("dye:green",fake_item,"fakery:op",pos) end -- TODO switch green shades ?
	if minetest.get_modpath("technic_worldgen") then register_recipe("dye:dark_green",fake_item,"fakery:uranium",pos) end -- technic:uranium_lump -- TODO switch green shades ?
end
minetest.register_node("fakery:table", {
		description = "Forgery Workbench",
		tiles = {"fakery_bench_top.png", "fakery_bench_top.png", "fakery_bench_side.png", "fakery_bench_side.png","fakery_bench_side.png", "fakery_bench_side.png"},
		groups = {oddly_breakable_by_hand = 1},
		on_construct = function(pos, node)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			inv:set_size("dye", 2*1)
			inv:set_size("metal", 2*1)
			inv:set_size("dest", 2*1)
			meta:set_string("formspec", get_formspec_bench())
		end,
		on_timer = function(pos)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			meta:set_string("formspec", get_formspec_bench())
			return false
		end,
		on_metadata_inventory_put = function(pos, listname, index, stack, player)
			craft(pos)
		end,
		on_metadata_inventory_take = function(pos, listname, index, stack, player)
			craft(pos)
		end,
		on_metadata_inventory_move = function(pos, listname, index, stack, player)
			craft(pos)
		end	
})
minetest.register_craft({
		output = "fakery:table",
		recipe = {
			{"default:sword_steel", "default:pick_steel", "default:axe_steel"},
			{"default:desert_sandstone_block", "default:bronzeblock", "default:desert_sandstone_block"},
			{"default:desert_sandstone_block", "default:bronzeblock", "default:desert_sandstone_block"}
		}
})

-- =============================================================================
-- Automated Forgery Workbench (Powered / Appliances)
-- =============================================================================

if minetest.get_modpath("appliances") and minetest.get_modpath("pipeworks") and minetest.get_modpath("technic") then
    local S_auto = minetest.get_translator("fakery")

if minetest.get_modpath("hopper") then -- NOTE untested
	hopper:add_container({
		{"top",    "fakery:table_lv",        "output"}, -- top    of hopper removes from output
		{"bottom", "fakery:table_lv",        "input"},  -- bottom of hopper inserts to   input
		{"side",   "fakery:table_lv",        "input"},
		{"top",    "fakery:table_lv_active", "output"},
		{"bottom", "fakery:table_lv_active", "input"},
		{"side",   "fakery:table_lv_active", "input"},
	})
end

    -- 1. Create the Appliance Object
    local table_lv = appliances.appliance:new({
        node_name_inactive = "fakery:table_lv",
        node_name_active   = "fakery:table_lv_active",
        --node_name_waiting = nil

        node_description   = S_auto("Automated Forgery Workbench"),
        node_help          = S_auto("An LV-powered workbench with Pipeworks support."),

        -- [2026-03-06] Set to 2 to allow both Dye and Metal in the same list
        input_stack        = "input", 
        input_stack_size   = 2, -- NOTE changing this doesn't work... why?
        input_stack_width  = 2, -- NOTE undocumented; this seems to be the fix (the device invisibly accepts the required inputs and begins working, but the formspec shows only one inv slot)
        --have_input = true
        -- FIXME formspec doesn't reflect input_stack_size if not 1
	
	--use_stack          = "use_in",
        --use_stack_size     = 1, 
        have_usage         = false,

        output_stack       = "output",
        output_stack_size  = 4, -- NOTE changing this doesn't work, either... why?
    
	--stoppable_production  = true
	--stoppable_consumption = true
    
        --items_connect_sides   = {'right', 'left'}
    	--supply_connect_sides  = {'top'}
    	--power_connect_sides   = {'bottom'}
    	--control_connect_sides = {'right', 'left', 'front', 'back', 'top', 'bottom'}
    	--meta_infotext         = 'infotext'

    	-- FIXME no way to connect tube to output ?

    	--have_control
    })

    -- 2. Data Registration
    table_lv:item_data_register({ 
        ["tube_item"] = {}, -- Pipeworks support 
    })

    table_lv:power_data_register({ 
    	["no_power"] = {
        	disable = {}
    	},
        ["LV_power"] = {
		demand = 100, run_speed = 1, disable = {"no_power"}
	}, 
    })


    -- 3. Logic & Recipe Helpers
    --local auto_fake_item = (minetest.get_modpath("basic_materials") and "basic_materials:plastic_sheet") or "default:steel_ingot"
    assert(fake_item ~= nil)

    -- Define which items are allowed in the input slots
--    function table_lv:recipe_inventory_can_put(pos, listname, index, stack, player)
--        if listname == self.input_stack then
--            local name = stack:get_name()
--            if name == auto_fake_item or name:find("dye:") then
--                return stack:get_count()
--            end
--        end
--        return 0
--    end
--
----    local function add_auto_recipe(dye, result)
----        if minetest.registered_items[result] then
----            -- [2026-02-27] Assertion to catch missing recipe inputs
----            assert(minetest.registered_items[dye], "Fakery recipe error: " .. dye .. " does not exist.")
----            
----            table_lv:recipe_register_input("", {
----                inputs = {dye, auto_fake_item},
----                outputs = {result},
----                production_time = 7,
----                consumption_step_size = 1,
----            })
----        end
----    end
    local function add_auto_recipe(dye, result)
    if minetest.registered_items[result] then
        -- The Appliances API uses table.insert for size > 1
        -- which matches recipes based on the index of the 'inputs' table.
        table_lv:recipe_register_input("", {
            inputs = {
                [1] = dye,           -- Explicitly slot 1
                [2] = fake_item -- Explicitly slot 2
            },
            outputs = {result},
            production_time = 7,
            consumption_step_size = 1,
        })
    end
    end

    -- 4. Register Recipes
    add_auto_recipe("dye:yellow", "fakery:mese") -- default:mese_crystal
    add_auto_recipe("dye:cyan",   "fakery:diamond")
    add_auto_recipe("dye:black",  "fakery:obsidian") -- default:obsidian_shard
    add_auto_recipe("dye:orange", "fakery:gold") -- default:gold_ingot
    
    if minetest.get_modpath("moreores") then 
        add_auto_recipe("dye:blue", "fakery:mithril") 
    end
    if minetest.get_modpath("cloud_items") then 
        add_auto_recipe("dye:white", "fakery:cloud") 
    end
    if minetest.get_modpath("lavastuff") then 
        add_auto_recipe("dye:red", "fakery:lava") 
    end
    if minetest.get_modpath("overpowered") then 
        add_auto_recipe("dye:green", "fakery:op") 
    end
    if minetest.get_modpath("technic_worldgen") then
	add_auto_recipe("dye:dark_green",fake_item,"fakery:uranium",pos) -- technic:uranium_lump -- TODO switch green shades ?
    end

    -- [2026-03-06] Fixed cb_on_production signature to match Appliances API (appliance.lua:1119)
-- This replaces the incorrect (pos, meta) signature that caused the crash.
    if minetest.get_modpath('ia_util') then
        function table_lv:cb_on_production(timer_step)
	    return ia_util.appliances_cb_on_production(self, timer_step)
	end
	function table_lv:get_formspec(meta, production_percent, consumption_percent)
	    return ia_util.appliances_get_formspec(self, meta, production_percent, consumption_percent)
        end
    end

    -- 5. Register Nodes
    local orig_node_def                         = minetest.registered_nodes['fakery:table']
    assert(orig_node_def       ~= nil)
    assert(orig_node_def.tiles ~= nil)
    local auto_node_def                         = table.copy(orig_node_def)
    --paramtype2 = "facedir",
    --groups = {cracky = 2, tubedevice = 1, tubedevice_receiver = 1},
    --auto_node_def.groups                        = table.copy(orig_node_def.groups)
    --auto_node_def.groups['tubedevice']          = 1
    --auto_node_def.groups['tubedevice_receiver'] = 1
    auto_node_def.tiles                         = nil
    auto_node_def.on_construct                  = nil
    auto_node_def.on_timer                      = nil
    auto_node_def.on_metadata_inventory_put     = nil
    auto_node_def.on_metadata_inventory_take    = nil
    auto_node_def.on_metadata_inventory_move    = nil

    local auto_visuals_inactive                 = {
	    tiles                               = table.copy(orig_node_def.tiles),
    }
    --auto_visuals_inactive.tiles[0]           = auto_visuals_inactive.tiles[0] .. '^[colorize:#00FFFF:30' -- FIXME
    
    local auto_visuals_active                   = {
	    tiles                               = table.copy(orig_node_def.tiles),
    }
    --auto_visuals_active  .tiles[0]           = auto_visuals_active  .tiles[0] .. '^[colorize:#00FFFF:50' -- FIXME

    table_lv:register_nodes(auto_node_def, auto_visuals_inactive, auto_visuals_active)

    -- FIXME ia_fakery needs an exception to allow faking this item
    -- 6. Upgrade Craft
    minetest.register_craft({
        output = "fakery:table_lv",
        recipe = {
            {"default:copper_ingot", "default:mese_crystal", "default:copper_ingot"},
            {"default:steel_ingot",  "fakery:table",         "default:steel_ingot"},
            {"default:copper_ingot", "technic:lv_transformer", "default:copper_ingot"},
        }
    })
end
