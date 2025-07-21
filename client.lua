local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand('openmenu', function()
    local player = PlayerId()
    local playerPed = PlayerPedId()
    local playerData = QBCore.Functions.GetPlayerData()

    local id = GetPlayerServerId(player)
    local name = GetPlayerName(player)
    local firstName = playerData.charinfo.firstname or "N/D"
    local lastName = playerData.charinfo.lastname or "N/D"
    local job = playerData.job.label or "Nessun lavoro"
    local grade = playerData.job.grade.name or ""
    local onDuty = playerData.job.onduty and "✅ In servizio" or "❌ Fuori servizio"

    lib.registerContext({
        id = 'main_context_menu',
        title = '🎒 Menù Personale',
        options = {
            {
                title = 'Info Personali ID: ' .. tostring(id),
                description = 'Visualizza le tue informazioni',
                icon = 'fa-solid fa-id-card',
                menu = 'info_personali_menu',
            },
            {
                title = 'Fatture',
                icon = 'fa-solid fa-file-invoice',
                onSelect = function()
                    lib.hideContext() -- chiude il context menu
                    ExecuteCommand("invoices") -- esegue il comando come se lo scrivessi in chat
                end
            },
            {
                title = 'Atti e Documenti',
                icon = 'fa-solid fa-folder',
                onSelect = function()
                    lib.hideContext() -- chiude il context menu
                    ExecuteCommand("documents") -- esegue il comando come se lo scrivessi in chat
                end
            },
            {
                title = 'Stato Fisico',
                icon = 'fa-solid fa-x-ray',
                onSelect = function()
                    lib.hideContext() -- chiude il context menu
                    ExecuteCommand("skelly") -- esegue il comando come se lo scrivessi in chat
                end
            },
            {
                title = 'Finanziamenti Veicoli',
                icon = 'fa-solid fa-coins',
                onSelect = function()
                    lib.hideContext() -- chiude il context menu
                    ExecuteCommand("finanziamentiauto") -- esegue il comando come se lo scrivessi in chat
                end
            },
            {
                title = 'Rimuovi GAP',
                icon = 'fa-solid fa-shield-halved',
                onSelect = function()
                    lib.hideContext() -- chiude il context menu
                    ExecuteCommand("rimuovigap") -- esegue il comando come se lo scrivessi in chat
                end
            },
            {
                title = 'Fix prop attaccati',
                icon = 'fa-solid fa-wrench',
                onSelect = function()
                    lib.hideContext() -- chiude il context menu
                    ExecuteCommand("propfix") -- esegue il comando come se lo scrivessi in chat
                end
            },
            {
                title = 'HUD e Grafica',
                description = 'Modifica ciò che vedi nel tuo schermo',
                icon = 'fa-solid fa-desktop',
                menu = 'info_hud_setting',
            },
            {
                title = '🔧 Funzioni Extra',
                description = 'Sezione in arrivo...',
                icon = 'fa-solid fa-gears',
                disabled = true
            }
        }
    })

    lib.registerContext({
        id = 'info_personali_menu',
        title = '🧍 Info Personali',
        menu = 'main_context_menu',
        options = {
            {
                title = '🆔 ' .. tostring(id),
                onSelect = function()
                    lib.showContext('info_personali_menu')
                end
            },
            {
                title = '👤 ' .. firstName .. ' ' .. lastName,
                onSelect = function()
                    lib.showContext('info_personali_menu')
                end
            },
            {
                title = '💼 ' .. job .. (grade ~= "" and ' - ' .. grade or ''),
                onSelect = function()
                    lib.showContext('info_personali_menu')
                end
            },
            {
                title = 'Stato Servizio',
                description = onDuty,
                icon = playerData.job.onduty and 'fa-solid fa-toggle-on' or 'fa-solid fa-toggle-off',
                onSelect = function()
                    TriggerServerEvent('QBCore:ToggleDuty')
                    Wait(300) -- piccolo delay per aggiornare i dati
                    local newData = QBCore.Functions.GetPlayerData()
                    local updatedDuty = newData.job.onduty and "✅ In servizio" or "❌ Fuori servizio"
                end
            }            
        }
    })

    lib.registerContext({
        id = 'info_hud_setting',
        title = '🖥️ HUD e Grafica',
        menu = 'main_context_menu',
        options = {
            {
                title = 'Apri Impostazioni HUD',
                onSelect = function()
                    lib.hideContext() -- chiude il context menu
                    ExecuteCommand("hudmenu") -- esegue il comando come se lo scrivessi in chat
                end
            },
            {
                title = 'Attiva/disattiva Cinematica',
                disabled = true
                --[[onSelect = function()
                    lib.hideContext() -- chiude il context menu
                    ExecuteCommand("hud") -- esegue il comando come se lo scrivessi in chat
                end]]--
            },
            {
                title = 'Mostra/nascondi Chat',
                disabled = true
                --[[onSelect = function()
                    lib.hideContext() -- chiude il context menu
                    ExecuteCommand("hud") -- esegue il comando come se lo scrivessi in chat
                end]]--
            }         
        }
    })
    
    

    lib.showContext('main_context_menu')
end)

lib.addKeybind({
    name = 'openmenu_key',
    description = 'Apri il menu principale',
    defaultKey = 'F5',
    onPressed = function()
        ExecuteCommand('openmenu')
    end
})
