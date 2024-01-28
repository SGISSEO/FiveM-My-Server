local noClipEnabled = false
local noClipSpeed = 1.0

local lastNoClipSpeed = 1.0

-- Fonction pour changer la vitesse du NoClip
local function changeNoClipSpeed()
    if IsControlPressed(0, 36) then -- Touche CTRL
        if lastNoClipSpeed == 1.0 then
            lastNoClipSpeed = 0.1 -- Changer la vitesse à Very slow si la touche CTRL est enfoncée
        elseif lastNoClipSpeed == 0.1 then
            lastNoClipSpeed = 2.0 -- Changer la vitesse à Very fast si la touche CTRL est enfoncée de nouveau
        else
            lastNoClipSpeed = 1.0 -- Revenir à la vitesse normale sinon
        end
    end
    -- Aucun else nécessaire, car nous voulons conserver la dernière vitesse utilisée si la touche CTRL n'est pas enfoncée
    noClipSpeed = lastNoClipSpeed -- Mettre à jour la vitesse du NoClip avec la dernière vitesse utilisée
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        changeNoClipSpeed() -- Appeler la fonction pour changer la vitesse du NoClip

        if IsControlJustPressed(0, 170) then -- Touche F3
            noClipEnabled = not noClipEnabled
            local playerPed = GetPlayerPed(-1)

            if noClipEnabled then
                SetEntityInvincible(playerPed, true)
                SetEntityHasGravity(playerPed, false)
                SetEntityCollision(playerPed, false, false)
                SetEntityAlpha(playerPed, 150)
                TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, "No Clip activé")
            else
                SetEntityInvincible(playerPed, false)
                SetEntityHasGravity(playerPed, true)
                SetEntityCollision(playerPed, true, true)
                SetEntityAlpha(playerPed, 255)
                TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, "No Clip désactivé")
            end
        end

        if noClipEnabled then
            local playerPed = GetPlayerPed(-1)
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local camRot = GetGameplayCamRot()

            local deltaX, deltaY, deltaZ = 0.0, 0.0, 0.0

            local heading = camRot.z * math.pi / 180.0

            -- Désactiver les animations de mouvement
            SetPedMoveRateOverride(playerPed, 0.0)

            if IsControlPressed(0, 33) then
                deltaX = deltaX + noClipSpeed * math.sin(heading)
                deltaY = deltaY - noClipSpeed * math.cos(heading)
            elseif IsControlPressed(0, 32) then
                deltaX = deltaX - noClipSpeed * math.sin(heading)
                deltaY = deltaY + noClipSpeed * math.cos(heading)
            end

            if IsControlPressed(0, 34) then
                deltaX = deltaX - noClipSpeed * math.cos(heading)
                deltaY = deltaY - noClipSpeed * math.sin(heading)
            elseif IsControlPressed(0, 35) then
                deltaX = deltaX + noClipSpeed * math.cos(heading)
                deltaY = deltaY + noClipSpeed * math.sin(heading)
            end

            if IsControlPressed(0, 38) then
                deltaZ = deltaZ - noClipSpeed
            elseif IsControlPressed(0, 44) then
                deltaZ = deltaZ + noClipSpeed
            end

            SetEntityCoordsNoOffset(playerPed, x + deltaX, y + deltaY, z + deltaZ, true, true, true)
        end
    end
end)
