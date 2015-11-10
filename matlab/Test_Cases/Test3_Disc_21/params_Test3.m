% optional live plots (choose only one)
% watch a live vector plot of the center of the space
liveQuiverPlot = 0;
% watch the fft converge as the simulation proceeds
liveFftPlot = 0;

% optional markings on resultant fft plot
% mark all theoretical mode frequencies on the fft plot
markModes = 0;
% mark all peaks and the error in relation to the theoretical mode
markPeaksErr = 1;


% global domain size
Dx = 1.0;
Dy = 1.0;
Dz = 1.0;

% number of nodes in each direction
Nx = 21;
Ny = 21;
Nz = 21;

% Courant number
CFLN = 0.99;

% simulation time (in seconds) (var = simtime)
% or number of steps (var = nt)
simtime = 4e-7;
%nt=100;

% exterior boundaries
% !!! all are PEC for this project !!!

% struct for identifying PEC blocks in the domain space
PECblock = struct('i1',0,'i2',0,   'j1',0,'j2',0,   'k1',0,'k2',0);

% set up any PEC blocks in the domain
% PEC(1) = PECblock;
% PEC(1).i1=6;
% PEC(1).i2=8;
% PEC(1).j1=6;
% PEC(1).j2=8;
% PEC(1).k1=5;
% PEC(1).k2=10;


% struct for setting up sampling
sampleLoc = struct('type','E','dir','z',...
    'i',16,   'j',16,   'k',16);


% source signature
sig = 'diffGauss';

if strcmp(sig,'gauss')
    tw = 1e-9;  % standard deviation of pulse
    to = 5*tw;  % mean time of pulse
    mag = 1;    % source magnitude
    srcSig = @(t) mag*exp(-(t-to).^2./(tw^2)); 
elseif strcmp(sig, 'diffGauss')
    tw = 1e-9;  % standard deviation of pulse
    to = 5*tw;  % mean time of pulse
    mag = 1;    % source magnitude
    srcSig = @(t) -(mag*exp(-(t - to).^2./tw^2).*(2.0*t - 2.0*to))./tw;
elseif strcmp(sig, 'modGauss')
    tw = 1e-9;  % standard deviation of pulse
    to = 5*tw;  % mean time of pulse
    mag = 1;    % source magnitude
    fm = 3/tw;  % modulated frequency
    srcSig = @(t) mag*exp(-(t-to).^2./(tw^2)).*sin(2.*pi.*fm.*t);
elseif strcmp(sig, 'rampGauss')
elseif strcmp(sig, 'hamming')
else
    srcSig = @(t) 0;
end

% current source struct
source = struct(        ...
    'srcSig' ,srcSig,   ...
    'srcType','J',      ...
    'dir'    ,'z',      ...
    'i1',0   ,'i2',0,   ...
    'j1',0   ,'j2',0,   ...
    'k1',0   ,'k2',0);

% current source setup
src = source;
src.srcType = 'J';
src.dir = 'z';
src.i1 = 8;
src.i2 = 8;
src.j1 = 8;
src.j2 = 8;
src.k1 = 8;
src.k2 = 12;

% material parameters
mu_r   = 1;
eps_r  = 1;







