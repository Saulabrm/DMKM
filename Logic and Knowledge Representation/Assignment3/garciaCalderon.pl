% working_directory(CWD, '/Users/saulgarcia/Dropbox/Maestria/DMKM/Courses/SEM1/Logic/Assignments/A3').
% [garciaCalderon].
/*Exercise 2
Write	a	PROLOG	program	read_command(C) that	reads	a	line	on	the	
current	input	stream	and	that	returns	the	list	of	ascii	codes	it	contains.

read_command(C)
*/


/* Command line  to run each different syntax*/
read_command(L1):-             
   get0(C),
   read_command(_, L, C),name(X, L),atomic_list_concat([M1|T1],' ',X),
   last([M1|T1],Z1),name(Z1,[H1,H2|T]),
   (
   [H1,H2] == [62,62]
       -> T \= [], 
          append(T2,[_],T1),
       	  call_cmd([M1|T2],L,L2),
          name(Y,T),
          L1=append(L2,Y);
   [H1] == [62] 
       -> [H2|T] \= [],
       	  append(T2,[_],T1),
       	  call_cmd([M1|T2],L,L2),
          name(Y,[H2|T]),
          L1=send(L2,Y);
   call_cmd([M1|T1],L,L1)
   
   ).  
   
 
/*      Which command to call    */
call_cmd([M|T],P,R):-
	([M] == [cal]
         ->cmd_cal(T,R);
     [M] == [cat]
         ->cmd_cat(T,R);
     [M] == [cp]
         ->cmd_cp(T,R);
     [M] == [grep]
         ->cmd_grep(T,R);
      P = R
   ).


/*       ASCI numbers       */
%?- read_command(C).
%|: Hello world
%C = [72, 101, 108, 108, 111, 32, 119, 111, 114|...].

read_command(_, [], X):-
    member(X, `.\n\t`), !.
read_command(X, [C|L], C):-
    get0(C1),
    read_command(X, L, C1).

/*        Calendar           */
%?- read_command(C).
%|: cal 1 99
%C = calendar(1, 99).

/* Parses when input is only 'cal' in command */
cmd_cal([],calendar( M , Y )):-
    monthyear(M,Y).
    
/* Parses when input is 'cal' with the year. */
cmd_cal( [(Y)] , calendar( Y1 ) ):-
	atom_number(Y,Y1),
	integer(Y1),
    between(1,9999,Y1).

/* Parses when input is 'cal' with the month and year. */
cmd_cal( [(M),(Y)] , calendar( M1 , Y1 ) ):-
    atom_number(M,M1),atom_number(Y,Y1),
     integer(M1),
     between(1,12,M1) ,
     integer(Y1) ,
     between(1,9999,Y1).

/* Gets the current month and year */
monthyear(M,Y) :-
   get_time(Stamp),
   stamp_date_time(Stamp, DateTime, local),
   date_time_value(month, DateTime, M),
   date_time_value(year, DateTime, Y).
   
   
/*            Concatenate         */
% ?- [-n,-b, file1]
% ?- cat -n -b file1

/* Make the arity 3, first append to one list the characters that are members of the list*/

cmd_cat(Z,W):-cmd_cat(Z,X,Y),
W=concatenate(X,Y).
	
/* Create the first list*/
cmd_cat([],[],[]).
cmd_cat([H|T], [S|R1],R2):-
	atom_chars(H, ['-', S]),
	!,
	member(S,[n,b,s,u,v,e,t]),
	cmd_cat(T,R1,R2).
	
/* Create the second list*/
cmd_cat([H|T], R1,[H|R2]):-
	cmd_cat(T,R1,R2).
	       
       
/*         Copy          */

/* Call it and make it arity 4, first append to one list the 
characters that are members of the list*/
cmd_cp(Z,A):-cmd_cp(Z,X,Y,W),
A=copy(X,Y,W).

/* Create the first list where everything has to be a member of the list*/
cmd_cp([],[],[],[]).
cmd_cp([H|T], [S|R1],R2, R3):-
	atom_chars(H, ['-', S]),
	!,
	member(S,[r,'R',f,i,p]),
	cmd_cp(T,R1,R2,R3).
	
/* Create the second list with the rest of the elements, and split the last element*/
cmd_cp(L, [], L1, T):-
	append(L1,[T],L),
	L1 \= [].	

/*         Search_expr          */
% read_command(C).
%|: grep -ncb -e exp file1
%C = search_exp([n, c, b], e, exp, [file1]) .

cmd_grep(X,A):-cmd_grep(X, O, E, Ex, F),
A=search_exp(O,E,Ex,F).

/* Case when it receives the element '-e'*/
cmd_grep(['-e'|T],R1,'e',R3,R4):-
	!,
	cmd_grep(T,R1,_,R3,R4).
	

/* Case when it has the optional members '-bcihlnvsy' */	
cmd_grep([H|T],T2,R2,R3,R4):-
	atom_chars(H,['-'|T1]),
	!,
	ismember(T1,T2),
	cmd_grep(T,_,R2,R3,R4).

/* Declares that it has to have 'expr' */
cmd_grep([H|T],[],[],H,T):-
	T \= [].
	
