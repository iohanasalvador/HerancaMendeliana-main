local C = require('Constants')
local composer = require("composer")
local physics = require("physics")

local scene = composer.newScene()

function scene:create(event)
    local sceneGroup = self.view

    -- Configuração de fundo
    local paginaFundo = display.newImage(sceneGroup, "Imagens/Pag1/FUNDO.png")
    paginaFundo.x = display.contentCenterX
    paginaFundo.y = display.contentCenterY

-- Evolução das Plantas
    -- Inicialmente, carregue a primeira imagem
    local plantImages = {
      "Imagens/Pag1/PLANTA1.png",
      "Imagens/Pag1/PLANTA2.png",
      "Imagens/Pag1/PLANTA3.png",
      "Imagens/Pag1/PLANTA4.png"
  }

  -- Índice da imagem atual
  local currentImageIndex = 1

  -- Cria o botão de planta com a primeira imagem e escala ajustada
  local btplanta = display.newImage(sceneGroup, plantImages[currentImageIndex])
  btplanta.x = C.W - 330 - C.MARGIN
  btplanta.y = C.H - 200 - C.MARGIN

  -- Função para alterar a imagem e redimensionar dinamicamente
  local function changePlantImage()
      -- Atualiza o índice para a próxima imagem
      currentImageIndex = currentImageIndex + 1

      -- Reinicia o índice quando todas as imagens forem exibidas
      if currentImageIndex > #plantImages then
          currentImageIndex = 1
      end

      -- Atualiza a textura do botão
      btplanta.fill = { type = "image", filename = plantImages[currentImageIndex] }

      -- Ajusta o tamanho do botão com base no índice (exemplo de adaptação)
      if currentImageIndex == 1 then
          btplanta.width, btplanta.height = 200, 200
      elseif currentImageIndex == 2 then
          btplanta.width, btplanta.height = 300, 250
      elseif currentImageIndex == 3 then
          btplanta.width, btplanta.height = 500, 280
      else
          btplanta.width, btplanta.height = 500, 280
      end
  end

  -- Adicionar evento de toque ao botão planta
  btplanta:addEventListener("tap", changePlantImage)


    -- Botão som
    local btsom = display.newImage(sceneGroup, "Imagens/Geral/LIGARSOM.png",
        C.W - 60 - C.MARGIN,
        C.H - 850 - C.MARGIN)
    local isSoundOn = false -- Inicialização

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
        composer.gotoScene("pag2", { effect = "fromRight", time = 1000 })
    end
    btNext:addEventListener("tap", onNextTap)
  
    -- Evento para o botão anterior
    local function onAntTap()
        composer.gotoScene("capa", { effect = "fromLeft", time = 1000 })
    end
    btAnt:addEventListener("tap", onAntTap)

    -- Áudio de fundo
    local backgroundMusic = audio.loadStream("Audio/PAG1.mp3")

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
end

-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Código executado antes da cena aparecer na tela
    elseif (phase == "did") then
        -- Código executado quando a cena está visível
    end
end

-- hide()
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Código executado antes da cena desaparecer
    elseif (phase == "did") then
        -- Código executado depois que a cena saiu da tela
    end
end

-- destroy()
function scene:destroy(event)
    local sceneGroup = self.view
    -- Limpeza de objetos e listeners
end

-- Listener setup
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
