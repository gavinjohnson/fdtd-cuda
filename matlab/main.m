% clear everything to init
clear;

% read in the parameters for the computation
params;
%params_Test1;
%params_Test2;
%params_Test3;



% material parameters and speed of light
mu_o = 1.2566370614e-6;
eps_o = 8.854187817e-12;
mu = mu_r * mu_o;
eps = eps_r * eps_o;
c = 1.0/sqrt(mu*eps);

% discretization size computation
dx=Dx/(Nx-1);
dy=Dy/(Ny-1);
dz=Dz/(Nz-1);
dt=CFLN/(c*sqrt(dx^-2+dy^-2+dz^-2));

% build the E and H space
% E-field space
Ex = zeros(Nx,Ny,Nz);
Ey = zeros(Nx,Ny,Nz);
Ez = zeros(Nx,Ny,Nz);
% H-field space
Hx = zeros(Nx,Ny,Nz);
Hy = zeros(Nx,Ny,Nz);
Hz = zeros(Nx,Ny,Nz);

% calc number of time steps if simtime given instead of nt
if ~ exist('nt','var')
    nt = floor(simtime/dt);
end

% build coefficient matrices
% E-field coefficients
cExy = ones(Nx,Ny,Nz) * (dt/(eps*dy));
cExz = ones(Nx,Ny,Nz) * (dt/(eps*dz));
cEyx = ones(Nx,Ny,Nz) * (dt/(eps*dx));
cEyz = ones(Nx,Ny,Nz) * (dt/(eps*dz));
cEzx = ones(Nx,Ny,Nz) * (dt/(eps*dx));
cEzy = ones(Nx,Ny,Nz) * (dt/(eps*dy));
% H-field coefficients
cHxy = ones(Nx,Ny,Nz) * (dt/(mu*dy));
cHxz = ones(Nx,Ny,Nz) * (dt/(mu*dz));
cHyx = ones(Nx,Ny,Nz) * (dt/(mu*dx));
cHyz = ones(Nx,Ny,Nz) * (dt/(mu*dz));
cHzx = ones(Nx,Ny,Nz) * (dt/(mu*dx));
cHzy = ones(Nx,Ny,Nz) * (dt/(mu*dy));

% set the E-field coefficients to zero if there is a PEC block
if exist('PEC','var')
    for P=PEC
        cExy(P.i1:P.i2,P.j1:P.j2,P.k1:P.k2) = 0;
        cExz(P.i1:P.i2,P.j1:P.j2,P.k1:P.k2) = 0;
        cEyx(P.i1:P.i2,P.j1:P.j2,P.k1:P.k2) = 0;
        cEyz(P.i1:P.i2,P.j1:P.j2,P.k1:P.k2) = 0;
        cEzx(P.i1:P.i2,P.j1:P.j2,P.k1:P.k2) = 0;
        cEzy(P.i1:P.i2,P.j1:P.j2,P.k1:P.k2) = 0;
    end
end

% source coefficients
cJ = dt/eps;
cM = dt/mu;

% build a sampling vector
N = (2^nextpow2(nt))*2;
sample = zeros(N,1);

% parameter used for the live fft plot
maxY=0.0001;
% time (make first update be at t=0)
t=-0.5*dt;
for n=0:nt*2
    % increment time by dt/2
    t=t+0.5*dt;
    % update the E-field
    Eupdate;
    % increment time by dt/2
    t=t+0.5*dt;
    % update the H-field
    Hupdate;
    % update the sample
    pullSample;
    % optional live plot outputs (chosen in params.m)
    if liveQuiverPlot
        quiver(Ex(:,:,ceil(Nz/2)),Ey(:,:,ceil(Nz/2)));
        title('Center of Simulation Space in x-y plane');
        set(gca,'YTickLabel',{''});
        set(gca,'XTickLabel',{''});
        pause(0.01);
    elseif liveFftPlot
        fmax = 400;                     % max frequency [MHz]
        Fs = 1/(dt);                    % Sampling frequency
        df = Fs/N;                      % frequency discretization size
        Y = fft(sample);                % fft
        P2 = abs(Y/N);                  % abs of fft result
        P1 = P2(1:N/2+1);               % slice out the first half
        f = (df*(0:(N/2)))./1e6;        % frequency [MHz]
        if max(P1(f < fmax)) > maxY
            maxY = max(P1(f < fmax));
        end
        plot(f(f < fmax), P1(f < fmax)) % plot the fft beneath the threshold
        ylim([0 (maxY*1.1)]);
        title('Frequency Domain Convergance')
        xlabel('f [MHz]')
        set(gca,'YTickLabel',{''});
        pause(0.01);
    end
end

% set up and calculate the fft
fmax = 400;                     % max frequency [MHz]
Fs = 1/(dt);                    % Sampling frequency
df = Fs/N;                      % frequency discretization size
Y = fft(sample);                % fft
P2 = abs(Y/N);                  % abs of fft result
P1 = P2(1:N/2+1);               % slice out the first half
f = (df*(0:(N/2)))./1e6;        % frequency [MHz]
if max(P1(f < fmax)) > maxY
    maxY = max(P1(f < fmax))*1.3;
end
plot(f(f < fmax), P1(f < fmax)) % plot the fft beneath the threshold
minY = min(P1) - maxY*0.1;
ylim([minY maxY]);
title('Frequency Domain')%title('Frequency Domain and Theoretical Modes')
xlabel('f [MHz]')
set(gca,'YTickLabel',{''});

% calculate the max value output
maxVal = max(P1(f < fmax));

% calculate the mode frequencies
modes;

% calculate a position to superimpose the mode markers
height = (ones(length(cutfreqs),1)*maxVal/10.0)*1;
% var for spacing the mode text away from the point markers
shiftx=6;
shifty=0;%height(1)/2;
% plot the mode information
if markModes
    hold on
    scatter(cutfreqs, height,'x','linewidth',2);
    text(cutfreqs+shiftx, height+shifty, mods);
    hold off
end

% calculate and generate markers for error calculations
errMarkers;

% plot peaks and error notation
shiftx=-20;
shifty=height(1)/2.0;
if markPeaksErr
    hold on
    scatter(measFreqs,measPoints)
    text(measFreqs+shiftx, measPoints+shifty, errMark);
    hold off
end




