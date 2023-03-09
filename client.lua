local ParticleViewer = {}
---@type number
ParticleViewer.ParticleHandle = nil
---@type boolean
ParticleViewer.isPlaying = false
ParticleViewer.Data = {}
---@type string
ParticleViewer.Data.Dictionary = nil
---@type string
ParticleViewer.Data.Fx = nil
---@type number
ParticleViewer.Data.Scale = nil

function ParticleViewer:Stop()
    if DoesParticleFxLoopedExist(self.ParticleHandle) then
        RemoveParticleFx(self.ParticleHandle, false)
    end
end

function ParticleViewer:Play()
    if not self.isPlaying then return end

    local localPlayer = PlayerPedId()

    if DoesParticleFxLoopedExist(self.ParticleHandle) then
        RemoveParticleFx(self.ParticleHandle, false)
    end

    RequestNamedPtfxAsset(self.Data.Dictionary)
    while not HasNamedPtfxAssetLoaded(self.Data.Dictionary) do
        Citizen.Wait(10)
    end

    UseParticleFxAssetNextCall(self.Data.Dictionary)

    if not DoesParticleFxLoopedExist(self.ParticleHandle) then
        self.ParticleHandle = StartParticleFxLoopedOnEntity(
            self.Data.Fx,
            localPlayer,
            0.0,
            1.0,
            0.0,
            0.0,
            0.0,
            0.0,
            tonumber(self.Data.Scale) + 0.0,
            false,
            false,
            false,
            false
        )
    end
end

---@param state boolean
function ParticleViewer:SetPlayingState(state)
    self.isPlaying = state

    if self.isPlaying then
        self:Play()
        DisableIdleCamera(true)
    else
        self:Stop()
        DisableIdleCamera(false)
    end
end

function ParticleViewer:UpdateScale()
    if not self.isPlaying then return end

    if DoesParticleFxLoopedExist(self.ParticleHandle) then
        SetParticleFxLoopedScale(self.ParticleHandle, tonumber(self.Data.Scale) + 0.0)
    end
end

function ParticleViewer:Open()
    SendNUIMessage({
        event = "SET_OPEN_STATE",
        state = true
    })
end

function ParticleViewer:Close()
    SendNUIMessage({
        event = "SET_OPEN_STATE",
        state = false
    })
end

function ParticleViewer:onOpened()
    InvalidateIdleCam()
    InvalidateVehicleIdleCam()
    SetNuiFocus(true, true)
end

function ParticleViewer:onClosed()
    SetNuiFocus(false, false)
    self:Stop()
end

RegisterNUICallback("SET_PLAYING_STATE", function(data, cb)
    ParticleViewer:SetPlayingState(data.state)
    cb({})
end)
RegisterNUICallback("SET_PARTICLE_DATA_ON_MOUNTED", function(data, cb)
    ParticleViewer.Data.Dictionary = data.dictionary
    ParticleViewer.Data.Fx = data.particleFx
    ParticleViewer.Data.Scale = data.scale
    cb({})
end)
RegisterNUICallback("CHANGE_PARTICLE", function(data, cb)
    ParticleViewer.Data.Dictionary = data.dictionary
    ParticleViewer.Data.Fx = data.particleFx
    ParticleViewer:Play()
    cb({})
end)
RegisterNUICallback("CHANGE_PARTICLE_SCALE", function(data, cb)
    ParticleViewer.Data.Scale = data.scale
    ParticleViewer:UpdateScale()
    cb({})
end)
RegisterNUICallback("SET_CURSOR_STATE", function(data, cb)
    local state = data.state
    if state then
        ParticleViewer:onOpened()
    else
        ParticleViewer:onClosed()
    end
    cb({})
end)
RegisterCommand("particle_open", function()
    ParticleViewer:Open()
end)
RegisterCommand("particle_close", function()
    ParticleViewer:Close()
end)