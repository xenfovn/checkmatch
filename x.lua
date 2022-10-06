self.Functions.AddItem = function(item, amount, slot, info, created)
    local totalWeight = QBCore.Player.GetTotalWeight(self.PlayerData.items)
    local itemInfo = QBCore.Shared.Items[item:lower()]
    local time = os.time()
    if not created then 
        itemInfo['created'] = time
    else 
        itemInfo['created'] = created
    end
    -- itemInfo['created'] = time
    if itemInfo["type"] == 'item' and info == nil then
        info = { quality = 100 }
    end
    if itemInfo == nil then
        TriggerClientEvent('QBCore:Notify', self.PlayerData.source, Lang:t('error.item_not_exist'), 'error')
        return
    end
    local amount = tonumber(amount)
    local slot = tonumber(slot) or QBCore.Player.GetFirstSlotByItem(self.PlayerData.items, item)
    if itemInfo['type'] == 'weapon' and info == nil then
        info = {
            serie = tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4)),
        }
    end
    if (totalWeight + (itemInfo['weight'] * amount)) <= QBCore.Config.Player.MaxWeight then
        if (slot and self.PlayerData.items[slot]) and (self.PlayerData.items[slot].name:lower() == item:lower()) and (itemInfo['type'] == 'item' and not itemInfo['unique']) then
            self.PlayerData.items[slot].amount = self.PlayerData.items[slot].amount + amount
            self.Functions.UpdatePlayerData()
            TriggerEvent('qb-log:server:CreateLog', 'playerinventory', 'AddItem', 'green', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** got item: [slot:' .. slot .. '], itemname: ' .. self.PlayerData.items[slot].name .. ', added amount: ' .. amount .. ', new total amount: ' .. self.PlayerData.items[slot].amount)
            return true
        elseif (not itemInfo['unique'] and slot or slot and self.PlayerData.items[slot] == nil) then
            self.PlayerData.items[slot] = { name = itemInfo['name'], amount = amount, info = info or '', label = itemInfo['label'], description = itemInfo['description'] or '', weight = itemInfo['weight'], type = itemInfo['type'], unique = itemInfo['unique'], useable = itemInfo['useable'], image = itemInfo['image'], shouldClose = itemInfo['shouldClose'], slot = slot, combinable = itemInfo['combinable'], created = itemInfo['created'] }
            self.Functions.UpdatePlayerData()
            TriggerEvent('qb-log:server:CreateLog', 'playerinventory', 'AddItem', 'green', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** got item: [slot:' .. slot .. '], itemname: ' .. self.PlayerData.items[slot].name .. ', added amount: ' .. amount .. ', new total amount: ' .. self.PlayerData.items[slot].amount)
            return true
        elseif (itemInfo['unique']) or (not slot or slot == nil) or (itemInfo['type'] == 'weapon') then
            for i = 1, QBConfig.Player.MaxInvSlots, 1 do
                if self.PlayerData.items[i] == nil then
                    self.PlayerData.items[i] = { name = itemInfo['name'], amount = amount, info = info or '', label = itemInfo['label'], description = itemInfo['description'] or '', weight = itemInfo['weight'], type = itemInfo['type'], unique = itemInfo['unique'], useable = itemInfo['useable'], image = itemInfo['image'], shouldClose = itemInfo['shouldClose'], slot = i, combinable = itemInfo['combinable'], created = itemInfo['created'] }
                    self.Functions.UpdatePlayerData()
                    TriggerEvent('qb-log:server:CreateLog', 'playerinventory', 'AddItem', 'green', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** got item: [slot:' .. i .. '], itemname: ' .. self.PlayerData.items[i].name .. ', added amount: ' .. amount .. ', new total amount: ' .. self.PlayerData.items[i].amount)
                    return true
                end
            end
        end
    else
        TriggerClientEvent('QBCore:Notify', self.PlayerData.source, Lang:t('error.too_heavy'), 'error')
    end
    return false
end
