informacao :-
    write('covid19 - Sistema Especialista'),
    nl.

% Todas gravidades possíveis com os seus critérios
gravidade(Sintoma, gravissimo) :-
    sintomas(Sintoma, temperatura_acima_de_39), % > 39
    sintomas(Sintoma, frequencia_respiratoria_maior_que_30), % > 30
    sintomas(Sintoma, pa_sistolica_menor_que_90), % < 90
    sintomas(Sintoma, sa_O2_menor_que_95), % < 95
    sintomas(Sintoma, dispneia_sim). % true

gravidade(Sintoma, grave) :-
    sintomas(Sintoma, temperatura_acima_de_39), % > 39
    sintomas(Sintoma, pa_sistolica_entre_90_e_100),
    sintomas(Sintoma, idade_maior_igual_a_80),
    sintomas(Sintoma, comorbidades_igual_a_2_ou_mais).

gravidade(Sintoma, medio) :-
    sintomas(Sintoma, temperatura_menor_que_35_e_entre_37_e_39),
    sintomas(Sintoma, frequencia_cardiaca_maior_que_100),
    sintomas(Sintoma, frequencia_respiratoria_entre_19_e_30),
    sintomas(Sintoma, idade_entre_60_e_79),
    sintomas(Sintoma, comorbidades_igual_a_1).

gravidade(Sintoma, leve) :-
    sintomas(Sintoma, temperatura_entre_35_e_37),
    sintomas(Sintoma, frequencia_cardiaca_menor_que_100),
    sintomas(Sintoma, frequencia_respiratoria_menor_que_18),
    sintomas(Sintoma, pa_sistolica_maior_que_100),
    sintomas(Sintoma, sa_O2_maior_igual_que_95),
    sintomas(Sintoma, dispneia_nao),
    sintomas(Sintoma, idade_menor_que_60),
    sintomas(Sintoma, comorbidades_igual_a_0).

% Obtém sintoma e faz a pergunta
sintomas(Sintoma, Valor) :- pergunta('O paciente possui estado de gravidade ', Valor).

% Cria cache (verifica se pergunta já foi perguntada e continua)
pergunta(PerguntaFixa, Valor) :- cache(PerguntaFixa, Valor, true).

% Cria cache (verifica se pergunta já foi perguntada e caso já tenha sido segue para a próxima pergunta)
pergunta(PerguntaFixa, Valor) :- cache(PerguntaFixa, Valor, false), fail.

% Faz a pergunta, obtém a resposta, valida no cache verdadeuro ou (;) falso e continua
pergunta(PerguntaFixa, Valor) :-
    nl,
    write(PerguntaFixa),
    write(Valor),
    write('? (s/n)'),
    read(Ans),
    (
        (Ans=s, assert(cache(PerguntaFixa, Valor, true)));
        (assert(cache(PerguntaFixa, Valor, false)), fail)
    ).

% Executa as perguntas
resultado :-
    nl,
    gravidade(sintomas, Gravidade),
    nl,
    write('O paciente possui estado de gravidade '),
    write(Gravidade).

% Exibe mensagem de não possui gravidade
resultado :-
    nl,
    write('Não possui gravidade').

% Exibe informação do programa, limpa as funções (abolish),
% informa que o cache pode mudar durante a compilação (dynamic), remove todos valores de dynamic
% e executa o resultado... se tentar novamento for verdadeiro repete de novo.
inicio :-
    informacao,
    repeat,
    abolish(cache/3),
    dynamic(cache/3),
    retractall(cache/3),
    resultado,
    nl, nl,
    write('Tentar novamente ? (s/n)'),
    read(Resposta),\+ Resposta=s,
    nl,
    write('Encerrado!'),
    abolish(cache,3).