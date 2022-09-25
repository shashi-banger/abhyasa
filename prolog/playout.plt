% For running unit test run
% swipl -t "load_test_files([]), run_tests." -s playout.pl

:- begin_tests(playout).
:- include(playout).



test(overlap) :- 
    write("++++++++abc\n"),
    E1 = event_with_show("show-1", "event-1", "2022-05-20T10:00:00", "2022-05-20T10:30:00", fixed, duration, primary),
    E2 = event_with_show("show-2", "event-222", "2022-05-20T10:15:00", "2022-05-20T10:40:00", fixed, duration, primary),
    overlap(E1, E2).

test(get_tt_events) :- 
    E1 = event_with_show("show-1", "event-1", "2022-05-20T10:00:00", "2022-05-20T10:30:00", fixed, duration, primary),
    E2 = event_with_show("show-2", "event-222", "2022-05-20T10:15:00", "2022-05-20T10:40:00", truetime, duration, primary),
    get_tt_events([E1,E2], TT),
    TT = [E2] .

test(get_tt_events) :- 
    E1 = event_with_show("show-1", "event-1", "2022-05-20T10:00:00", "2022-05-20T10:30:00", truetime, duration, primary),
    E2 = event_with_show("show-2", "event-222", "2022-05-20T10:15:00", "2022-05-20T10:40:00", truetime, duration, primary),
    E3 = event_with_show("show-3", "event-311", "2022-05-20T11:00:00", "2022-05-20T11:30:00", truetime, duration, primary),
    get_tt_events([E1,E2,E3], TT),
    write(TT+"\n"),
    TT = [E1,E2,E3] .

test(get_tt_events) :- 
    E1 = event_with_show("show-1", "event-1", "2022-05-20T10:00:00", "2022-05-20T10:30:00", fixed, duration, primary),
    E2 = event_with_show("show-2", "event-222", "2022-05-20T10:15:00", "2022-05-20T10:40:00", fixed, duration, primary),
    E3 = event_with_show("show-3", "event-311", "2022-05-20T11:00:00", "2022-05-20T11:30:00", fixed, duration, primary),
    get_tt_events([E1,E2,E3], TT),
    write(TT),
    TT = [] .


test(apply_tt_constraint) :-
    E1 = event_with_show("show-1", "event-1", "2022-05-20T10:00:00", "2022-05-20T10:30:00", fixed, duration, primary),
    E2 = event_with_show("show-2", "event-222", "2022-05-20T10:15:00", "2022-05-20T10:40:00", truetime, duration, primary),
    E3 = event_with_show("show-3", "event-311", "2022-05-20T11:00:00", "2022-05-20T11:30:00", fixed, duration, primary),
    apply_tt_constraint([E1,E2,E3], [E2], null_event, TT_constrained_events),
    write(TT_constrained_events),
    TT_constrained_events = [E1,E2,E3] .


test(apply_tt_constraint) :-
    E1 = event_with_show("show-1", "event-111", "2022-05-20T10:00:00", "2022-05-20T10:15:00", fixed, duration, primary),
    E2 = event_with_show("show-1", "event-122", "2022-05-20T10:15:00", "2022-05-20T10:45:00", fixed, duration, primary),
    E3 = event_with_show("show-1", "event-133", "2022-05-20T10:45:00", "2022-05-20T11:15:00", fixed, duration, primary),
    E4 = event_with_show("show-2", "event-211", "2022-05-20T10:30:00", "2022-05-20T11:00:00", truetime, duration, primary),
    E5 = event_with_show("show-3", "event-311", "2022-05-20T11:00:00", "2022-05-20T11:30:00", fixed, duration, primary),
    E6 = event_with_show("show-3", "event-322", "2022-05-20T11:30:00", "2022-05-20T12:00:00", fixed, duration, primary),
    E7 = event_with_show("show-3", "event-333", "2022-05-20T12:00:00", "2022-05-20T12:30:00", fixed, duration, primary),
    E8 = event_with_show("show-4", "event-411", "2022-05-20T11:15:00", "2022-05-20T12:00:00", truetime, duration, primary),
    E9 = event_with_show("show-4", "event-422", "2022-05-20T12:00:00", "2022-05-20T12:30:00", fixed, duration, primary),
    apply_tt_constraint([E1,E2,E3,E4,E5,E6,E7,E8,E9], [E4,E8], null_event, TT_constrained_events),
    write(TT_constrained_events),
    % Expected output
    TT_constrained_events = [E1,E2,E4,E5,E8,E9] .


