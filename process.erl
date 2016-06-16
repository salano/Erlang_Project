-module(process).
-export([load/1,count/3,collector/2]).

% Load Function
% Takes File name as parameter
% Reads File and splits into 20 segments
% Calls Main to call 20 processes
% Prints result of all 20 processes combined (a-z) - Not Done
%=======================================================================
load(F)->
io:format("~n Loading File : ~p~n", [F]),
   {ok, Bin} = file:read_file(F),
   List=binary_to_list(Bin),
   Length=round(length(List)/20),
   Ls=string:to_lower(List),
   Segments=split(Ls,Length),
   io:fwrite(" Loaded and Split x 20 Segments~n"),
   CollectorID = spawn(?MODULE, collector, [[],1]),
   io:format("~n Spawned : Collector \t\t Pid : ~p~n",[CollectorID]),
   main(Segments,1,CollectorID).

collector(ResultsList,Joins) ->
  receive
    {start, _, CountedList} -> 
    case ResultsList == []  of
      true ->  Shuffle = CountedList;
      false -> Shuffle = join(CountedList, ResultsList)
    end,
    case Joins == 20 of
      true -> io:fwrite("~n Collector ~p ~nResults = ~p Processes completed~n",[Shuffle,Joins]),
      collector(Shuffle,Joins);
      false -> collector(Shuffle,Joins+1)
    end;
    Msg ->
      io:format("~p Collector received unexpected message ~n", [Msg]),
      collector(ResultsList,Joins)
  end.

%joins the number of splits
%=====================================================================================
join([],[])->[];
join([],R)->R;
join([H1 |T1],[H2|T2])->
   {_C,N}=H1,
   {C1,N1}=H2,
   [{C1,N+N1}]++join(T1,T2).

% Main
% Calls spawner 20 times with file segment to create a process for that segment
%=======================================================================
main([H|T],N,Cid) ->
  spawner(H,N,Cid),
 %Debugging % io:fwrite("~nStarting Process # ~p \t using Segment :~p ~n",[N,H]),
  main(T,N+1,Cid);
% Main Stop Function
main([], N,_) -> io:fwrite(" Spawned : ~p Processes~n",[N-1]).

% Spawner
% Takes segment of words, and N to identify the process (1-20)
% Creates process and sends a message to start process
%
%=======================================================================
spawner(WordList,N,Cid) ->
  SeenList = [],
  Alph=[$a,$b,$c,$d,$e,$f,$g,$h,$i,$j,$k,$l,$m,$n,$o,$p,$q,$r,$s,$t,$u,$v,$w,$x,$y,$z],
  Processes = [spawn_link(fun() -> 
          process(WordList, Cid,N,Alph) end) ],
  [ Process ! {start, Cid, SeenList,N} || Process <- Processes].

% Process
% Takes the segment of the file
% Recieves message to start process and calls run_process with parameters
%=======================================================================
process(Segment, Pid,N,Alph) ->
  receive
    {start, Pid, CountedList,N} -> run_process(Segment, Pid, CountedList,N,Alph);
  %  io:fwrite(" Spawned : Process : ~p\t\t Pid : ~p~n",[N,self()]);
    Msg ->
      io:format("~p received unexpected message ~p~n", [Segment, Msg]),
      process(Segment, Pid,N,Alph)
  end.

% Run Process -  Worker Function
% Takes in Segment, Process ID, CounterList, N , Alpha list
% Counts occurances of char in segment using Head from Alpha
%=======================================================================
run_process(Segment, Pid, CountedList, N,[H|T])  ->
    Num=count(H,Segment,0),
    CountedList2=CountedList++[{[H],Num}],
    run_process(Segment, Pid, CountedList2,N,T);

% Run Process - Stop Function
run_process(_, Pid, CountedList,N,[]) ->
  % Debugging    %io:fwrite("Completed Process # ~p~n",[N]),
  % Debugging   %io:fwrite("Counted List = ~n~p~n",[CountedList]),
  Pid ! {start, N, CountedList}.

%=======================================================================
split([],_)->[];

split(List,Length)->
   S1=string:substr(List,1,Length),
   case length(List) > Length of
      true->S2=string:substr(List,Length+1,length(List));
      false->S2=[]
   end,
   [S1]++split(S2,Length).

%  Counts occurances of charachter in list
%=========================================================================================
count(_, [],N)->N;
count(Ch, [H|T],N) ->
   case Ch==H of
   true-> count(Ch,T,N+1);
   false -> count(Ch,T,N)
end.

