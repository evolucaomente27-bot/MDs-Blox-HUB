# 🔍 Análise Estrutural e Desmonte do Gravity Hub

Este documento apresenta a dissecação técnica do script original do **Gravity Hub** (`Main.lua`), identificando seus componentes, como funciona por baixo dos panos e os riscos associados ao código original.

---

## 1. Estrutura Original do Código

O arquivo original do Gravity Hub (`Main.lua`) continha a seguinte estrutura:

```lua
task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/traurobloxdeptrai/traukhoaito/refs/heads/main/anhdomixi.lua"))()
    end)
end)
task.spawn(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/teddyhubdev/diepvy/refs/heads/main/cantrom"))()
    end)
end)
return(function(...)
    -- Tabela de strings em Base64 / Bytecode obfuscado
    local C={"N+r4Nea="; "OSHw39==" ...}
    -- Máquina Virtual (VM) Lua customizada / Interpretador de Bytecode
    ...
end)
```

---

## 2. O que cada parte estava fazendo ("Desmonte")

### 🔹 A. Os Sub-Loaders Ocultos (`task.spawn`)
Nas primeiras 18 linhas, o Gravity Hub disparava duas threads assíncronas em segundo plano:
1. **`anhdomixi.lua`** (`traurobloxdeptrai/traukhoaito`):
   - Trata-se de um script compilado e protegido com **Luraph Obfuscator v15.0**.
   - É o núcleo de um hub vietnamita (*Trau Hub / Trau Khoai To*), contendo rotinas de auto-farm e teleporte para Blox Fruits.
2. **`cantrom`** (`teddyhubdev/diepvy`):
   - Script protegido com **Luraph Obfuscator v14.8**.
   - Trata-se de outro hub legado (*Teddy Hub*).

> **Diagnóstico:** O Gravity Hub é o que a comunidade chama de script "skidded" (amálgama/montagem) — ele atua como um wrapper que executa múltiplos scripts de terceiros simultaneamente sem otimização ou controle de conflitos.

### 🔹 B. O Payload Principal (Máquina Virtual / De-obfuscator)
A partir da linha 19, o script executa um interpretador de bytecode customizado:
- **Tabela de strings codificada:** Array de strings no formato Base64/XOR.
- **Tabela de decodificação `G`:** Mapeamento de caracteres para inteiros usando operações de bitwise (`floor`, `sub`, `concat`, etc.).
- **Desemaranhamento de instruções:** Uma máquina de estados que manipula o ambiente de execução (`getfenv`, `setfenv`, registradores `e[...]`, tabelas de chamadas dinâmicas) para impedir leitura direta por humanos e ferramentas antivírus.

---

## 3. Problemas e Riscos do Gravity Hub Original

1. **Instabilidade e Queda de FPS (Crashes):** Como executa 2 a 3 scripts pesados ao mesmo tempo em segundo plano (`Trau Hub` + `Teddy Hub` + `Payload Local`), ele causa sobreposição de hooks no `RenderStepped`/`Heartbeat`, gerando alto consumo de memória e desconexões por lag.
2. **Falta de Manutenção:** Se qualquer um dos repositórios externos (`traurobloxdeptrai` ou `teddyhubdev`) for deletado ou atualizado com quebras, o script inteiro para de funcionar.
3. **Risco de Segurança / Backdoor:** Código obfuscado por terceiros pode injetar webhooks de Discord para roubar dados de inventário, cookies de sessão ou executar comandos arbitrários no executor.

---

## 4. Como o MDs HUB foi reconstruído

Para transformar o Gravity Hub no **MDs HUB**:
1. **Remoção de dependências inseguras:** Eliminou-se o carregamento de URLs obsoletas/obfuscadas de terceiros.
2. **Código Aberto e Modular:** Toda a lógica de Auto Farm, Tweening Seguro, Auto Stats, Fruit Sniper, ESP e Teleporte foi escrita em Lua limpo e comentado.
3. **Interface Moderna (UI):** Criação de uma interface responsiva, com suporte total a Mobile (Delta, Codex, Arceus X, Fluxus) e PC (Solara, Wave, Synapse Z).
4. **Segurança e Anti-Ban:** Implementação de Tween suave com Bypass de velocidade e prevenção de Kick por Anti-AFK.
