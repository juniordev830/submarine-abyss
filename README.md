# Submarine Abyss

**Status:** MVP inicial de exploração submarina 3D em Godot 4.2+ (GDScript).

## Jogabilidade
- Controle um submarino 3D em um cenário subaquático geométrico com rochas, corais, neblina e iluminação azul.
- Explore a região para encontrar **cinco pérolas luminosas**.
- O oxigênio diminui com o tempo; cada pérola recupera uma parte do oxigênio.
- Vence ao encontrar cinco pérolas antes de o oxigênio acabar.

## Controles
- **W/S ou setas para cima/baixo:** avançar e recuar.
- **A/D ou setas esquerda/direita:** girar.
- **Q/E:** descer/subir.
- **R:** reiniciar expedição.

## Rodar
Instale Godot 4.2+ (edição padrão), abra `project.godot` e pressione **F5**.

## Testar regras
```bash
godot --headless --path . --script tests/test_oxygen.gd
```

A CI também verifica a abertura do projeto por alguns frames em modo headless.

## Estrutura
- `scripts/submarine.gd`: controles e representação 3D do submarino.
- `scripts/ocean.gd`: geração do ambiente, pérolas e interface.
- `scripts/oxygen_rules.gd`: regras puras de oxigênio e coleta.
- `tests/test_oxygen.gd`: testes de regras.

## Limites
Protótipo de formas geométricas, sem biomas, inimigos, narrativas, áudio, efeitos avançados de água nem salvamento. É um jogo experimental, não uma simulação de mergulho real.


## Consumo variável de oxigênio (novo)

A quantidade de oxigênio consumida por segundo agora depende da profundidade **simulada**. Quanto mais baixo o submarino estiver no cenário, maior será a taxa: o valor base é **1,5 unidade/s**, aumentando gradualmente até o dobro em profundidades maiores. O HUD exibe a profundidade do jogo e uma estimativa dos segundos restantes se a taxa atual permanecer constante.

O cálculo está isolado em `scripts/oxygen_rules.gd` e é verificado por novos testes em `tests/test_oxygen.gd`. A estimativa não prevê movimentos futuros, reposição por pérolas nem mudanças de profundidade.

**Atenção:** as regras são de um jogo e não representam consumo de ar, limites ou procedimentos seguros de mergulho reais.

## Sonar de localização

Pressione **Espaço** durante a expedição para ativar o sonar por **3 segundos**. O HUD mostra a direção cardeal (ou `SUBIR`/`DESCER`) e a distância até a pérola mais próxima ainda não coletada. A recarga é de **8 segundos** e começa na ativação. O alvo é recalculado enquanto o sonar estiver ativo; assim, ao coletar uma pérola, a próxima é indicada automaticamente.

O sonar é uma ajuda de navegação baseada nas coordenadas do jogo, sem representar um equipamento real. As regras de seleção, distância e direção são cobertas em `tests/test_oxygen.gd`.
