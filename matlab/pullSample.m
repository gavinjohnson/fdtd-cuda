% pull the sample

% H-Field Sampling
if sampleLoc.type == 'H'
    if sampleLoc.dir == 'x'
        sample(n+1) = Hx(sampleLoc.i,sampleLoc.j,sampleLoc.k);
    elseif sampleLoc.dir == 'y'
        sample(n+1) = Hy(sampleLoc.i,sampleLoc.j,sampleLoc.k);
    elseif sampleLoc.dir == 'z'
        sample(n+1) = Hz(sampleLoc.i,sampleLoc.j,sampleLoc.k);
    end
    
% E-Field Sampling
elseif sampleLoc.type == 'E'
    if sampleLoc.dir == 'x'
        sample(n+1) = Ex(sampleLoc.i,sampleLoc.j,sampleLoc.k);
    elseif sampleLoc.dir == 'y'
        sample(n+1) = Ey(sampleLoc.i,sampleLoc.j,sampleLoc.k);
    elseif sampleLoc.dir == 'z'
        sample(n+1) = Ez(sampleLoc.i,sampleLoc.j,sampleLoc.k);
    end
end