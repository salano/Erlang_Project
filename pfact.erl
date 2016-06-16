-module(pfact).

-export([calc/1]).

fact(X) -> fact(X, 1).

fact(0, R) -> R;
fact(X, R) when X > 0 -> fact(X-1, R*X).

calc(N) ->
    Self = self(),
    Pids = [ spawn(fun() -> Self ! {self(), {X, fact(X)}} end)
            || X <- lists:seq(1, N) ],
    [ receive {Pid, R} -> R end || Pid <- Pids ].