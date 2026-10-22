-- ==========================================================
-- SUPER DIGGER - SCRIPT AUTORAL (ZERO COPY)
-- Funcoes: Camera afastada, Bases Transparentes, Tecla T
-- ==========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- ==========================================================
-- 1. CAMERA AFASTADA (Estilo 1ª imagem)
-- ==========================================================
-- Forca o zoom maximo para longe e ajusta o campo de visao
player.CameraMaxZoomDistance = 120
player.CameraMinZoomDistance = 35

-- Ajuste do FOV para dar aquele efeito "afastado" sem distorcer
camera.FieldOfView = 75

-- ==========================================================
-- 2. BASES TRANSPARENTES (Estilo 2ª imagem)
-- ==========================================================
-- Percorre todas as partes do mapa e deixa as bases/estruturas fixas transparentes
local function aplicarTransparencia()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            -- Ignora o seu personagem e o dos outros jogadores
            if not obj:IsDescendantOf(player.Character or Workspace) then
                -- Verifica se a parte e grande ou fixa (provavel base/parede)
                if obj.Anchored == true and obj.Size.Magnitude > 15 then
                    obj.Transparency = 0.5 -- Deixa translucida
                    obj.CanCollide = true  -- Mantem a colisao para voce nao cair
                end
            end
        end
    end
end

-- Aplica a transparencia ao iniciar
aplicarTransparencia()

-- Re-aplica caso o jogo carregue novas partes depois
Workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("BasePart") and obj.Anchored == true then
        task.wait(0.5)
        if obj.Size.Magnitude > 15 then
            obj.Transparency = 0.5
        end
    end
end)

-- ==========================================================
-- 3. TECLA T - VIRAR DE CABECA PARA BAIXO E AFUNDAR
-- ==========================================================
local flipAtivo = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.T then
        local char = player.Character
        if not char then return end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        
        if not root or not humanoid then return end
        
        flipAtivo = not flipAtivo
        
        if flipAtivo then
            -- Vira 180 graus (de cabeca para baixo) e afunda 3 studs no chao
            humanoid.PlatformStand = true
            root.CFrame = root.CFrame * CFrame.Angles(math.rad(180), 0, 0)
            root.CFrame = root.CFrame + Vector3.new(0, -3, 0)
        else
            -- Volta ao normal
            humanoid.PlatformStand = false
            root.CFrame = root.CFrame * CFrame.Angles(math.rad(-180), 0, 0)
            root.CFrame = root.CFrame + Vector3.new(0, 3, 0)
        end
    end
end)
