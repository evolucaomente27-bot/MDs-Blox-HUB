# 🔥 MDs HUB - Blox Fruits (Red Edition v6.0 Crimson | By GoltolaMD)

O **MDs HUB** é o script tudo-em-um mais completo para **Blox Fruits (Sea 1, Sea 2 e Sea 3)**. Com uma interface moderna **Vermelha Neon (Crimson Edition)** desenvolvida **By GoltolaMD**, ele traz máxima estabilidade, suporte nativo a dispositivos **Mobile (Delta, Codex, Arceus X, Fluxus)** e **PC (Solara, Wave, Synapse Z)**, com automações precisas e integração com os maiores hubs da atualidade (*Quantum Onyx, Bacon Hub, Redz Hub, Hoho Hub, W-Azure*).

---

## ⚡ Como Executar no seu Executor

### 🔹 Opção 1: Script Principal Direto (Recomendado)
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/evolucaomente27-bot/MDs-Blox-HUB/main/Main.lua"))()
```

### 🔹 Opção 2: Via Loader Oficial (Com Anti-AFK e Auto-Retry)
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/evolucaomente27-bot/MDs-Blox-HUB/main/Loader.lua"))()
```

---

## 🚀 Hubs Integrados no MDs HUB (Multi-Hub 1-Click)

Na aba **🚀 Multi-Hubs**, você pode executar instantaneamente ou definir para auto-carregar:
1. 🟣 **Quantum Onyx Hub:** `loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"))()`
2. 🥓 **Bacon Hub:** `loadstring(game:HttpGet("https://raw.githubusercontent.com/BaconScriptHub/BaconHub/main/New-BaconHub.lua.txt"))()`
3. 🔴 **Redz Hub (NewRedz):** `Settings = { JoinTeam = "Pirates", Translator = true }; loadstring(game:HttpGet("https://raw.githubusercontent.com/realreduz999/NewRedz/main/main.lua"))(Settings)`
4. ⚡ **Hoho Hub:** `loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI"))()`
5. 🌊 **W-Azure Hub:** `loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/3b2169cf53bc6104dabe8e19562e5cc2.lua"))()`

---

## 🧬 Recursos e Novidades da Versão 6.0 Crimson Edition

### 🎨 Nova UI Crimson & HUD em Tempo Real
- **Status Bar:** Monitor de **FPS** e **Ping (ms)** em tempo real no cabeçalho da interface.
- **Botão Flutuante Draggable:** Acesso rápido em qualquer lugar da tela, ideal para Mobile.
- **Salvamento de Configurações (JSON):** Suas preferências são salvas automaticamente em `MDs_Hub_Config.json` e recarregadas ao entrar no jogo.
- **Menu 100% Nativo em ScreenGui:** Sem dependências externas ou bibliotecas lentas.

### ⚔️ Auto Farm & Combate Seguro
- **Missões Corrigidas:** Sistema de detecção de missão com `QuestId` exato para o 1º e 2º monstro de cada NPC (Gorila, Brute, Snowman, etc.).
- **Banco de Dados Completo (Lv 1 ao 2550+):** Cobre Sea 1, Sea 2 e todo o Sea 3 até **Tiki Outpost**.
- **Anti-Rubberband & Anti-Drown:** Movimentação por tween suave com cálculo de altitude segura para evitar queda na água e morte por afogamento para usuários de frutas.
- **Ultra Fast Attack Híbrido:** Suporte universal com `CombatFramework` otimizado e fallback automático para executores de baixo nível.
- **Bring Mobs Inteligente:** Agrupa inimigos em até 350 studs e congela movimentação.
- **Auto Farm Nearest:** Elimina mobs próximos sem precisar aceitar missões (ideal para drops e maestria).
- **Auto Buso & Auto Ken Haki:** Ativação automática de Armamento e Observação (Instinct).

### 💰 Farm de Beli & Baús
- **Auto Chests:** Escaneamento automático e coleta de todos os baús do mapa com NoClip ativo para farm massivo de Beli e itens.
- **Auto Beli:** Combate contínuo aos NPCs mais próximos.

### 📍 Teleporte em 1 Clique por Ilhas
- Aba de Teleporte dedicada com todas as ilhas do Sea atual listadas em botões de 1 clique:
  - **Sea 1:** Starter Pirate, Starter Marine, Jungle, Pirate Village, Desert, Frozen Village, Marine Fortress, Skylands, Prison, Colosseum, Magma Village, Underwater City, Fountain City.
  - **Sea 2:** The Cafe, Kingdom of Rose, Green Zone, Graveyard, Snow Mountain, Hot and Cold, Cursed Ship, Ice Castle, Forgotten Island, Dark Arena.
  - **Sea 3:** Port Town, Hydra Island, Great Tree, Floating Turtle, Haunted Castle, Peanut Island, Ice Cream Island, Cake Island, Chocolate Island, Tiki Outpost, Temple of Time.
- Salvar e teleportar para posições customizadas no mapa.

### 🧬 Sistema Completo de Raças (V1 a V4)
- **Auto Raça V2:** Coleta automatizada da Flor Azul (noite), Flor Vermelha (dia), Flor Amarela (NPCs) e entrega ao Alquimista.
- **Auto Raça V3:** Missões de baú (Mink) e bosses (Human) integradas.
- **Raça V4 & Mirage Island:**
  - Detector e notificador em tempo real de aparição da **Mirage Island**.
  - Teleporte direto para o Ponto Mais Alto (Peak) da Mirage.
  - Alinhamento de câmera na Lua Cheia + ativação de ressonância.
  - Scanner e coleta instantânea da Engrenagem Azul (*Blue Gear*).
  - Puxar alavanca do Templo do Tempo (*Pull Lever*).
  - Teleporte para a porta da raça e auxílio no Trial.

### 👑 Bosses & Maestria de Espadas Lendárias
- **Auto Cake Prince & Dough King:** Contagem e farm de 500 mobs + combate ao Boss.
- **Auto Elite Hunter:** Elimina Deandre, Diablo e Urban no Sea 3.
- **Auto TTK Mastery:** Saddi, Shisui e Wando alternadas pela menor maestria.
- **Auto CDK Mastery:** Yama e Tushita alternadas com farm automático.

### 🍎 Frutas & Dealer
- **Auto Store:** Armazena frutas automaticamente no inventário.
- **Auto Collect:** Coleta frutas soltas caídas no chão do mapa.
- **Random Fruit:** Compra fruta aleatória no NPC Cousin com intervalo customizável.

### 🌐 Utilidades de Servidor
- **Server Hop:** Troca para um novo servidor público ativo.
- **Server Hop Low Player:** Conecta em servidores com pouquíssimos jogadores (1 a 5) para farm AFK seguro e sem caçadores de recompensa.
- **Rejoin Instantâneo:** Reconecta rapidamente ao mesmo servidor.
- **FPS Boost & Tela Preta:** Remove texturas pesadas e desativa a renderização 3D para economizar bateria e CPU em farms noturnos de 24 horas.

---

## 📁 Estrutura do Repositório

```
MDs-Blox-HUB/
├── Main.lua                  # Script principal Crimson Edition v6.0 All-in-One By GoltolaMD
├── Loader.lua                # Loader oficial com Anti-AFK e Auto-Retry
├── README.md                 # Documentação e guia completo de uso
└── analysis_gravity_hub.md   # Relatório técnico original do desmonte do Gravity Hub
```
