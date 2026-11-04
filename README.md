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
