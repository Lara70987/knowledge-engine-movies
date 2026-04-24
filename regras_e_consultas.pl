% Predicados auxiliares base

todos_paises(Lista) :-
    findall(P, felicidade(P, _, _, _, _, _, _, _, _), Lista).

total_paises(Total) :-
    todos_paises(Lista),
    length(Lista, Total).

todas_regioes(Regioes) :-
    findall(R, felicidade(_, R, _, _, _, _, _, _, _), Lista),
    sort(Lista, Regioes).

media_lista(Lista, Media) :-
    sum_list(Lista, Soma),
    length(Lista, N),
    N > 0,
    Media is Soma / N.




% Pergunta 1:
% Ranking completo das regioes por media de felicidade, mostrando media e quantidade de paises em cada uma


dados_regiao(Regiao, Media, QtdPaises) :-
    todas_regioes(Regioes),
    member(Regiao, Regioes),
    findall(S, felicidade(_, Regiao, _, S, _, _, _, _, _), Scores),
    length(Scores, QtdPaises),
    media_lista(Scores, Media).

ranking_regioes(Ranking) :-
    findall(Media-Regiao-Qtd, dados_regiao(Regiao, Media, Qtd), Lista),
    sort(Lista, Ordenada),
    reverse(Ordenada, Ranking).




% Pergunta 2:
% Paradoxo da riqueza: paises com GDP acima da media global, mas com felicidade abaixo da media da sua propria regiao


media_gdp_global(Media) :-
    findall(G, felicidade(_, _, _, _, G, _, _, _, _), Gdps),
    media_lista(Gdps, Media).

media_felicidade_regiao(Regiao, Media) :-
    findall(S, felicidade(_, Regiao, _, S, _, _, _, _, _), Scores),
    Scores \= [],
    media_lista(Scores, Media).

pais_paradoxo_riqueza(Pais, Regiao, Gdp, Score, MediaRegiao) :-
    media_gdp_global(MediaGdp),
    felicidade(Pais, Regiao, _, Score, Gdp, _, _, _, _),
    Gdp > MediaGdp,
    media_felicidade_regiao(Regiao, MediaRegiao),
    Score < MediaRegiao.

paradoxo_riqueza_ordenado(Tabela) :-
    findall(Diff-Pais-Regiao-Gdp-Score,
        (pais_paradoxo_riqueza(Pais, Regiao, Gdp, Score, MediaRegiao),
         Diff is MediaRegiao - Score),
        Lista),
    sort(Lista, Ordenada),
    reverse(Ordenada, Tabela).



% Pergunta 3:
% Score composto de desenvolvimento humano:
% GDP + saude + liberdade + confianca
% Top 10 paises ordenados por esse score

score_desenvolvimento(Pais, Score) :-
    felicidade(Pais, _, _, _, Gdp, Saude, Lib, Conf, _),
    Score is Gdp + Saude + Lib + Conf.

top10_desenvolvimento(Top10) :-
    findall(Score-Pais, score_desenvolvimento(Pais, Score), Lista),
    sort(Lista, Ordenada),
    reverse(Ordenada, Desc),
    length(Top10, 10),
    append(Top10, _, Desc).