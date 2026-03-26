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
dom.c = dom.c0 + 0*X;
cmax = max(max(dom.c));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% temporal discretization
dom.dt = 0.6*dx/sqrt(2)/cmax;
dom.nt = 800;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% options
opts.plotwave=10;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set up source(s)
t0 = 1/dom.f0;
sources.location = [7;13]*la0;
sources.signal = { @(t) (t-t0).*exp(-pi^2*(dom.f0)^2*(t-t0).^2) };

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set up equally spaced receivers on a line with depth recv_depth
recv_spacing = la0/2;
recv_depth   = la0;
receivers = [ dom.xmin:recv_spacing:dom.xmax
              la0*ones(1, 1+floor((dom.xmax-dom.xmin)/recv_spacing) ) ];

traces = fdtd2_pml(dom,sources,receivers,opts);

figure(2);
imagesc(traces); caxis(max(max(abs(traces)))*[-1,1]); 

