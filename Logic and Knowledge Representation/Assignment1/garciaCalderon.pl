

%Ex 1. 

second([A,B|T] , R) :-      		% #By entering a  list, we verify that our output is our second element in the list.
	R=B.					
	

%Ex 2.
removeLast1([H|[]] , [] ).   		% #If a list of one element is received, result is the List.
removeLast1([H|T] , [H|R]  ) :-		% #The list is divided, adds the first element and puts it into R
	removeLast1( T , R ).			% #Takes the Tail of the list, and by recursion, if it has a tail itself, repeats the procedure.
	
	
	
removeLast2(L,R):-					%If the result plus a single element gives us our input list, then our Result will be the input list minus the last element.
append(R,[_], L).

	
	
%Ex 3.

replace([],A,B,[]).									%if the input is an empty list, then the output is simply an empty list.
replace([H|T], X, Y, [H|R]):-						%Split the list to check if X is our first element, if it is, we pass it to R.
	H\=X,
	replace(T, X, Y, R).
													%Now recursively run the function for the Tail.
replace([X|T], X, Y, [Y|R]):- 
replace(T,X,Y,R).

%Ex 4.
correspondence([],X,[]).							%If we have an empty list, and a list of couples, we receive an empty list.
correspondence(X,[], X).							%If we have a list, but the list of couples is empty, we just get the list.
correspondence( X, [[H,T]|T2] , R):-				%IF we receive a list, and a list of lists, then we separate the first list of two elements
	replace(X ,H,T, R1),							% and use them to replace in our input list.
	correspondence(R1, T2 , R).						%then we advance to the rest of the list by having our new list as an input, and the remaining Tail of our lists
	

	

%Ex 5.

decompose([],[],[]).					%If list is empty, return empty lists.
decompose([H|T], [H|R1], R2):-			% With recrussion, compare the values above 0, and paste them in R1.
	H>0,								% Goes trough the head and then:
	decompose(T, R1, R2).				% Re runs the code using the Tail as an input.
decompose([H|T], R1, [H|R2]):-			% Store all the other values in the remaining list R2.
	H=<0,
	decompose(T, R1, R2).
	
%Ex 6.
compress([],[])							%If list is empty, return empty lists.
compress([X],[[X,1]]).					%When list is only an element, then we have our element with an starting counter.

compress([H,T|T2],[[H,C]|RF]):-			%Get the first two elements of the list, assign to create a new list, which will store the counter
	H=T,								%Compare the first with the second element
	compress([T|T2] , [[H,R2]|RF]),		%Get the next element and rest of the list as an input. Since we had the same element, we still have the same output list ready to update the counter.
	C is R2 + 1.						%update the counter
compress([H,T|T2],[[H,1],[T,R2]|RF]):-	%When the element is not the same as the previous one, the new list has the value of the new element, and a new counter. Which will or not be updated.
	H \= T,
	compress([T|T2] , [[T,R2]|RF]).


%Ex 7.

decompress(X , R) :-					%By calling compress the other way around, then it the input becompes the output of decompress, and our output 
	compress(R , X).					%is what we had as an input, before compressing.