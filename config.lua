Config = {}

Config.BlackmarketLocations = {
    vec3(993.0709, -2195.1677, 31.5878),
    vec3(2663.4448, 864.0106, 77.9236)
}

Config.ChangeTime = 60 

Config.NPCModel = "g_m_y_mexgoon_02"

Config.Items = {
    { name = "weapon_pistol", label = "Pistol", basePrice = 5000, rarity = 5 },-- rarity WIP dosent work
    { name = "weapon_assaultrifle", label = "AK-47", basePrice = 25000, rarity = 3 },-- rarity WIP dosent work
    { name = "weapon_snspistol", label = "SNS Pistol", basePrice = 15000, rarity = 2 },-- rarity WIP dosent work
    { name = "weapon_microsmg", label = "Micro SMG", basePrice = 30000, rarity = 1 }-- rarity WIP dosent work
}

Config.Logs = {
    enabled = true,
    webhook = "discord_webhook"
}