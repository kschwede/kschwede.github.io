% Wave equation in 1D with finite differences time domain

nx = 200; % number of internal nodes

xs = [-2,2];

dx = (xs(2)-xs(1))/(nx+1);

gx = xs(1)+(0:nx+1)*dx ;% grid in x

% source location
isrc = nx/2;
% source time
t0 = 0.5;
bt = 100;
%src = @(t) sin(2*pi*t);
src = @(t) -2*bt*(t-t0)*exp(-bt*(t-t0)^2)/sqrt(2*bt);

% number of time steps
nt = 600;

% mass density
rho=1;

% velocity
c=1;

% time interval
ts = [0,2];
dt = (ts(2)-ts(1))/nt;

% initialization (everything quiet)
p = zeros(nx+2,1);
u = zeros(nx+1,1);

% 
fprintf('  cfl=%d\n',c*dt/dx);

t = ts(1);
for i=1:nt,
 u = u - (dt/rho/dx)*(p(2:nx+2)-p(1:nx+1));
 p(2:nx+1) = p(2:nx+1) - (c^2*rho*dt/dx)*(u(2:nx+1)-u(1:nx));
 p(1)=0; p(nx+2)=0; % simple boundary conditions
 t = t + dt; % advance time
 if (t<=pi/2)
  p(isrc) = src(t); % hard source
 end;
 if (mod(i,4)==0)
  plot(gx,p); 
  axis([xs(1),xs(2),-2,2]);
  title(sprintf('t=%d\n',t));
  pause(0.1)
 end;
end;

