-module(trial).
-export([nowtime/2]).
-export([go10/1]).

nowtime(Pid,N)->
timer:sleep(N),
Pid ! {self(),[date(),time()]}.


go10(10)->10;

go10(N)->
Pid=spawn(trial,nowtime,[self(),N*1000]),
go10(N+1),
receive 
{From,Msg}->
   io:fwrite("~w~n",[Msg]);
_Other -> {error, unknown}
end.
