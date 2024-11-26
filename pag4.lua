local composer = require("composer")
local C = require("Constants")

local scene = composer.newScene()

function scene:create(event)
    local sceneGroup = self.view

    -- Configuração de fundo inicial
    sceneGroup.fundo = display.newImage(sceneGroup, "Imagens/Pag4/FUNDO.png")
    sceneGroup.fundo.x = display.contentCenterX
    sceneGroup.fundo.y = display.contentCenterY

    -- Ervilha
    local ervilha = display.newImage(sceneGroup, "Imagens/Pag4/ERVILHA.png",
        C.W - 328 - C.MARGIN,
        C.H - 150 - C.MARGIN
    )
    ervilha:scale(1, 1) -- Escala inicial da ervilha

    -- Linha
    local linha = display.newImage(sceneGroup, "Imagens/Pag4/LINHA.png",
        C.W - 328 - C.MARGIN,
        C.H - 90 - C.MARGIN
    )

    -- Botão Mão Direita
    local maod = display.newImage(sceneGroup, "Imagens/Pag4/MAOD.png",
        C.W - 300 - C.MARGIN,
        C.H - 100 - C.MARGIN
    )

    -- Botão Mão Esquerda
    local maoe = display.newImage(sceneGroup, "Imagens/Pag4/MAOE.png",
        C.W - 350 - C.MARGIN,
        C.H - 100 - C.MARGIN
    )

    -- Limites de movimento para as mãos
    local limitXMin = C.W - 600 -- Limite esquerdo
    local limitXMax = C.W - 150 -- Limite direito
    local limitYMin = C.H - 150 -- Limite superior
    local limitYMax = C.H - 150 -- Limite inferior

    -- Distância inicial entre as mãos
    local initialDistance = math.sqrt((maod.x - maoe.x)^2 + (maod.y - maoe.y)^2)

    -- Função para ajustar o zoom da ervilha
    local function updateZoom()
        local currentDistance = math.sqrt((maod.x - maoe.x)^2 + (maod.y - maoe.y)^2)
        local scaleFactor = currentDistance / initialDistance

        -- Define limites para o zoom
        if scaleFactor < 0.5 then scaleFactor = 0.5 end -- Zoom mínimo
        if scaleFactor > 2.0 then scaleFactor = 2.0 end -- Zoom máximo

        -- Aplica o zoom na ervilha
        ervilha.xScale = scaleFactor
        ervilha.yScale = scaleFactor
    end

    -- Função de arraste para as mãos
    local function onDragTouch(event)
        if event.phase == "began" then
            display.getCurrentStage():setFocus(event.target)
            event.target.isFocus = true
        elseif event.target.isFocus then
            if event.phase == "moved" then
                -- Atualiza a posição dentro dos limites
                local newX = math.max(limitXMin, math.min(limitXMax, event.x))
                local newY = math.max(limitYMin, math.min(limitYMax, event.y))
                event.target.x = newX
                event.target.y = newY

                -- Atualiza o zoom com base na nova posição
                updateZoom()
            elseif event.phase == "ended" or event.phase == "cancelled" then
                event.target.isFocus = false
                display.getCurrentStage():setFocus(nil)
            end
        end
        return true
    end

    -- Adiciona o evento de toque para arrastar as mãos
    maod:addEventListener("touch", onDragTouch)
    maoe:addEventListener("touch", onDragTouch)

    -- Botão som
    local btsom = display.newImage(sceneGroup, "Imagens/Geral/LIGARSOM.png",
        C.W - 60 - C.MARGIN,
        C.H - 850 - C.MARGIN
    )
    local isSoundOn = false -- Inicialização do som

    -- Botão próximo
    local btNext = display.newImage(sceneGroup, "Imagens/Geral/PROXIMO.png",
        C.W - 250 - C.MARGIN,
        C.H + 1 - C.MARGIN
    )

    -- Botão anterior
    local btAnt = display.newImage(sceneGroup, "Imagens/Geral/ANTERIOR.png",
        C.W - 350 - C.MARGIN,
        C.H + 1 - C.MARGIN
    )

    -- Evento para o botão próximo
    local function onNextTap()
        composer.gotoScene("pag5", { effect = "fromRight", time = 1000 })
    end
    btNext:addEventListener("tap", onNextTap)

    -- Evento para o botão anterior
    local function onAntTap()
        composer.gotoScene("pag3", { effect = "fromLeft", time = 1000 })
    end
    btAnt:addEventListener("tap", onAntTap)

    -- Áudio de fundo
    local backgroundMusic = audio.loadStream("Audio/PAG4.mp3")

    -- Controle de som
    function btsom:touch(event)
        if event.phase == "began" then
            if isSoundOn then
                audio.stop()
                isSoundOn = false
                btsom.fill = { type = "image", filename = "Imagens/Geral/DESLIGARSOM.png" }
            else
                audio.play(backgroundMusic, { loops = -1 })
                isSoundOn = true
                btsom.fill = { type = "image", filename = "Imagens/Geral/LIGARSOM.png" }
            end
        end
        return true
    end
    btsom:addEventListener("touch", btsom)
end

-- Listener padrão da cena
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
