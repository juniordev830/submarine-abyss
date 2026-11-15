# Submarine Abyss

Protótipo de exploração submarina com **modelo de missão em Python**: deslocamento 3D abstrato, recursos finitos, limites de profundidade, coleta e entrega. Ambiente visual 3D e build jogável permanecem planejados.

> **Estado da `main`:** lógica de missão em `core.py`, testes em `tests/test_core.py` e workflow de CI. Ainda não há cenas, interface gráfica ou veículo controlável visualmente.

## Vertical slice

Uma pequena região submersa com submarino controlável, medidor de energia e oxigênio fictícios, ponto de coleta e retorno à base. Objetivo: completar uma missão simples sem esgotar os recursos.

## Regras para desenvolver

- Profundidade, posição e energia têm limites bem definidos.
- Movimento vertical deve respeitar superfície e fundo da região.
- Uma coleta pode acontecer apenas quando o submarino estiver no alcance.
- Energia não pode se tornar negativa nem ser gasta duas vezes em um único evento.
- Missão passa de pendente para concluída ao entregar o item na base.

## Critérios de aceitação

1. O submarino se move nos três eixos com controle previsível.
2. A interface mostra profundidade e recursos atuais.
3. Coletar fora do alcance não produz item.
4. Retornar à base após a coleta encerra a missão.
5. É possível reiniciar o cenário e repetir resultado com configurações iguais.

## Etapas

- [ ] Definir engine, coordenadas e câmera subaquática.
- [x] Criar domínio com testes de limites de profundidade e recursos.
- [ ] Montar cenário pequeno de teste, com assets licenciados.
- [ ] Adicionar interação e objetivo único.
- [ ] Medir desempenho em hardware de referência e registrar comandos.

Não prometer comportamento realista de pressão oceânica ou segurança de navegação.

## Primeiro incremento de código (disponível na `main`)

Exploração em três eixos com limites de profundidade, energia, oxigênio, coleta e entrega de missão.

O arquivo `core.py` contém a implementação executável em Python 3.11+ e `tests/test_core.py` cobre regras, entradas inválidas e repetibilidade. Não há engine 3D, UI gráfica, asset ou build final nesta entrega; o protótipo é de **domínio/testes**.

Para executar a demonstração:

```bash
python core.py
```

Para verificar o comportamento:

```bash
python -m unittest discover -s tests -p 'test_*.py' -v
```

O GitHub Actions executa a suíte em cada PR. A lista de tarefas do roteiro acima descreve o objetivo completo do jogo e não deve ser interpretada como pronto para publicação.
