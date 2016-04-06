local Shoppy = lukkit.addPlugin("Shoppy", "dev1.0.9",
    function(plugin)
    
        plugin.onEnable(
            function()
                plugin.config.setDefault("config.default", "shop")
                plugin.config.setDefault("lang.message.create", "&7You have created a new shop with the name &9{shop}&7.")
                plugin.config.setDefault("lang.message.public", "&7The shop &9{shop} &7has been set to &aOpen&7.")
                plugin.config.setDefault("lang.message.private", "&7The shop &9{shop} &7has been set to &cClosed&7.")
                plugin.config.setDefault("lang.message.setwarp", "&7You have set shop &9{shop}&7's warp to your current location.")
                plugin.config.setDefault("lang.message.delwarp", "&7You have unset the shop &9{shop}&7's warp.")
                plugin.config.setDefault("lang.message.deleted", "&7You deleted the shop &9{shop}&7.")
                plugin.config.setDefault("lang.message.transfer", "&7You have transferred ownership of &9{shop}&7 to &9{name}&7.")
                plugin.config.setDefault("lang.message.missing", "&9Error: &cThat shop does not exist.")
                plugin.config.setDefault("lang.message.permission", "&9Error: &cYou do not have permission.")
                plugin.config.setDefault("lang.message.closed", "&9Error: &cThat shop is closed.")
                plugin.config.setDefault("lang.message.information", "&7Teleporting to {shop}...")
                plugin.config.setDefault("lang.message.default", "&9{shop} &7is now default! Type &9/shop &7to go there.")
                plugin.config.setDefault("lang.message.taken", "&9Error: &cThat shop already exists.")
                plugin.config.setDefault("lang.message.whodat", "&9Error: &c{name} has never joined the server.")
                plugin.config.setDefault("lang.message.renamed", "&7You have renamed the shop &9{old} &7to &9{new}&7.")
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
                if sender:hasPermission("shoppy.travel") then
                    if not args[1] then args[1] = plugin.config.get("config.default") end
                    if shops.exists(args[1]) then
                        local data = shops.load(args[1])
                        if data.open == true then
                            local str = data.posX .. " " ..data.posY.. " " ..data.posZ.. " " ..data.posW.. " " ..data.posP
                            local message = plugin.config.get("lang.message.information")
                            message = string.gsub(message, "{shop}", args[1])
                            message = string.gsub(message, "{name}", data.owner)
                            message = string.gsub(message, "&", "§")
                            sender:sendMessage(message)
                            server:dispatchCommand(server:getConsoleSender(), "minecraft:tp "..sender:getName().." "..str )
                        else
                            local uuid = sender:getUniqueId():toString()
                            if data.owner == uuid or sender:hasPermission("shoppy.bypass") then
                                local str = data.posX .. " " ..data.posY.. " " ..data.posZ.. " " ..data.posW.. " " ..data.posP
                                local message = plugin.config.get("lang.message.information")
                                message = string.gsub(message, "{shop}", args[1])
                                message = string.gsub(message, "{name}", data.owner)
                                message = string.gsub(message, "&", "§")
                                sender:sendMessage(message)
                                server:dispatchCommand(server:getConsoleSender(), "minecraft:tp "..sender:getName().." "..str )
                            else
                                local message = plugin.config.get("lang.message.closed")
                                message = string.gsub(message, "{shop}", args[1])
                                message = string.gsub(message, "&", "§")
                                sender:sendMessage(message)
                            end
                        end
                    else
                        local message = plugin.config.get("lang.message.missing")
                        message = string.gsub(message, "{shop}", args[1])
                        message = string.gsub(message, "&", "§")
                        sender:sendMessage(message)
                    end
                else
                    local message = plugin.config.get("lang.message.permission")
                    message = string.gsub(message, "{shop}", args[1])
                    message = string.gsub(message, "&", "§")
                    sender:sendMessage(message)
                end
            end
        )
        
        plugin.addCommand("shoppy", "Manage your shop", "/shoppy ?",
            function(sender, args)
                if sender:hasPermission("shoppy.setdefault") or sender:hasPermission("shoppy.manage") or sender:hasPermission("shoppy.admin") then
                    if args[1] == "admin" then
                        if args[2] == "create" then
                            if args[3] then
                                if shops.exists(args[3]) then
                                    local message = plugin.config.get("lang.message.taken")
                                    message = string.gsub(message, "{shop}", args[3])
                                    message = string.gsub(message, "&", "§")
                                    sender:sendMessage(message)
                                else
                                    if args[4] then
                                        local offline = server:getOfflinePlayer(args[4])
                                        if offline:isOnline() or offline:hasPlayedBefore() then
                                            local location = sender:getLocation()
                                            local posX = location:getX()
                                            local posY = location:getY()
                                            local posZ = location:getZ()
                                            local posP = location:getPitch()
                                            local posW = location:getYaw()
                                            shops.create(args[3], offline:getUniqueId():toString(), posX, posY, posZ, posP, posW)
                                            local message = plugin.config.get("lang.message.create")
                                            message = string.gsub(message, "{shop}", args[3])
                                            message = string.gsub(message, "&", "§")
                                            sender:sendMessage(message)
                                        else
                                            local message = plugin.config.get("lang.message.whodat")
                                            message = string.gsub(message, "{name}", offline:getName())
                                            message = string.gsub(message, "&", "§")
                                            sender:sendMessage(message)
                                        end
                                    else
                                        sender:sendMessage("§7/shoppy admin create {shop} {owner}")
                                    end
                                end
                            else
                                sender:sendMessage("§7/shoppy admin create {shop} {owner}")
                            end
                        elseif args[2] == "delete" then
                            if args[3] then
                                if shops.exists(args[3]) then
                                    shops.delete(args[3])
                                    local message = plugin.config.get("lang.message.deleted")
                                    message = string.gsub(message, "{shop}", args[3])
                                    message = string.gsub(message, "&", "§")
                                    sender:sendMessage(message)
                                else
                                    local message = plugin.config.get("lang.message.missing")
                                    message = string.gsub(message, "&", "§")
                                    sender:sendMessage(message)
                                end
                            else
                                sender:sendMessage("§7/shoppy admin delete {shop}")
                            end
                        elseif args[2] == "rename" then
                            if args[3] and args[4] then
                                if shops.exists(args[3]) then
                                    if not shops.exists(args[4]) then
                                        local data = shops.load(args[3])
                                        shops.delete(args[3])
                                        shops.save(data, args[4])
                                    else
                                        local message = plugin.config.get("lang.message.taken")
                                        message = string.gsub(message, "&", "§")
                                        sender:sendMessage(message)
                                    end
                                else
                                    local message = plugin.config.get("lang.message.missing")
                                    message = string.gsub(message, "&", "§")
                                    sender:sendMessage(message)
                                end
                            else
                                sender:sendMessage("§7/shoppy admin rename {shop} {new}")
                            end
                        elseif args[2] == "transfer" then
                            if args[3] and args[4] then
                                if shops.exists(args[3]) then
                                    local offline = server:getOfflinePlayer(args[4])
                                    if offline:isOnline() or offline:hasPlayedBefore() then
                                        local uuid = offline:getUniqueId():toString()
                                        local data = shops.load(args[3])
                                        data.owner = uuid
                                        shops.save(data, args[3])
                                        local message = plugin.config.get("lang.message.transfer")
                                        message = string.gsub(message, "{name}", data.owner)
                                        message = string.gsub(message, "{shop}", args[3])
                                        sender:sendMessage(message)
                                    else
                                        local message = plugin.config.get("lang.message.whodat")
                                        message = string.gsub(message, "&", "§")
                                        sender:sendMessage(message)
                                    end
                                else
                                    local message = plugin.config.get("lang.message.missing")
                                    message = string.gsub(message, "&", "§")
                                    sender:sendMessage(message)
                                end
                            else
                                sender:sendMessage("§7/shoppy admin transfer {shop} {owner}")
                            end
                        elseif args[2] == "default" then
                            if args[3] then
                                if shops.exists(args[3]) == true then
                                    args[3] = string.upper(args[3])
                                    plugin.config.set("config.default", args[3])
                                    plugin.config.save()
                                    local message = plugin.config.get("lang.message.default")
                                    message = string.gsub(message, "{shop}", args[3])
                                    message = string.gsub(message, "&", "§")
                                    sender:sendMessage(message)
                                else
                                    local message = plugin.config.get("lang.message.missing")
                                    message = string.gsub(message, "{shop}", args[3])
                                    message = string.gsub(message, "&", "§")
                                    sender:sendMessage(message)
                                end
                            else
                                sender:sendMessage("§7/shoppy admin default {shop}")
                            end
                        else
                            sender:sendMessage("§cStaff commands for /shoppy")
                            sender:sendMessage("§7/shoppy admin create {shop} {owner}")
                            sender:sendMessage("§7/shoppy admin delete {shop}")
                            sender:sendMessage("§7/shoppy admin rename {shop} {new}")
                            sender:sendMessage("§7/shoppy admin transfer {shop} {name}")
                            sender:sendMessage("§7/shoppy admin default {shop}")
                        end
                    elseif args[1] == "default" then
                    elseif args[1] == "create" then
                    elseif args[1] == "rename" then
                    elseif args[1] == "open" then
                    elseif args[1] == "close" then
                    elseif args[1] == "transfer" then
                    elseif args[1] == "delete" then
                    else
                        sender:sendMessage("§cCommands for /shoppy and /shop")
                        sender:sendMessage("§7/shoppy default {shop}")
                        sender:sendMessage("§7/shoppy create {shop}")
                        sender:sendMessage("§7/shoppy rename {shop} {new}")
                        sender:sendMessage("§7/shoppy transfer {shop} {name}")
                        sender:sendMessage("§7/shoppy open {shop}")
                        sender:sendMessage("§7/shoppy close {shop}")
                        sender:sendMessage("§7/shoppy delete {shop}")
                        sender:sendMessage("§7/shop [shop] [floor] OR /shop [floor]")
                    end
                else
                    local message = plugin.config.get("lang.message.permission")
                    message = string.gsub(message, "{shop}", args[1])
                    message = string.gsub(message, "&", "§")
                    sender:sendMessage(message)
                end
            end
        )
        
    end
)
