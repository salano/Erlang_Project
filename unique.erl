-module(unique).
-export([sort/1]).
-export([unique/2]).
-export([uusort/1]).
-export([readfile/1]).
-export([string_to_int/1]).

readfile(Src) ->
{ok, Input} = file:read_file(Src),
Content = unicode:characters_to_list(Input),
Output = string_to_int(Content),
%Output = string:tokens(string:to_lower(Content), ","),
file:close(Input),
UList = unique(Output,[]), 
   Sortedlist = sort(UList),
   lists:foreach(fun(H) -> io:format("~p~n",[H]) end,Sortedlist ).
   %io:fwrite("word count: ~p\n",[countwords(Sortedlist)]).

sort([Pivot|T]) ->
    sort([ X || X <- T, X < Pivot])++ 
    [Pivot] ++
    sort([ X || X <- T, X >= Pivot]);
sort([]) -> [].

uusort(List) ->
   UList = unique(List,[]), 
   sort(UList).


unique([H|T],Current) ->                       
    case lists:member(H, Current) of           
        true -> Temp = Current;              
        false -> Temp = Current ++ [H]       % add H to head of Current
    end,
    unique(T,Temp);     
    unique([],Current) -> Current. 


    string_to_int(L)-> lists:map(fun(X) -> {Int, _} = string:to_integer(X), 
         Int end, 
          string:tokens(L, ",")).    

