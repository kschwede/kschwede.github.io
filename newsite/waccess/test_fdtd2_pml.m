%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Some fundamental physical quantities
dom.c0   = 1500;           % background velocity (m/s)
dom.f0   = 2e5;            % central frequency (Hz)
la0  = dom.c0/dom.f0;      % central wavelength (m)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% extent of computational domain in x and y (Not including PML)
dom.xmin=0*la0; dom.xmax=10*la0;
dom.ymin=0*la0; dom.ymax=20*la0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% spatial grid
ppwl = 20; % points per wavelength
dx = la0/ppwl; dy = la0/ppwl;
dom.nx = 1 + round((dom.xmax-dom.xmin)/dx);
dom.ny = 1 + round((dom.ymax-dom.ymin)/dy);
gx = linspace(dom.xmin,dom.xmax,dom.nx);
gy = linspace(dom.ymin,dom.ymax,dom.ny);
[X,Y]=ndgrid(gx,gy);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% wave velocity lives on the same grid cells as the pressure
vel = @(x,y) dom.c0*(1 + 0.1*( (4*la0<=x)&(x<=6*la0)&(12*la0<=y)&(y<=14*la0) ));
dom.c = vel(X,Y); 
cmax = max(max(dom.c));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% temporal discretization
dom.dt = 0.6*dx/sqrt(2)/cmax;
dom.nt = 1800;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% options
opts.plotwave=10;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set up source(s)
t0 = 1/dom.f0;
sources.location = [5*la0; 1*la0];
sources.signal =   {@(t) exp(-pi^2*(dom.f0)^2*(t-t0).^2)};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set up equally spaced receivers on a line with depth recv_depth
recv_spacing = la0/2;
recv_depth   = la0;
receivers = [ dom.xmin:recv_spacing:dom.xmax
              la0*ones(1, 1+floor((dom.xmax-dom.xmin)/recv_spacing) ) ];

traces = fdtd2_pml(dom,sources,receivers,opts);

% suppress direct arrivals
traces(:,1:700) = 0;

figure(2);
imagesc(traces); caxis(max(max(abs(traces)))*[-1,1]); 
