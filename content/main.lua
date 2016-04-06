local Shoppy = lukkit.addPlugin("Shoppy", "dev1.0.1",
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
                plugin.config.save()
                
                plugin.print("Shoppy has been enabled, version "..plugin.version)
                
            end
        )
        
        plugin.onDisable(
            function()
                plugin.print("Shoppy has been disabled")
            end
        )
        
        plugin.addCommand("shoppy", "Administration command for the plugin Shoppy", "/shoppy help",
            function(sender, args)
                local uuid = sender:getUniqueId():toString()
                if args[1] == "admin" then
                    sender:sendMessage("§6============ §cShoppy Admin §6============")
                    sender:sendMessage("§c/shoppy admin default {shop}")
                else
                    sender:sendMessage("§6============ §eShoppy "..plugin.version.." §6============")
                    plugin.config.setDefault(uuid..".default", "SHOP")
                    plugin.config.save()
                    sender:sendMessage("§eYour default shop is: "..plugin.config.get(uuid..".default"))
                    sender:sendMessage("§eUsage: &o/shop [floor] &eOR &o/shop {shop} [floor]")
                    sender:sendMessage("§eSet your default shop with /shoppy default {shop} [floor]")
                    sender:sendMessage("§eThe default server shop is: "..plugin.config.get("config.default"))
                    if sender:hasPermission("shoppy.admin") then
                        sender:sendMessage("§cUse /shoppy admin for admin commands")
                    end
                end
            end
        )
        
    end
)
