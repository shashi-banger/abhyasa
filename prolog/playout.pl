:- use_module(library(date)).
:- use_module(library(apply)).
:- use_module(library(date)).
:- use_module(date_time).


startmode(fixed).
startmode(follow).
startmode(truetime).
startmode(manual).

eventtype(primary).
eventtype(nonprimary).


endmode(duration) .
endmode(manual) .


transition_trigger(time) .
transition_trigger(action) .

% transition_time(TimeString, TransitionTrigger, Action) 
transition_time(_, time, null_action) .
transition_time(_, action, action(_, _)) .

% actions are defined by action name and the time at which an action is taken
% Example action instantiation `action(take_next_event, "2022-05-10T10:00:05.340").`
null_action .
action(take_next_show, _) . 
action(take_next_event, _) . 
action(hold, _).
action(unhold, _) .




event_with_show(_Showid, _Eventid, _Start, _End, Smode, Emode, Etype):- startmode(Smode), endmode(Emode), eventtype(Etype), !.

event(_Eventid, _Start, _End, Smode, Emode, Etype):- startmode(Smode),endmode(Emode),eventtype(Etype), !.
null_event . 


show(_Showid, _Start, _End, Smode, Emode, []):- startmode(Smode), endmode(Emode), !.
show(_Showid, _Start, _End, Smode, Emode, [event(_, _, _, ESmode, EEmode, Etype) | T]):-
             startmode(Smode),
             event(_, _, _, ESmode, EEmode, Etype),
             show(_,_,_,Smode, Emode, T).


get_show_events(show(_Showid, _Start, _End, _, _, Show_events), Show_events).

is_true_time_event(event(_Eventid, _Start, _End, Smode, _, _)) :- Smode = truetime.


