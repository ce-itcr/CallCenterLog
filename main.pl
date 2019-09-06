% main.pl -- archivo principal para correr CallCenterLog, contiene reglas de Prolog.
%
% Este archivo es parte de  CallCenterLog, El presente tiene como objetivo el desarrollo de una aplicación que se comporte 
% como un experto en la solución de problemas comunes de un Call Center de TI utilizando Prolog. Los Sistemas expertos, 
% de ahora en adelante SE, son aplicaciones de cómputo que involucran experiencia no algorítmica, para resolver cierto 
% tipo de problema. La interfaz debe ser completamente natural utilizando el lenguaje español. El usuario que presenta 
% el problema, ingresa e informa al SE de todos los inconvenientes que tiene (hardware y software) que le impiden realizar
% sus tareas normalmente y finalmente puede consultar.
%
% Version de Archivo 	: 0.1
% Autores            	: GitHub@angelortizv, GitHub@jesquivel48, GitHub@isolis2000
% Úlitma Modificación  	: 06/09/2019, 01:26, @angelortizv

:-consult('application_db').
:-style_check(-singleton).
:-dynamic(soluciones/1).

% BNF ----------------------------------------------------------------------------------------------------------------------------

oracion(A,B):-
	sintagma_nominal(A,C),
	sintagma_verbal(C,B).
oracion(A,B):-
	sintagma_nominal(A,C),
	negacion(C,D),
	sintagma_verbal(D,B).

sintagma_nominal(A,B):-
	determinante_m(A,C),
	sustantivo_m(C,B).
sintagma_nominal(A,B):-
	determinante_f(A,C),
	sustantivo_f(C,B).
sintagma_nominal(A,B):-
	determinante_n(A,C),
	sustantivo_f(C,B).
sintagma_nominal(A,B):-
	determinante_n(A,C),
	sustantivo_m(C,B).

sintagma_verbal(A,B):-
	verbo(A,B).
sintagma_verbal(A,B):-
	verbo(A,C),
	sintagma_nominal(C,B).

sintagma_saludo(A,B):-
	saludo(A,C),
	nombrePrograma(C,B).

% ValidaciÓn Gramatical, Saludo, Despedida ---------------------------------------------------------------------------------------

validacion_gramatical():-
	input_to_list(Oracion),
	oracion(Oracion,[]),
	% respuesta_validacion_gramatical(), 
	!.

validacion_gramatical():-
	writeln('Oración gramaticalmente incorrecta'),nl,
	writeln('Escriba de nuevo su oración').
	validacion_gramatical().

respuesta_validacion_gramatical():-
	writeln('Oración gramaticalmente correcta').

respuesta_saludo(Nombre):-
	write('Hola '),
	writeln(Nombre),
	writeln('¿En qué lo puedo ayudar?').

respuesta_despedida():-
	write('¿Algo más en que pueda servirle?'),
	fail.

% Operaciones Básicas ------------------------------------------------------------------------------------------------------------

input_to_list(L):-
	read_line_to_codes(user_input,Cs),
	atom_codes(A,Cs),
	atomic_list_concat(L,' ',A).
input_to_string(A):-
	read_line_to_codes(user_input,Cs),
	atom_codes(A,Cs).

concatenar([],L,L).
concatenar([X|L1],L2,[X|L3]):- 
	concatenar(L1,L2,L3).

eliminar_primeros(L,Y,B):- length(X, B), append(X,Y,L).

obtener_elemento([Y|_], 1, Y).
obtener_elemento([_|Xs], N, Y):-
          N2 is N - 1,
          obtener_elemento(Xs, N2, Y).


% Causas y referencias -----------------------------------------------------------------------------------------------------------

obtener_causas(X,A):-
	split_string(A, "', ,?" ,"', ,?", L),
	eliminar_primeros(L,Y,7),
	atomic_list_concat(Y, ' ', X),
	causas(X).

obtener_referencias(X,A):-
	split_string(A, "', ,?" ,"', ,?", L),
	eliminar_primeros(L,Y,6),
	atomic_list_concat(Y, ' ', X),
	referencias(X).

causas(A):-
	write('Las principales causas que pueden estar asociadas a: '),
	write(A), write(' son:'), nl,nl,
	causa(B,A),
	write(B),nl,
	fail.

referencias(A):-
	write('Algunas referencias para su problema son: '),nl,
	referencia(B,A),
	write(B),nl,
	fail.


% Consultas, Solución de Problemas, Conversación usuario-se ----------------------------------------------------------------------

hoja_izquierda(B):-
    pregunta(E,B),
    consulta_no(B, E).

consulta_no(A, P):-
    write(P), nl,
    read(R), nl,
    soluciones(L),
    concatenar(L, [A, R], NL),
    retractall(soluciones(_)),
    assert(soluciones(NL)),
    consulta_general(no, R).

consulta_caso_base(A):-
	solucion(B,A).

consulta_general(R,R).

buscar_solucion(P,R,[P, R|_]).
buscar_solucion(P,R,[_|C]):-
    buscar_solucion(P,R,C).

conversacion():-
	write('Responda con si. o no. a las siguientes preguntas'),nl,nl,
	retractall(soluciones(_)),
	assert(soluciones([])),
	raiz(A,'la computadora no enciende'),
	solucion(B,A),
	write(B),nl.

% Ejecutor SE --------------------------------------------------------------------------------------------------------------------

inicio():-
	sleep(0.02),
		write('       ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||       '),nl,
		sleep(0.02),
		write('       ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||       '),nl,
		sleep(0.02),
		write('       |||||||||||||||||||||||| Call Center Log |||||||||||||||||||||||||       '),nl,
		sleep(0.02),
		write('       ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||       '),nl,
		sleep(0.02),
		write('       ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||       '),nl,

	input_to_list(L),
	sintagma_saludo(L, []),
    writeln('Hola usuario'),
	writeln('¿Cuál es su nombre?'),
	input_to_string(Nombre),
	respuesta_saludo(Nombre),
	validacion_gramatical(),nl,
	write('Para CallCenterLog es un gusto ayudarle con su problema,'),nl,
	conversacion(),nl,
	respuesta_despedida().
	

?- write(' '),nl.
?- write('Sistema desarrollado por: angelortizv, isolis2000, jesquivel48'),nl.
?- write('Inserte inicio(). para iniciar con el sistema experto.'),nl,nl.