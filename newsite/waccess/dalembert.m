xs = linspace(-10,10); % grid in x
ts = linspace(0,3);  % times for snapshots
size(xs)
size(ts)

c = 10; % velocity

psi = @(x) exp(-x.^2);
for t=ts,

% compute D'Alembert's solution top 1D WEQ
u = 0.5 * ( psi(xs-c*t) + psi(xs+c*t) );

% plot solution
plot(xs,u);
axis([-10 10 0 1])
pause(0.1); % wait a little bit so that we can see the wave

end;