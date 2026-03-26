% assumes domain, sources, receivers and traces are in memory from a previous run


tr_traces = fliplr(traces); % do time reversal by flipping array

% cut off some time so that the last simulation time is the image
tr_dom = dom;
tr_dom.nt = dom.nt-floor(t0/dom.dt);

% create new source and receivers structs from previous run
tr_sources.location = receivers;
tr_sources.signal = tr_traces(:,1:tr_dom.nt);
tr_receivers = sources.location;

im=fdtd2_pml(tr_dom,tr_sources,tr_receivers,opts);

