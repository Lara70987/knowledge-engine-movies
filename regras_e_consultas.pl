% Regras auxiliares

pais_feliz(Pais) :-
    felicidade(Pais, _, _, Score, _, _, _, _, _),
    Score >= 7.0.

pais_rico(Pais) :-
    felicidade(Pais, _, _, _, Gdp, _, _, _, _),
    Gdp >= 1.2.

pais_com_confianca_alta(Pais) :-
    felicidade(Pais, _, _, _, _, _, _, Conf, _),
    Conf >= 0.3.

pais_com_boas_liberdade_e_generosidade(Pais) :-
    felicidade(Pais, _, _, _, _, _, Liberdade, _, Generosidade),
    Liberdade >= 0.55,
    Generosidade >= 0.25.

indice_liberdade_generosidade(Pais, Indice) :-
    felicidade(Pais, _, _, _, _, _, Liberdade, _, Generosidade),
    Indice is Liberdade + Generosidade.

% Maximos


maior_score(ScoreMax) :-
    findall(S, felicidade(_, _, _, S, _, _, _, _, _), Scores),
    max_list(Scores, ScoreMax).

pais_maior_score(Pais, ScoreMax) :-
    felicidade(Pais, _, _, ScoreMax, _, _, _, _, _),
    maior_score(ScoreMax).

maior_gdp(GdpMax) :-
    findall(G, felicidade(_, _, _, _, G, _, _, _, _), Gdps),
    max_list(Gdps, GdpMax).

pais_maior_gdp(Pais, GdpMax) :-
    felicidade(Pais, _, _, _, GdpMax, _, _, _, _),
    maior_gdp(GdpMax).

maior_confianca(ConfMax) :-
    findall(C, felicidade(_, _, _, _, _, _, _, C, _), Confs),
    max_list(Confs, ConfMax).

pais_maior_confianca(Pais, ConfMax) :-
    felicidade(Pais, _, _, _, _, _, _, ConfMax, _),
    maior_confianca(ConfMax).

% Pergunta 1: O pais mais feliz tambem tem maior GDP e maior confianca?

pais_mais_feliz_e_compara(Pais, ScoreMax, GdpMax, ConfMax, Resultado) :-
    pais_maior_score(Pais, ScoreMax),
    maior_gdp(GdpMax),
    maior_confianca(ConfMax),
    felicidade(Pais, _, _, ScoreMax, GdpPais, _, _, ConfPais, _),
    (   GdpPais =:= GdpMax,
        ConfPais =:= ConfMax
    ->  Resultado = sim
    ;   Resultado = nao
    ).


% Pergunta 2: Paises com felicidade alta e fatores altos

pais_forte_em_varios_fatores(Pais) :-
    felicidade(Pais, _, _, Score, Gdp, Saude, Lib, Conf, _),
    Score >= 7.0,
    Gdp >= 1.2,
    Saude >= 0.85,
    Lib >= 0.60,
    Conf >= 0.20.


% Pergunta 3: Maior soma de liberdade + generosidade

melhor_indice_lib_gener(PaisMelhor, IndiceMax) :-
    findall(Indice-Pais, indice_liberdade_generosidade(Pais, Indice), Lista),
    sort(Lista, ListaOrdenada),
    last(ListaOrdenada, IndiceMax-PaisMelhor).