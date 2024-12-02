local npcLocations = {
    {coords = vector3(299.60, -580.35, 42.26), heading = 82.55},
    {coords = vector3(-1868.07, -321.16, 48.45), heading = 320.24},
    {coords = vector3(1837.21, 3672.54, 33.28), heading = 218.93},
    {coords = vector3(-248.96, 6331.50, 31.43), heading = 225.30},
    -- Añade más NPCs aquí con sus respectivas coordenadas y orientaciones
}

local npcModel = 's_m_m_doctor_01' -- Modelo del NPC
local npcList = {} -- Lista para guardar los NPCs
local blipList = {} -- Lista para guardar los blips
local Keys = {
    ['E'] = 38
}

Citizen.CreateThread(function()
    -- Carga el modelo del NPC
    RequestModel(GetHashKey(npcModel))
    while not HasModelLoaded(GetHashKey(npcModel)) do
        Citizen.Wait(1)
    end

    -- Crea los NPCs y sus blips
    for _, npcData in pairs(npcLocations) do
        local npc = CreatePed(4, GetHashKey(npcModel), npcData.coords.x, npcData.coords.y, npcData.coords.z, npcData.heading, false, true)
        SetEntityAsMissionEntity(npc, true, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        SetPedDiesWhenInjured(npc, false)
        SetPedCanPlayAmbientAnims(npc, true)
        SetPedCanRagdollFromPlayerImpact(npc, false)
        SetEntityInvincible(npc, true)
        FreezeEntityPosition(npc, true)
        table.insert(npcList, npc)

        -- Crea el blip para el NPC
        local blip = AddBlipForCoord(npcData.coords.x, npcData.coords.y, npcData.coords.z)
        SetBlipSprite(blip, 403) -- Puedes cambiar el icono del blip aquí
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.5)
        SetBlipColour(blip, 1) -- Puedes cambiar el color del blip aquí
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Medico")
        EndTextCommandSetBlipName(blip)
        table.insert(blipList, blip)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, npcData in pairs(npcLocations) do
            -- Comprueba si el jugador está cerca del NPC
            if #(playerCoords - npcData.coords) < 2.0 then
                -- Muestra un mensaje en pantalla
                ESX.ShowHelpNotification("Presiona ~INPUT_CONTEXT~ para interactuar con el doctor")

                -- Si el jugador presiona la tecla E
                if IsControlJustReleased(0, Keys['E']) then
                    -- Comprueba si el jugador está muerto
                    if IsEntityDead(playerPed) then
                        -- Envía un evento al servidor para revivir al jugador
                        TriggerServerEvent('esx_revive:revivePlayer')
                    else
                        -- Muestra una notificación si el jugador está vivo
                        ESX.ShowNotification("¡No necesitas ser revivido porque estás vivo!")
                    end
                end
            end
        end
    end
end)
