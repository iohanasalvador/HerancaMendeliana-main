local composer = require("composer")
local physics = require("physics")
local C = require('Constants')

local scene = composer.newScene()

-- Variáveis para controlar o número de mudanças de fundo
local changeCount = 0
local maxChanges = 2 -- Alterado para 2 mudanças de fundo
local paginaFundo -- Declara a variável para o fundo globalmente

-- Função para mudar o fundo
local function changeBackground()
    if changeCount == 1 then
        paginaFundo.fill = { type = "image", filename = "Imagens/Pag2/FUNDO2.png" }
    elseif changeCount == 2 then
        paginaFundo.fill = { type = "image", filename = "Imagens/Pag2/FUNDO3.png" }
    end
end

-- Função para detectar o shake
local function celularmexendo(event)
    -- Verifica se o dispositivo foi sacudido
    if event.isShake then
        -- Se a contagem de mudanças de fundo for menor que o limite, altere o fundo
        if changeCount < maxChanges then
            changeCount = changeCount + 1
            changeBackground()
        end
    end
end

function scene:create(event)
    local sceneGroup = self.view

    -- Configuração de fundo inicial
    paginaFundo = display.newImage(sceneGroup, "Imagens/Pag2/FUNDO.png")
    paginaFundo.x = display.contentCenterX
    paginaFundo.y = display.contentCenterY

    -- Botão som
    local btsom = display.newImage(sceneGroup, "Imagens/Geral/LIGARSOM.png",
        C.W - 60 - C.MARGIN,
        C.H - 850 - C.MARGIN)
    local isSoundOn = false -- Inicialização do som

    -- Botão próximo
    local btNext = display.newImage(sceneGroup, "Imagens/Geral/PROXIMO.png",
        C.W - 250 - C.MARGIN,
        C.H + 1 - C.MARGIN)

    -- Botão anterior
    local btAnt = display.newImage(sceneGroup, "Imagens/Geral/ANTERIOR.png",
        C.W - 350 - C.MARGIN,
        C.H + 1 - C.MARGIN)

    -- Evento para o botão próximo
    local function onNextTap()
        changeBackground()
        timer.performWithDelay(500, function()
            composer.gotoScene("pag3", { effect = "fromRight", time = 1000 })
        end)
    end
    btNext:addEventListener("tap", onNextTap)

    -- Evento para o botão anterior
    local function onAntTap()
        composer.gotoScene("pag1", { effect = "fromLeft", time = 1000 })
    end
    btAnt:addEventListener("tap", onAntTap)

    -- Áudio de fundo
    local backgroundMusic = audio.loadStream("Audio/PAG2.mp3")

    -- Controle de som
    function btsom:touch(event)
        if event.phase == "began" then
            if isSoundOn then
                audio.stop()
                isSoundOn = false
                btsom.fill = { type = "image", filename = "Imagens/Geral/DESLIGARSOM.png" }
            else
                audio.play(backgroundMusic)
                isSoundOn = true
                btsom.fill = { type = "image", filename = "Imagens/Geral/LIGARSOM.png" }
            end
        end
        return true
    end
    btsom:addEventListener("touch", btsom)

    -- Inicia o monitoramento do acelerômetro para detectar shakes
    Runtime:addEventListener("accelerometer", celularmexendo)
end

-- Listener padrão da cena
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
