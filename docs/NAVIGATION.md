# Navegação submarina — protótipo

Módulo independente do motor gráfico com posição 2D, profundidade, bateria, oxigênio e verificação de objetivos.

## Executar

```bash
python navigation.py
python -m unittest discover -s tests -v
```

## Limitações

Modelo simplificado: não inclui correntes marítimas, colisões, pressão, física de flutuação nem recarga. Integrar posteriormente ao controlador 3D e às missões do jogo.