test(get_transition_times) :-
    E1 = event_with_show("show-1", "event-111", "2022-05-20T10:00:00", "2022-05-20T10:15:00", fixed, duration, primary),
    E2 = event_with_show("show-1", "event-122", "2022-05-20T10:15:00", "2022-05-20T10:45:00", follow, duration, primary),
    E3 = event_with_show("show-1", "event-133", "2022-05-20T10:45:00", "2022-05-20T11:00:00", follow, duration, primary),
    E4 = event_with_show("show-3", "event-311", "2022-05-20T11:00:00", "2022-05-20T11:30:00", fixed, duration, primary),
    E5 = event_with_show("show-3", "event-322", "2022-05-20T11:30:00", "2022-05-20T12:10:50", follow, duration, primary),
    E6 = event_with_show("show-3", "event-333", "2022-05-20T12:10:50", "2022-05-20T12:30:00", follow, duration, primary),
    Events = [E1, E2, E3, E4, E5, E6],
    A1 = action(hold, "2022-05-20T10:55:00"),
    A2 = action(unhold, "2022-05-20T11:10:05"),
    get_transition_times(Events, [A1,A2], Transition_times),
    writeln("%%%%%%%%%%%%%"+Transition_times),
    T1 = transition_time("2022-05-20T10:00:00",time,null_action),
    T2 = transition_time("2022-05-20T10:15:00",time,null_action),
    T3 = transition_time("2022-05-20T10:45:00",time,null_action),
    T4 = transition_time("2022-05-20T10:55:00",action,action(hold,"2022-05-20T10:55:00")),
    T5 = transition_time("2022-05-20T11:00:00",time,null_action),
    T6 = transition_time("2022-05-20T11:10:05",action,action(unhold,"2022-05-20T11:10:05")),
    T7 = transition_time("2022-05-20T11:30:00",time,null_action),
    T8 = transition_time("2022-05-20T12:10:50",time,null_action), 
    T9 = transition_time("2022-05-20T12:30:00",time,null_action), 
    Transition_times = [T1, T2, T3, T4, T5, T6, T7, T8, T9],
    writeln("#%%%%%%%%%%%#"+[T1, T2, T3, T4, T5, T6, T7, T8, T9]) .

test(basic_shedule_1) :-   
    writeln(""),
    writeln("#########basic_schedule_1"),
    E1 = event_with_show("show-1", "e-111", "2022-05-02T09:30:00.000", "2022-05-02T10:05:00.000", fixed, duration, primary),
    E2 = event_with_show("show-1", "e-112", "2022-05-02T10:05:00.000", "2022-05-02T10:30:00.000", follow, duration, primary),
    E3 = event_with_show("show-2", "e-211", "2022-05-02T10:00:00.000", "2022-05-02T10:45:00.000", truetime, duration, primary),
    get_tt_events([E1,E2,E3], TT),
    apply_tt_constraint([E1,E2,E3], TT, null_event, TT_constrained_events),
    writeln("$$$$$Truetime constrained$$$$$$$"+TT_constrained_events),
    [PGM | [PST | _]] = TT_constrained_events,
    get_transition_times(TT_constrained_events, [], Transition_times),
    writeln(Transition_times),
    [H_Transition_time | T_Transition_times] = Transition_times,
    generate_plevent_intervals("2022-05-02T09:30:00.000", PGM, PST, TT_constrained_events,
        T_Transition_times, OutputPlEvents),
    write(OutputPlEvents) .   


test(basic_shedule_2) :- 
    writeln(""),
    writeln("#########basic_schedule_2"),
    E1 = event_with_show("show-1", "e-111", "2022-05-02T09:30:00.000", "2022-05-02T10:05:00.000", fixed, duration, primary),
    E2 = event_with_show("show-1", "e-112", "2022-05-02T10:05:00.000", "2022-05-02T10:30:00.000", follow, duration, primary),
    E3 = event_with_show("show-2", "e-211", "2022-05-02T10:00:00.000", "2022-05-02T10:30:00.000", fixed, duration, primary),
    E4 = event_with_show("show-3", "e-311", "2022-05-02T10:20:00.000", "2022-05-02T11:00:00.000", fixed, duration, primary),
    get_tt_events([E1,E2,E3,E4], TT),
    apply_tt_constraint([E1,E2,E3,E4], TT, null_event, TT_constrained_events),
    writeln("====Truetime constrained===="+TT_constrained_events),
    [PGM | [PST | _]] = TT_constrained_events,
    get_transition_times(TT_constrained_events, [], Transition_times),
    writeln(Transition_times),
    [H_Transition_time | T_Transition_times] = Transition_times,
    generate_plevent_intervals("2022-05-02T09:30:00.000", PGM, PST, TT_constrained_events,
        T_Transition_times, OutputPlEvents),
    write(OutputPlEvents) .   

test(basic_shedule_3) :- 
    writeln(""),
    writeln("#########basic_schedule_2"),
    E1 = event_with_show("show-1", "e-111", "2022-05-02T09:30:00.000", "2022-05-02T10:05:00.000", fixed, duration, primary),
    E2 = event_with_show("show-1", "e-112", "2022-05-02T10:05:00.000", "2022-05-02T10:30:00.000", follow, duration, primary),
    E3 = event_with_show("show-2", "e-211", "2022-05-02T10:00:00.000", "2022-05-02T10:30:00.000", follow, duration, primary),
    E4 = event_with_show("show-3", "e-311", "2022-05-02T10:40:00.000", "2022-05-02T11:00:00.000", follow, duration, primary),
    get_tt_events([E1,E2,E3,E4], TT),
    apply_tt_constraint([E1,E2,E3,E4], TT, null_event, TT_constrained_events),
    writeln("====Truetime constrained===="+TT_constrained_events),
    [PGM | [PST | _]] = TT_constrained_events,
    get_transition_times(TT_constrained_events, [], Transition_times),
    writeln(Transition_times),
    [H_Transition_time | T_Transition_times] = Transition_times,
    generate_plevent_intervals("2022-05-02T09:30:00.000", PGM, PST, TT_constrained_events,
        T_Transition_times, OutputPlEvents),
    write(OutputPlEvents) .   





:- end_tests(playout).