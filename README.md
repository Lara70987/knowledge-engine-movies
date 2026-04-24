# Projeto: Knowledge Engine com Prolog (Felicidade dos Países)

## Sobre o projeto

Este projeto tem como objetivo simular um mecanismo de busca utilizando Lógica de Primeira Ordem. A proposta segue a ideia dos primeiros sistemas de Inteligência Artificial, nos quais as respostas são obtidas a partir de inferência lógica sobre uma base de conhecimento.

Foi utilizado o dataset **World Happiness Report 2015**, disponível no Kaggle. A partir desse conjunto de dados, foi construída uma base em Prolog com 158 fatos, junto com regras encadeadas que permitem responder perguntas sofisticadas sobre os países.

---

## Como o projeto foi feito

O dataset em formato CSV foi processado com um script Python para gerar os fatos no formato Prolog.

O script realiza as seguintes etapas:

- leitura do arquivo CSV
- normalização dos nomes (remoção de acentos, uso de minúsculas e substituição de espaços por underscores)
- conversão dos valores numéricos para float
- geração dos fatos no arquivo `base_felicidade.pl`

Formato utilizado:

```prolog
felicidade(pais, regiao, rank, score, gdp, saude, liberdade, confianca, generosidade).
```

Exemplo:

```prolog
felicidade(switzerland,western_europe,1,7.587,1.39651,0.94143,0.66557,0.41978,0.29678).
```

---

## Estrutura da base

Cada fato `felicidade/9` contém:

| Campo | Descrição | Tipo |
|---|---|---|
| pais | nome do país | qualitativo |
| regiao | região geográfica | qualitativo |
| rank | posição no ranking de felicidade | quantitativo |
| score | índice de felicidade (0–10) | quantitativo |
| gdp | PIB per capita | quantitativo |
| saude | expectativa de vida | quantitativo |
| liberdade | índice de liberdade | quantitativo |
| confianca | confiança no governo | quantitativo |
| generosidade | índice de generosidade | quantitativo |

---

## Predicados auxiliares

Foram definidos predicados auxiliares que servem de base para as consultas mais complexas:

- `total_paises(Total)` — conta quantos países existem na base
- `todas_regioes(Regioes)` — lista todas as regiões sem repetição
- `media_lista(Lista, Media)` — calcula a média de uma lista de valores
- `top25_gdp(Pais)` — verdadeiro se o país está no top 25% em GDP
- `top25_saude(Pais)` — verdadeiro se o país está no top 25% em saúde
- `top25_confianca(Pais)` — verdadeiro se o país está no top 25% em confiança
- `score_desenvolvimento(Pais, Score)` — calcula o score composto GDP + saúde + liberdade + confiança
- `media_felicidade_regiao(Regiao, Media)` — calcula a média de felicidade de uma região
- `media_gdp_global(Media)` — calcula a média global de GDP

Esses predicados são compostos uns sobre os outros nas perguntas principais, evitando repetição de lógica e tornando as queries mais expressivas.

---

## Perguntas feitas

### Pergunta 1 — Qual região do mundo é mais feliz em média, e quantos países a compõem?

```prolog
ranking_regioes(Ranking).
```

Para cada região, o predicado `dados_regiao` coleta todos os scores com `findall`, calcula a média com `media_lista` e conta os países. Em seguida, `ranking_regioes` agrega todas as regiões, ordena pelo valor da média e inverte a lista para ordem decrescente.

Resultado esperado:

```
australia_and_new_zealand | media: 7.2850 | paises: 2
north_america             | media: 7.2730 | paises: 2
western_europe            | media: 6.6896 | paises: 21
...
sub_saharan_africa        | media: 4.2028 | paises: 40
```

---

### Pergunta 2 — Paradoxo da riqueza: quais países têm GDP acima da média global mas felicidade abaixo da média da sua própria região?

```prolog
paradoxo_riqueza_ordenado(Tabela).
```

O predicado `pais_paradoxo_riqueza` compara cada país em dois contextos diferentes ao mesmo tempo: verifica se o GDP está acima da média global (calculada por `media_gdp_global`) e se o score de felicidade está abaixo da média da sua região (calculada por `media_felicidade_regiao`). O resultado é ordenado pela diferença entre a média regional e o score do país, mostrando os mais "paradoxais" primeiro.

Resultado esperado (trecho):

```
greece (western_europe)   | GDP: 1.1541 | score: 4.8570 | diferenca: 1.8326
portugal (western_europe) | GDP: 1.1599 | score: 5.1020 | diferenca: 1.5876
...
```

---

### Pergunta 3 — Quais são os top 10 países em desenvolvimento humano composto?

```prolog
top10_desenvolvimento(Top10).
```

O predicado `score_desenvolvimento` cria um indicador sintético somando quatro dimensões: GDP, saúde, liberdade e confiança. `top10_desenvolvimento` calcula esse score para todos os 158 países com `findall`, ordena de forma decrescente e retorna apenas os 10 primeiros com `append`.

Resultado esperado:

```
qatar       | score_dev: 3.6502
singapore   | score_dev: 3.5817
luxembourg  | score_dev: 3.4767
switzerland | score_dev: 3.4233
...
```

---

## Como rodar

**1. Gerar a base Prolog:**

```bash
python generate_prolog.py
```

Isso gera o arquivo `base_felicidade.pl` com os 158 fatos.

**2. Testar online no SWISH:**

Acesse [https://swish.swi-prolog.org/](https://swish.swi-prolog.org/) e clique em **Create a Notebook**.

- Na área **Program**: cole o conteúdo de `base_felicidade.pl` seguido do conteúdo de `regras_e_consultas.pl`
- Na área **Query**: cole uma das queries abaixo e clique em **Run!**

```prolog
ranking_regioes(Ranking).
```
```prolog
paradoxo_riqueza_ordenado(Tabela).
```
```prolog
top10_desenvolvimento(Top10).
```

---

## Dificuldades encontradas

- normalização de nomes com acentos e espaços para o formato Prolog
- uso correto de `findall` sem variáveis livres (o que causaria agregação errada)
- cálculo de limiares dinâmicos para o top 25% usando `msort`, `nth1` e `reverse`
- comparar um país com dois contextos diferentes ao mesmo tempo (média global vs. média regional) na Pergunta 2
- uso de `append` para cortar a lista no top 10 sem usar recursão manual

---

## Considerações finais

O projeto explora um paradigma de programação baseado em lógica e inferência, bem diferente da programação procedural tradicional. Em vez de escrever funções com retorno explícito, as respostas emergem da composição de predicados e do mecanismo de unificação do Prolog.

As três perguntas implementadas envolvem agregação, comparação cruzada entre contextos e criação de indicadores sintéticos — demonstrando que é possível fazer análises de dados expressivas e sofisticadas mesmo em um sistema baseado em lógica de primeira ordem.