% appply_true_tile_filter([Hs | Ts], [H_tt_event | T_tt_events], [H_tt_constrained_event | T_tt_constrained_events] :- 


% apply_true_time(Sorted_events, Stt_constrained_events):- 
%     include(is_true_time_event, Sorted_events, TT_events),
%     appply_true_tile_filter(Sorted_events, TT_events, Stt_constrained_events) .


map_show_id_to_events(Showid, [event(Eventid, Start, End, Smode, Emode, Etype) | TS_events], [HMS_event | TMS_events]) :-
    HMS_event = event_with_show(Showid, Eventid, Start, End, Smode, Emode, Etype),
    map_show_id_to_events(Showid, TS_events, TMS_events) .


% Unrolls a list of shows into a list of event_with_show
schedule_to_sorted_events([], []):- !. 
schedule_to_sorted_events([Hs|Ts], Sorted_events) :- 
    get_show_events(Hs, Hs_events),
    Hs=show(Showid, _, _, _, _, _),
    map_show_id_to_events(Showid, Hs_events, Hs_mapped_events),
    schedule_to_sorted_events(Ts, T_events),
    Sorted_events = append(Hs_mapped_events, T_events) .

% overlap(A,B) -> check if start of event B lies in the time rane of event A
overlap(event_with_show(_, _, S, E, _, _, _), event_with_show(_, _, S1, _, _, _, _)):- 
    write(S+"\n"),
    write(E+"\n"),
    parse_time(S, DT_S),
    parse_time(E, _, DT_E ),
    parse_time(S1,_, DT_S1),
    DT_S1 > DT_S,
    DT_S1 < DT_E .

overlap(event_with_show(_, _, S, E, _, _, _), action(_, T)):- 
    write(S+"\n"),
    write(E+"\n"),
    parse_time(S, DT_S),
    parse_time(E, _, DT_E ),
    parse_time(T,_, DT_S1),
    DT_S1 > DT_S,
    DT_S1 < DT_E .


get_tt_events([], []) .
get_tt_events([HS | TS], [H_TT_event | T_TT_events]) :-
    HS = event_with_show(_Showid, _Eventid, _Start, _End, truetime, _,  _),
    H_TT_event = HS,
    writeln(H_TT_event),
    get_tt_events(TS, T_TT_events), ! .
get_tt_events([_ | TS], TT_events) :-
    get_tt_events(TS, TT_events) .







apply_tt_constraint([], _,  null_event, [])  .
apply_tt_constraint([H_Sorted_event| T_Sorted_events], [], null_event, [H_Stt_constrained_event | T_Sttconstrained_events]) :- 
    H_Stt_constrained_event = H_Sorted_event,
    apply_tt_constraint(T_Sorted_events, [], null_event, T_Sttconstrained_events), ! .
apply_tt_constraint([H_Sorted_event| T_Sorted_events], [HTT_event |TTT_events], null_event, [H_Stt_constrained_event | T_Sttconstrained_events]) :- 
    not(overlap(H_Sorted_event, HTT_event)), !,
    H_Stt_constrained_event = H_Sorted_event,
    apply_tt_constraint(T_Sorted_events, [HTT_event |TTT_events], null_event, T_Sttconstrained_events) .
% Head event of TT event list coincides with the head event of sorted list
apply_tt_constraint([H_event| T_Sorted_events], [H_event |TTT_events], null_event, [H_Stt_constrained_event | T_Sttconstrained_events]) :- 
    H_Stt_constrained_event = H_event,
    apply_tt_constraint(T_Sorted_events, TTT_events, null_event, T_Sttconstrained_events), ! .
apply_tt_constraint([H_Sorted_event| T_Sorted_events], [HTT_event |TTT_events], null_event, [H_Stt_constrained_event | T_Sttconstrained_events]) :- 
    overlap(H_Sorted_event, HTT_event),
    writeln(["OVERLAP_TRUE", H_Sorted_event, HTT_event]),
    H_Stt_constrained_event = H_Sorted_event,
    apply_tt_constraint(T_Sorted_events, TTT_events, HTT_event, T_Sttconstrained_events), ! .
apply_tt_constraint([HTT_event| T_Sorted_events], TT_events, HTT_event,  [H_Stt_constrained_event | T_Sttconstrained_events]) :- 
    H_Stt_constrained_event = HTT_event,
    writeln(["CASE-3", HTT_event]),
    apply_tt_constraint(T_Sorted_events, TT_events, null_event, T_Sttconstrained_events), ! .
apply_tt_constraint([H_Sorted_event| T_Sorted_events], TT_events, HTT_event,  Sttconstrained_events) :- 
    % Dropping H_Sorted event since in the previous case either Showid != Showid1 or Eventis !- Eventid1
    writeln(["DROPPING", H_Sorted_event]),
    apply_tt_constraint(T_Sorted_events, TT_events, HTT_event, Sttconstrained_events), ! .


/*
output_event_generate([],  [],  []) :- !.
% Handle last singular event
output_event_generate([PGM],  [],  [H_out_event | T_out_events] ) :- 
    H_out_event = PGM, 
    output_event_generate([],  [],  T_out_events) , ! .
% if no action and PST is fixed 
output_event_generate([PGM | [PST | R_events_with_show]],  [],  [H_out_event | T_out_events] ) :- 
    PST = event_with_show(_, _, PST_Start, _, fixed, _, _), 
    PGM = event_with_show(PGM_Showid, PGM_Eventid, PGM_Start, PGM_End, Smode, Emode, Etype),
    H_out_event = event_with_show(PGM_Showid, PGM_Eventid, PGM_Start, PST_Start, Smode, Emode, Etype),
    output_event_generate([PST | R_events_with_show], [], T_out_events), ! .
% if no action and PST is follow 
output_event_generate([PGM | [PST | R_events_with_show]],  [],  [H_out_event | T_out_events] ) :- 
    PST = event_with_show(Show_id, Event_id, PST_Start, PST_End, follow, PST_Emode, PST_Etype), 
    H_out_event = PGM, 
    PGM =  event_with_show(_, _, _, PGM_End, _, _),
    parse_time(PST_Start, DT_PST_Start),
    parse_time(PST_End, DT_PST_End),
    datetime_difference(DT_PST_End, DT_PST_Start, PST_Duration),
    datetime_add(PGM_End, PST_Duration, N_PST_End),
    N_PST = event_with_show(Show_id, Event_id, PGM_End, N_PST_End, follow, PST_Emode, PST_Etype),  
    output_event_generate([N_PST | R_events_with_show], [], T_out_events) .
% if no action and PST is follow => TBD
*/

get_next_pst(_, [], N_PST):- N_PST = null_event .
get_next_pst(_, [_], N_PST):- N_PST = null_event .
get_next_pst(PST, [HE| [HN | _]], N_PST):-
     PST = HE,
     N_PST = HN, ! .
get_next_pst(PST, [_|TE], N_PST):-
    get_next_pst(PST, TE, N_PST) .

pgm_overrun(PGM, PST):-
    PGM = event_with_show(_, _, _, PGM_End, _, duration, _), 
    PST = event_with_show(_, _, PST_Start, _, fixed, _, _),
    parse_time(PGM_End, _, DT_PGM_End),
    parse_time(PST_Start, _, DT_PST_Start),
    DT_PGM_End >= DT_PST_Start .



/*
% PST is fixed and PGM duration overruns fixed PST, then preempt PGM and make PST as MGM at PST's fixed start time
output_event_on_no_action(PGM, PST, CurrTime, Events_with_show, H_out_event, N_PST, N_CurrTime) :- 
    pgm_overrun(PGM, PST),
    PGM = event_with_show(Show_id, Event_id, PGM_Start, PGM_End, Smode, Emode, Etype), 
    PST = event_with_show(_, _, PST_Start, _, fixed, _, _),
    H_out_event = event_with_show(Show_id, Event_id, PST_Start, PGM_End, Smode, Emode, Etype),
    N_CurrTime = PST_Start,
    get_next_pst(PST, Events_with_show, N_PST), ! .
% PST is fixed and PGM does not overrun PST
output_event_on_no_action(PGM, PST, CurrTime, Events_with_show, H_out_event, N_PST, N_CurrTime) :- 
    H_out_event = PGM,
    N_CurrTime = PST_Start,
    get_next_pst(PST, Events_with_show, N_PST) .
*/


is_t1_gt_t2(T1, T2) :-
    parse_time(T1, T1_DT),
    parse_time(T2, T2_DT),
    T1_DT > T2_DT .

is_t1_ge_t2(T1, T2) :-
    parse_time(T1, T1_DT),
    parse_time(T2, T2_DT),
    T1_DT >= T2_DT .

is_curr_time_in_event(Event_with_show, CT) :- 
    Event_with_show = event_with_show(_, _, E_S, E_End, _, _, _),
    parse_time(E_S, E_S_DT),
    parse_time(E_End, E_End_DT),
    parse_time(CT, CT_DT),
    writeln("CT_DT"+CT_DT),
    writeln("E_S_DT"+E_S_DT),
    writeln("E_End_DT"+E_End_DT),
    CT_DT >= E_S_DT,
    CT_DT < E_End_DT .

get_next_pgm(null_event, _, _, N_PGM):- N_PGM = null_event .
get_next_pgm(PST, CurrTime, _, N_PGM):-
    is_curr_time_in_event(PST, CurrTime),
    N_PGM = PST, !.
get_next_pgm(PST, CurrTime, Events_with_show, N_PGM):-
    get_next_pst(PST, Events_with_show, N_PST),
    get_next_pgm(N_PST, CurrTime, Events_with_show, N_PGM) .


get_tail_events(Event, [H_Event_with_show | T_Events_with_show], Tail_events) :-
    H_Event_with_show = Event,
    Tail_events = [H_Event_with_show | T_Events_with_show], ! .
get_tail_events(Event, [_ | T_Events_with_show], Tail_events) :-
    get_tail_events(Event, T_Events_with_show, Tail_events) .

scan_next_show_event(_, [], null_event) :- ! .
scan_next_show_event(ShowId, [H_Event_with_show | _], N_Show_Event) :-
    H_Event_with_show = event_with_show(E_Showid, _, _, _, _, _, _),
    ShowId \= E_Showid,
    N_Show_Event = H_Event_with_show, ! .
scan_next_show_event(ShowId, [_ | T_Events_with_show], N_Show_Event) :-
    scan_next_show_event(ShowId, T_Events_with_show, N_Show_Event) .


get_next_show_event(Event, Events_with_show, N_Show_Event) :- 
    get_tail_events(Event, Events_with_show, Tail_events),
    Event = event_with_show(ShowId, _, _, _, _, _, _),
    scan_next_show_event(ShowId, Tail_events, N_Show_Event) .



% Derive next PGM and PST on take_next_event action
next_pgm_core(_, PST, _, Events_with_show, take_next_event, N_PGM, N_PST) :-
    PST = event_with_show(_, _, _, _, follow, _, _),
    N_PGM = PST,
    get_next_pst(N_PGM, Events_with_show, N_PST), ! .
next_pgm_core(_, PST, _, Events_with_show, take_next_event, N_PGM, N_PST) :-
    PST = event_with_show(_, _, _, _, manual, _, _),
    N_PGM = PST,
    get_next_pst(N_PGM, Events_with_show, N_PST), ! .
next_pgm_core(_PGN, PST, CurrTime, Events_with_show, take_next_event, N_PGM, N_PST) :-
    PST = event_with_show(_, _, _, _, fixed, _, _),
    % get_next_pgm scans for next PGM i.e. N_PGM such that CurrTime is within N_PGM
    get_next_pgm(PST, CurrTime, Events_with_show, N_PGM),
    get_next_pst(N_PGM, Events_with_show, N_PST), ! .

next_pgm_core(PGM, _PST, _CurrTime, Events_with_show, take_next_show, N_PGM, N_PST) :-
    get_next_show_event(PGM, Events_with_show, N_Show_Event),
    N_Show_Event = event_with_show(_, _, _, _, follow, _, _),
    N_PGM = N_Show_Event,
    get_next_pst(N_PGM, Events_with_show, N_PST), ! .
next_pgm_core(PGM, _PST, _CurrTime, Events_with_show, take_next_show, N_PGM, N_PST) :-
    get_next_show_event(PGM, Events_with_show, N_Show_Event),
    N_Show_Event = event_with_show(_, _, _, _, manual, _, _),
    N_PGM = N_Show_Event,
    get_next_pst(N_PGM, Events_with_show, N_PST), ! .
next_pgm_core(PGM, _PST, CurrTime, Events_with_show, take_next_show, N_PGM, N_PST) :-
    get_next_show_event(PGM, Events_with_show, N_Show_Event),
    N_Show_Event = event_with_show(_, _, _, _, fixed, _, _),
    % get_next_pgm scans for next PGM i.e. N_PGM such that CurrTime is within N_PGM
    get_next_pgm(N_Show_Event, CurrTime, Events_with_show, N_PGM),
    get_next_pst(N_PGM, Events_with_show, N_PST), ! .



next_pgm_core(PGM, PST, CurrTime, Events_with_show, N_PGM, N_PST) :- 
    %pgm_overrun(PGM, PST),
    % This case covers the joining in progress and join at beginning of fixed PST
    writeln("---------++++ 1"+PGM),
    PGM = event_with_show(_, _, _, Pgm_Et, _, _, _),
    PST = event_with_show(_, _, Pst_St, _, fixed, _, _),
    writeln("---------++++ 1"+Pgm_Et),
    writeln("---------++++ 1"+Pst_St),
    writeln("---------++++ 1"+CurrTime),
    is_t1_ge_t2(CurrTime, Pst_St),
    is_t1_ge_t2(CurrTime, Pgm_Et),
    writeln("--------- 1"+PST),
    get_next_pgm(PST, CurrTime, Events_with_show, N_PGM),
    writeln("--------- 1"+N_PGM),
    get_next_pst(N_PGM, Events_with_show, N_PST), ! .
% PST is fixed and PGM duration overruns fixed PST, then preempt PGM and make PST as MGM at PST's fixed start time
next_pgm_core(PGM, PST, CurrTime, Events_with_show, N_PGM, N_PST) :- 
    %pgm_overrun(PGM, PST),
    writeln("--------- 2"+PGM),
    PST = event_with_show(_, _, CurrTime, _, fixed, _, _),
    N_PGM = PST,
    get_next_pst(N_PGM, Events_with_show, N_PST), ! .
next_pgm_core(PGM, PST, CurrTime, Events_with_show, N_PGM, N_PST) :- 
    %pgm_overrun(PGM, PST),
    writeln("--------- 3"+PGM),
    PST = event_with_show(_, _, CurrTime, _, truetime, _, _),
    % get_next_pgm scans for next PGM i.e. N_PGM such that CurrTime is within N_PGM
    N_PGM = PST,
    get_next_pst(N_PGM, Events_with_show, N_PST), ! .
next_pgm_core(PGM, null_event, CurrTime, Events_with_show, N_PGM, N_PST) :- 
    writeln("--------- 4"+PGM),
    PGM = event_with_show(_, _, _, _, fixed, _, _),
    % if CurrTime within PGM then no change, we continue to be PGM
    (is_curr_time_in_event(PGM, CurrTime) -> 
                                N_PGM = PGM,
                                N_PST = PST, ! ;
    N_PGM = null_event,
    N_PST = PST) .

next_pgm_core(PGM, PST, CurrTime, _Events_with_show, N_PGM, N_PST) :- 
    writeln("--------- 5"+PGM),
    %if PGM is fixed start and CurrTime is within PGM event duration range
    %PGM = event_with_show(_, _, _, _, fixed, _, _),
    % if CurrTime within PGM then no change, we continue to be PGM
    is_curr_time_in_event(PGM, CurrTime),
    N_PGM = PGM,
    N_PST = PST, ! .
next_pgm_core(PGM, PST, CurrTime, Events_with_show, N_PGM, N_PST) :- 
    %pgm_overrun(PGM, PST),
    writeln("--------- 6"+PST),
    writeln("--------- 6"+CurrTime),
    PST = event_with_show(_, _, _, _, follow, _, _),
    TMP_N_PGM = PST,
    update_new_pgm_to_new_st_time(TMP_N_PGM, CurrTime, N_PGM),
    writeln("--------- 6"+N_PGM),
    get_next_pst(N_PGM, Events_with_show, N_PST), ! .

next_pgm_core(PGM, PST, _CurrTime, _Events_with_show, N_PGM, N_PST) :- 
    writeln("--------- 7"+PGM),
    pgm_overrun(PGM, PST),
    PST = event_with_show(_, _, _, _, manual, _, _),
    % Since PST is a manual start mode event to change state we need explicit take_next_event action
    N_PGM = PGM,
    N_PST = PST, ! .


get_transition_times_from_events([], T_transition_times) :- T_transition_times = [], writeln("---1"), ! .
get_transition_times_from_events([H_TT_event | T_TT_events], [H_transition_time | [H_R_transition_time | T_transition_times]]) :-
    writeln("---2"),
    H_TT_event = event_with_show(_, _, Event_st, Event_End, _, _, _),
    H_transition_time = transition_time(Event_st, time, null_action),
    H_R_transition_time = transition_time(Event_End, time, null_action),
    get_transition_times_from_events(T_TT_events, T_transition_times), ! .

get_transition_times_from_actions([], T_transition_times) :- T_transition_times= [], ! .
get_transition_times_from_actions([H_Action | T_Action], [H_transition_time | T_transition_times]) :-
    writeln("---3"),
    H_Action = action(_, Action_time),
    H_transition_time = transition_time(Action_time, action, H_Action),
    get_transition_times_from_actions(T_Action, T_transition_times) .


cmp_transition_times(X, L, R) :- 
    L = transition_time(L_T, _, _),
    R = transition_time(R_T, _, _),
    parse_time(L_T, L_DT),
    parse_time(R_T, R_DT), 
    ((L_DT < R_DT) -> X = '<' ;
     (L_DT > R_DT) -> X = '>' ;
     X = '=' ) .

get_transition_times(Event_with_shows, Actions, Transition_times) :- 
    get_transition_times_from_events(Event_with_shows, Event_Transition_times),
    write("+++++++"+Event_Transition_times+"\n"),
    get_transition_times_from_actions(Actions, Action_Transition_times),
    write("#######"+Action_Transition_times+"\n"),
    append(Event_Transition_times, Action_Transition_times, All_transition_times),
    % Create a unified list of all transition time
    predsort(cmp_transition_times, All_transition_times, Transition_times) .
        

seek_for_non_hold_action_transition_time([H_Transition_time | T_Transition_times], Non_Hold_transition) :- 
    H_Transition_time = transition_time(_, action, take_next_event),
    Non_Hold_transition = H_Transition_time, ! .
seek_for_non_hold_action_transition_time([H_Transition_time | T_Transition_times], Non_Hold_transition) :- 
    H_Transition_time = transition_time(_, action, take_next_show),
    Non_Hold_transition = H_Transition_time, ! .
seek_for_non_hold_action_transition_time([H_Transition_time | T_Transition_times], Non_Hold_transition) :- 
    H_Transition_time = transition_time(_, action, unhold),
    Non_Hold_transition = H_Transition_time, ! .
seek_for_non_hold_action_transition_time([_H_Transition_time | T_Transition_times], Non_Hold_transition) :- 
    seek_for_non_hold_action_transition_time(T_Transition_times, Non_Hold_transition) .





% In the unrolled sequence of events remove events lying between a normal
% event which overlaps with a true time event and the true time event itself
% Sorted_events --> unroled sequence of events
% Stt_constrained_events -> Sorted_events \ {discarded events based on above constraint}
apply_true_time(Sorted_events, Stt_constrained_events) :- 
    get_tt_events(Sorted_events, TT_events),
    apply_tt_constraint(Sorted_events, TT_events, null_event, Stt_constrained_events) .

generate_plevent_intervals(CurrTime, PGM, null_event, _Events_with_shows,
     _, [H_OutInterval | T_outIntervals] ) :- 
     H_OutInterval = plevent_interval(CurrTime, inf, PGM, schedule_end), T_outIntervals=[], ! .
generate_plevent_intervals(CurrTime, PGM, _PST, _Events_with_shows,
     [], [H_OutInterval | T_outIntervals] ) :- 
     H_OutInterval = plevent_interval(CurrTime, inf, PGM, schedule_end), T_outIntervals=[], ! .
generate_plevent_intervals(CurrTime, PGM, PST, Events_with_show,
     [N_Transition_time | R_Transition_times], [H_OutInterval | T_outIntervals] ) :-
    
    N_Transition_time = transition_time(N_Curr_Time, action, action(take_next_event, _)),
    next_pgm_core(PGM, PST, N_Curr_Time, Events_with_show, take_next_event, N_PGM, N_PST),
    H_OutInterval = plevent_interval(CurrTime, N_Curr_Time, PGM, take_next_event),
    generate_plevent_intervals(N_Curr_Time, N_PGM, N_PST, Events_with_show, R_Transition_times, T_outIntervals), ! .

generate_plevent_intervals(CurrTime, PGM, PST, Events_with_show,
     [N_Transition_time | R_Transition_times], [H_OutInterval | T_outIntervals] ) :-
    
    N_Transition_time = transition_time(N_Curr_Time, action, action(take_next_show, _)),
    next_pgm_core(PGM, PST, N_Curr_Time, Events_with_show, take_next_show, N_PGM, N_PST),
    H_OutInterval = plevent_interval(CurrTime, N_Curr_Time, PGM, take_next_show),
    generate_plevent_intervals(N_Curr_Time, N_PGM, N_PST, Events_with_show, R_Transition_times, T_outIntervals), ! .

generate_plevent_intervals(CurrTime, PGM, PST, Events_with_show,
     [N_Transition_time | R_Transition_times], [H_OutInterval | T_outIntervals]) :-
    
    N_Transition_time = transition_time(_N_Curr_Time, action, action(hold, _)),
    % Following will discard all transition times which do not correspond to a non-hold action
    seek_for_non_hold_action_transition_time(R_Transition_times, Non_hold_transition),
    ((Non_hold_transition = null_transition_time) -> H_OutInterval = plevent_interval(CurrTime, inf, PGM, schedule_end), T_outIntervals = [] ;
        Non_hold_transition = transition_time(A_Time, action(Action, _)),
        H_OutInterval = plevent_interval(CurrTime, A_Time, PGM, Action),
        delete(R_Transition_times, Non_hold_transition, NR_Transition_times),
        next_pgm_core(PGM, PST, A_Time, Events_with_show, take_next_show, N_PGM, N_PST),
        generate_plevent_intervals(A_Time, N_PGM, N_PST, Events_with_show, NR_Transition_times, T_outIntervals)) , ! .

generate_plevent_intervals(CurrTime, PGM, PST, Events_with_show,
     [N_Transition_time | R_Transition_times], [H_OutInterval | T_outIntervals]) :-
    
    N_Transition_time = transition_time(N_Curr_Time, time, null_action),
    writeln("^^^^^N_Curr_Time"+N_Curr_Time),
    writeln("PGM"+PGM),
    writeln("PST"+PST),
    next_pgm_core(PGM, PST, N_Curr_Time, Events_with_show, N_PGM, N_PST),
    writeln("N_PGM"+N_PGM),
    ((N_PGM \= PGM) -> H_OutInterval = plevent_interval(CurrTime, N_Curr_Time, PGM, null_action), 
            writeln("PGM"+PGM),
            generate_plevent_intervals(N_Curr_Time, N_PGM, N_PST, Events_with_show, R_Transition_times, T_outIntervals) ;
    % Following ase is which N_PGM = PGM
    generate_plevent_intervals(CurrTime, PGM, PST, Events_with_show, R_Transition_times, [H_OutInterval | T_outIntervals]) ), 
    ! .





% show_to_plevents(Schedule, Action_events, Plevents):-
%     schedule_to_sorted_events(Schedule, Sorted_events),
%     apply_true_time(Sorted_events, Stt_constrained_events),
%     events_date_time_range(Stt_constrained_events, Events_dt_range, Action_events),
%     plevents(Events_dt_range, Plevents) .


