-module(wordsorter).
-export([readfile/1]).

%the main function
readfile(Src) ->
{ok, Input} = file:read_file(Src),
Content = unicode:characters_to_list(Input),
Output = string:tokens(string:to_lower(Content), "\W+\s+.,;:!?~/>'<{}£$%^&()@-=+_[]*#\\\n\r\"0123456789"),
file:close(Input),
UList = unique(Output,[]), 
   Sortedlist = sort(UList),
   lists:foreach(fun(H) -> io:format("~p~n",[H]) end,Sortedlist ),
   io:fwrite("word count: ~p\n",[countwords(Sortedlist)]).
   
    
%function to get unique list
unique([H|T],Current) ->                       
    case lists:member(H, Current) of           
        true -> Temp = Current;              
        false -> Temp = Current ++ [H]       % add H to head of Current
    end,
    unique(T,Temp);     
    unique([],Current) -> Current.   

    sort([Pivot|T]) ->
    sort([ X || X <- T, X < Pivot])++ 
    [Pivot] ++
    sort([ X || X <- T, X >= Pivot]);
sort([]) -> [].

%count elements in a list
countwords(L) ->
    length([X || X <- L]).