local Shoppy = lukkit.addPlugin("Shoppy", "dev1.0.2",
    function(plugin)
    
        plugin.onEnable(
            function()
                plugin.config.setDefault("config.default", "shop")
                plugin.config.setDefault("lang.message.create", "&7You have created a new shop with the name &9{shop}&7.")
                plugin.config.setDefault("lang.message.public", "&7The shop &9{shop} &7has been set to &aPublic&7.")
                plugin.config.setDefault("lang.message.private", "&7The shop &9{shop} &7has been set to &cPrivate&7.")
                plugin.config.setDefault("lang.message.setwarp", "&7You have set shop &9{shop}&7's warp to your current location.")
                plugin.config.setDefault("lang.message.delwarp", "&7You have unset the shop &9{shop}&7's warp.")
                plugin.config.setDefault("lang.message.deleted", "&7You deleted the shop &9{shop}&7.")
                plugin.config.setDefault("lang.message.whitelistadd", "&7You have added &9{name}&7 to the shop &9{shop}&7's whitelist.")
                plugin.config.setDefault("lang.message.whitelistrem", "&7You have removed &9{name}&7 from the shop &9{shop}&7's whitelist.")
                plugin.config.setDefault("lang.message.manageradd", "&7You have added &9{name}&7 as manager of shop &9{shop}&7.")
                plugin.config.setDefault("lang.message.managerrem", "&7You have removed &9{name}&7 from manager of shop &9{shop}&7.")
                plugin.config.setDefault("lang.message.transfer", "&7You have transferred ownership of &9{shop}&7 to &9{name}")
                plugin.config.setDefault("lang.message.missing", "&9Error: &cThat shop does not exist")
                plugin.config.save()
                
                plugin.print("Shoppy has been enabled, version "..plugin.version)
                
            end
        )
        
        plugin.onDisable(
            function()
                plugin.print("Shoppy has been disabled")
            end
        )
        
        --[[
            Shops must contain:
            - UPPERCASE NAME
            - OWNER UUID
            - LOCATION X, Y, Z, P, and Y
        ]]--
        
        local shops = {}
        
        function shops.save(data, name)
            name = string.upper(name)
            
            if data.owner then plugin.config.set(name..".owner", data.owner) end
            if data.open then plugin.config.set(name..".open", data.open) end
            if data.posX then plugin.config.set(name..".posX", data.posX) end
            if data.posY then plugin.config.set(name..".posY", data.posY) end
            if data.posZ then plugin.config.set(name..".posZ", data.posZ) end
            if data.posP then plugin.config.set(name..".posP", data.posP) end
            if data.posW then plugin.config.set(name..".posW", data.posW) end
            if data.name then plugin.config.set(name..".name", data.name) end
            
            plugin.config.save()
        end
        
        function shops.load(name)
            name = string.upper(name)
            local data = {}
            
            if plugin.config.get(name..".owner") then data.owner = plugin.config.get(name..".owner") end
            if plugin.config.get(name..".open") then data.open = plugin.config.get(name..".open") end
            if plugin.config.get(name..".posX") then data.posX = plugin.config.get(name..".posX") end
            if plugin.config.get(name..".posY") then data.posY = plugin.config.get(name..".posY") end
            if plugin.config.get(name..".posZ") then data.posZ = plugin.config.get(name..".posZ") end
            if plugin.config.get(name..".posP") then data.posP = plugin.config.get(name..".posP") end
            if plugin.config.get(name..".posW") then data.posW = plugin.config.get(name..".posW") end
            
            return data
        end
        
        function shops.delete(name)
            name = string.upper(name)
            plugin.config.clear(name)
            plugin.config.save()
        end
        
        function shops.create(name, owner, posX, posY, posZ, posP, posW)
            name = string.upper(name)
            plugin.config.set(name..".owner", owner)
            plugin.config.set(name..".open", open)
            plugin.config.set(name..".posX", posX)
            plugin.config.set(name..".posY", posY)
            plugin.config.set(name..".posZ", posZ)
            plugin.config.set(name..".posP", posP)
            plugin.config.set(name..".posW", posW)
            plugin.config.save()
        end
        
        function shops.exists(name)
            name = string.upper(name)
            if plugin.config.get(name..".owner") then return true else return false end
        end
        
        plugin.addCommand("shop", "Teleport to a shop", "/shop [name] [level]]", 
            function(sender, args)
                if not args[1] then args[1] = plugin.config.get("config.default") end
                if shops.exists(args[1]) then
                else
                    sender:sendMessage("This 
            end
        )
        
    end
)
