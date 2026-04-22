# Knowledge Engine - World Happiness Report 2015

## Objetivo
Este projeto constrói uma base de conhecimento em Prolog a partir do dataset World Happiness Report 2015 e realiza consultas lógicas sobre felicidade, economia, saúde, liberdade, confiança governamental e generosidade.

## Dataset
Arquivo utilizado: `2015.csv`

Campos selecionados:
- Country
- Region
- Happiness Rank
- Happiness Score
- Economy (GDP per Capita)
- Health (Life Expectancy)
- Freedom
- Trust (Government Corruption)
- Generosity

## Estrutura do projeto
- `2015.csv`: dataset original
- `generate_prolog.py`: script em Python que gera os fatos Prolog
- `base_felicidade.pl`: base de conhecimento gerada
- `regras_e_consultas.pl`: regras e consultas em Prolog

## Como gerar a base
Execute:

```bash
python generate_prolog.py