/* Check if is a member */
ismember([],[]).
ismember([H|T],[H|R1]):-
	member(H,[b,c,i,h,l,n,v,s,y]),
	ismember(T,R1).


%=================================%

/*          DCG        */

read_dcg(R):-
    get0(Input),
    read_dcg(C,Input),
    phrase(send_append(M),C),
    R =..M.

/*  ASCI Numbers DCG  */
read_dcg([],Input):-
    member(Input,`\n\t`),
    !.
read_dcg([In|L],In):-
    get0(In2),
    read_dcg(L,In2).

send_append([send,R,Y1])--> default(X), ` >`, file(Y),{atom_codes(Y1,Y)},{R=..X}.
send_append([append,R,Y1])--> default(X), ` >>`, file(Y),{atom_codes(Y1,Y)},{R=..X}.
send_append(X) --> default(X).

/* Call the different commands */
default([calendar|Args]) --> `cal`, cal(Args),! .
default([concatenate|Args]) --> `cat`, cat(Args),! .
default([copy|Args]) --> `cp`, cp(Args),! .
default([search_exp|Args])--> `grep`,grep(Args),!.

% ======================================= %

/*           Calendar DCG           */
% atom_codes(' 1',X), phrase(cal(Y),X).
% atom_codes('',X), phrase(cal(Y),X).

/* Parses when input is 'cal' with the month and year. */
cal([M,Y]) --> ` `, integer(M),{between(1,12,M)}, ` `,integer(Y),{between(1,9999,Y)}.

/* Parses when input is 'cal' with the year. */
cal([Y]) --> ` `, integer(Y),
    {between(1,9999,Y)}.

/* Parses when input is only 'cal' in command */
cal([M,Y]) --> [],{monthyear(M,Y)}.

integer(I) --> digit(D0), digits(D),
    {number_codes(I,[D0|D])}.
digits([D|L]) --> digit(D), !, digits(L).
digits([]) --> [].
digit(D) --> [D],
    {code_type(D,digit)}.


 /*           Concat DCG           */    
% atom_codes(' -nb file file2 file3',X), phrase(cat(Y),X).
cat([C,Y]) --> ` -`,cat_args(C),files(Y).
cat([Y]) --> files(Y).
cat_args([X|Y]) --> options(X),cat_args(Y).
cat_args([X]) --> options(X).
options(n) --> `n`.
options(b) --> `b`.
options(s) --> `s`.
options(u) --> `u`.
options(v) --> `v`.
options(e) --> `e`.
options(t) --> `t`.

 /*  Check when there are multiple files. */  
% atom_codes(' file1 file2 file3',Y),phrase(files(M),Y).

files([H|T]) --> ` `, file(F), files(T),
    {not(F =[]),
    atom_codes(H,F)}, !.

 /* Check if it receives a single file*/  
files([H]) --> ` `, file(F),
    {not(F=[]),
    atom_codes(H,F)}.

 /* Case to check for negation */  
file([F|L]) --> [F], file(L),
    {not(member(F,` ->`))}, !.
file([]) --> [].


/*              Concat DCG               */    
% atom_codes(' file1 file2 target',Y),phrase(cp(M,N),Y).
% atom_codes(' -R -f -p file1 file2 target',Y),phrase(cp(M,N,Q),Y).
cp([C,X,Y]) --> cp_args(C),cp_file(X,Y).
cp([[],X,Y]) --> cp_file(X,Y).

% atom_codes(' -R -f -i',Y),phrase(cp_args(M),Y).
cp_args([X|Y]) --> cp_options(X),cp_args(Y).
cp_args([X]) --> cp_options(X).
cp_options(r) --> ` -r`;` -R`.
cp_options(f) --> ` -f`.
cp_options(i) --> ` -i`.
cp_options(p) --> ` -p`.

% atom_codes(' file1 file2 target',Y),phrase(cp_file(M,N),Y).
/* Checks for multiple files an one target*/
cp_file([H|T],Y) --> ` `,file(F),cp_file(T,Y),
    {not(F=[]),
    atom_codes(H,F)}.

/* Checks for only one file an one target*/
cp_file([H],AD) --> ` `,file(F),` `,file(Y),
    {not(F=[]),
    atom_codes(H,F)},
    {not(Y=[]),
    atom_codes(AD,Y)}.

/*              Search Expr              */ 
grep([A,Z,Y,X]) --> ` -`,grep_options1(A),grep_options2(Z), expr(Y),files(X).
% atom_codes(' -e expr file1 file2 file3',Y),phrase(grep(M),Y).
grep([[],Z,Y,X]) --> grep_options2(Z), expr(Y),files(X).
% atom_codes(' expr file1 file2 file3',Y),phrase(grep(M),Y).
grep([[],[],Y,X]) --> expr(Y),files(X).
expr(Y) --> ` `,file(Y1),{atom_codes(Y,Y1)}.

grep_options2(e) --> ` -e`.

% -bcihlnvsy
grep_options1([X|Y]) --> options1(X),grep_options1(Y).
grep_options1([X]) --> options1(X).
options1(b) --> `b`.
options1(c) --> `c`.
options1(i) --> `i`.
options1(h) --> `h`.
options1(l) --> `l`.
options1(n) --> `n`.
options1(v) --> `v`.
options1(s) --> `s`.
options1(y) --> `y`.