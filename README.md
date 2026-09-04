# 🔥 MDs HUB - Blox Fruits (Red Edition v5.0 | By GoltolaMD)

O **MDs HUB** agora conta com uma interface **Vermelha Neon (Crimson Edition)**, desenvolvida **By GoltolaMD**, reunindo em um só lugar os melhores recursos de automação e integração com múltiplos scripts renomados (*Quantum Onyx, Bacon Hub, NewRedz*).

---

## ⚡ Como Executar no seu Executor (Delta, Fluxus, Solara, Wave, Codex, Arceus X)

### 🔹 Opção 1: Script Principal Direto (Recomendado)
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/evolucaomente27-bot/MDs-Blox-HUB/main/Main.lua"))()
```

### 🔹 Opção 2: Via Loader Oficial (Com Anti-AFK integrado)
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/evolucaomente27-bot/MDs-Blox-HUB/main/Loader.lua"))()
```

---

## 🚀 Hubs Integrados no MDs HUB (Multi-Hub 1-Click)

Na nova aba **🚀 Multi-Hubs**, você pode executar instantaneamente ou definir para auto-execução:
1. 🟣 **Quantum Onyx Hub:** `loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"))()`
2. 🥓 **Bacon Hub:** `loadstring(game:HttpGet('https://raw.githubusercontent.com/BaconScriptHub/BaconHub/main/New-BaconHub.lua.txt'))()`
3. 🔴 **Redz Hub (NewRedz):** `Settings = { JoinTeam = "Pirates", Translator = true }; loadstring(game:HttpGet("https://raw.githubusercontent.com/realreduz999/NewRedz/main/main.lua"))(Settings)`

---

## 🧬 Recursos Completos do MDs HUB v5.0

### 🎨 Nova UI Vermelha (Crimson Theme By GoltolaMD)
- Design Dark com realces em **Vermelho Neon**.
- Botão flutuante estilizado para **Mobile e PC**.
- Menu 100% nativo em `ScreenGui`, sem dependência de bibliotecas externas que possam falhar.

### ⚔️ Auto Farm & Ultra Fast Attack
- **Multi-Hits por Frame:** Sem cooldown de animação de arma.
- **Bring Mobs Inteligente:** Agrupa e congela inimigos em até 280 studs.
- **Auto Farm Level:** Do nível 1 ao 2550+ (Sea 1, 2 e 3).
- **Auto Buso Haki:** Ativação automática de Armamento.
- **Qualquer item:** escolha uma ferramenta do inventário para usar no farm.
- **Auto Beli:** combate NPCs próximos para obter recompensas em Beli.

### 🍎 Frutas e PvP
- **Auto Fruit:** encontra, coleta e armazena frutas encontradas no mapa, com compra aleatória opcional e intervalo configurável.
- **PvP Combo:** modo opcional de combo por Melee, Sword ou Blox Fruit em inimigos próximos.

### 🎛️ Controles aprimorados
- **Escolha de arma:** Melee, Sword, Gun ou Blox Fruit para o Auto Farm.
- **Ajustes graduais:** distância do alvo, raio de Bring Mobs, ataques por ciclo e pontos por distribuição.
- **Jogador:** WalkSpeed, JumpPower, pulo infinito e Full Bright configuráveis.
- **Parar automações:** botão único para interromper os loops nativos e o tween ativo.
- **Teleporte dedicado:** aba própria com coordenadas X/Y/Z, posição salva, cancelamento e viagem em etapas que parte da posição atual a cada trecho.

### 🌌 Sistema Completo de Raças (V1 até V4)
- **Raça V1:** Reroll com NPC Tort no Sea 2.
- **Raça V2:** Auto coleta de Flores Azul, Vermelha e Amarela + Alquimista.
- **Raça V3:** Auto Missão do Arowe (30 baús Mink, Bosses Human, etc.).
- **Raça V4 (Templo do Tempo & Mirage):**
  - Alerta de Mirage Island e teleporte para o topo da montanha.
  - Alinhamento de câmera na Lua Cheia + ativação de ressonância V3.
  - Scanner e coleta instantânea da Engrenagem Azul (*Blue Gear*).
  - Puxar alavanca do Templo do Tempo (*Pull Lever*).
  - Teleporte para a porta da sua raça e resolução automática dos Trials (*Mink, Angel, Shark, Human, Ghoul, Cyborg*).
- Auto despertar e treino de V4 em combate.
- Preparação do Trial: rota em etapas até o Templo do Tempo e porta da raça, com ativação periódica da transformação.

### ⚔️ Espadas lendárias (TTK e CDK)
- Seleção de espada preferida para o farm e alternância pela menor maestria disponível.
- Auto maestria de Saddi, Shisui e Wando para a TTK.
- Auto maestria de Yama e Tushita para a CDK, além de combate ao Cursed Skeleton Boss quando ele estiver disponível.

### 👑 Bosses & Sea Events (Sea 3)
- **Auto Cake Prince & Dough King:** Farma a contagem de 500 mobs e derrota o chefe.
- **Auto Elite Hunter:** Elimina Deandre, Diablo e Urban.

### 🍎 Frutas & Dealer
- **Auto Store:** Armazena frutas automaticamente no inventário.
- **Random Fruit:** Compra fruta aleatória no NPC Cousin.

### 🖤 Otimização & AFK Mode
- **Modo Tela Preta / AFK Saver:** Desativa a renderização 3D (`Set3dRenderingEnabled(false)`) para economizar bateria e CPU em farms noturnos de 24h.
- **FPS Booster:** Remove texturas pesadas e sombras para 60 FPS garantidos.

---

## 📁 Estrutura do Repositório

```
MDs-Blox-HUB/
├── Main.lua                  # Script principal Red Edition All-in-One By GoltolaMD
├── Loader.lua                # Loader com Anti-AFK e notificações
├── README.md                 # Documentação e instruções de loadstring
└── analysis_gravity_hub.md   # Relatório técnico do desmonte do Gravity Hub
```
