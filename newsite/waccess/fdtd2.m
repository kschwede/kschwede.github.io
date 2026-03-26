% Wave equation in 2D with finite differences time domain

nx = 400; ny=400; % number of internal nodes

xs = [-2,2]; ys = [-2,2];

dx = (xs(2)-xs(1))/(nx+1);
dy = (ys(2)-ys(1))/(ny+1);

gx = xs(1)+(0:nx+1)*dx ;% grid in x
gy = ys(1)+(0:ny+1)*dy ;% grid in y

% source location
isrc = nx/2; jsrc = ny/8;

% source time
t0 = 0.5; bt = 100;
%src = @(t) sin(2*pi*t);
src = @(t) -2*bt*(t-t0)*exp(-bt*(t-t0)^2)/sqrt(2*bt);

% number of time steps
nt = 2000;

% mass density
rho = 1;

% velocity
c=1;

% time interval
ts = [0,10];
dt = (ts(2)-ts(1))/nt;

% initialization (everything quiet)
p = zeros(nx+2,ny+2); % pressure
ux = zeros(nx+1,ny+2);   % x velocity
uy = zeros(nx+2,ny+1);   % y velocity

% 
fprintf('  cfl=%d\n',c*dt/dx);

t = ts(1);
tic
for i=1:nt,
 ux = ux - (dt/rho/dx)*(p(2:nx+2,:)-p(1:nx+1,:));
 uy = uy - (dt/rho/dy)*(p(:,2:ny+2)-p(:,1:ny+1));
 p(2:nx+1,2:ny+1) = p(2:nx+1,2:ny+1) ...
           - (c^2*rho*dt/dx)*(ux(2:nx+1,2:ny+1)-ux(1:nx,2:ny+1))...
	   - (c^2*rho*dt/dy)*(uy(2:nx+1,2:ny+1)-uy(2:nx+1,1:ny));
 p(1,:)=0; p(nx+2,:)=0; %initial conditions
 p(:,1)=0; p(:,ny+2)=0;% simple Dirichlet boundary conditions
 t = t + dt; % advance time
 p(isrc,jsrc) = src(t); % hard source (we set the value of the pressure field to a known value and we find the values of the radiated field)
 if (mod(i,100)==0)
 %if (0)
  imagesc(gx,gy,p); caxis(max(max(abs(p)))*[-1,1]); 
  colormap(polarmap(255))
  title(sprintf('t=%d\n',t)); axis equal; axis tight;
  pause(0.1)
 end;
end;
te=toc;
fprintf('time per iter= %f s\n',te/nt);
