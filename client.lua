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
ParticleViewer.Data.Color = nil
ParticleViewer.Data.Evolution = {};

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

function ParticleViewer:UpdateColor()
    if not self.isPlaying then return end

    if DoesParticleFxLoopedExist(self.ParticleHandle) then
        SetParticleFxLoopedColour(self.ParticleHandle, self.Data.Color.r, self.Data.Color.g, self.Data.Color.b, false);
		SetParticleFxLoopedAlpha(self.ParticleHandle, self.Data.Color.a);
    end
end

function ParticleViewer:UpdateEvolution()
    if not self.isPlaying then return end

    if DoesParticleFxLoopedExist(self.ParticleHandle) then
		for k, v in pairs(self.Data.Evolution) do
			SetParticleFxLoopedEvolution(self.ParticleHandle, k, tonumber(v) + 0.0, false);
		end
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
	ParticleViewer.Data.Color = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 }
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
RegisterNUICallback("CHANGE_PARTICLE_COLOR", function(data, cb)
    ParticleViewer.Data.Color = data.color
    ParticleViewer:UpdateColor()
    cb({})
end)
RegisterNUICallback("CHANGE_EVOLUTION_PROPERTY", function(data, cb)
    ParticleViewer.Data.Evolution[data.name] = data.value;
    ParticleViewer:UpdateEvolution();
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
RegisterCommand("pv_open", function()
    ParticleViewer:Open()
end)
RegisterCommand("pv_close", function()
    ParticleViewer:Close()
end)
exports("Open", function()
    ParticleViewer:Open()
end)
exports("Close", function()
    ParticleViewer:Close()
end)
