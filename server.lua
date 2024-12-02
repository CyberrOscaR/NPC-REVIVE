ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent('esx_revive:revivePlayer')
AddEventHandler('esx_revive:revivePlayer', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        -- Usa la función revivePlayer del framework ESX
        xPlayer.triggerEvent('esx_ambulancejob:revive')

        -- Envía un mensaje de chat al jugador
        TriggerClientEvent('esx:showNotification', source, 'Has sido revivido por el doctor.')
    end
end)
