-module (charcount).
-export ([load/1,count/3,go/1]).

load(F)->
{ok, List} = file:read_file(F),
   L=binary_to_list(List),
   Sl=string:to_lower(L),
   io:fwrite("Loaded and lowered"),
   Result=go(Sl),
 Result.


count(Ch, [],N)->N;
count(Ch, [H|T],N) ->
   case Ch==H of
   true-> count(Ch,T,N+1);
   false -> count(Ch,T,N)
end.

go(L)->
Alph=[$a,$b,$c,$d,$e,$f,$g,$h,$i,$j,$k,$l,$m,$n,$o,$p,$q,$r,$s,$t,$u,$v,$w,$x,$y,$z],
rgo(Alph,L,[]).

rgo([H|T],L,Result)->
N=count(H,L,0),
Result2=Result++[{[H],N}],
rgo(T,L,Result2);

rgo([],L,Result)->Result.