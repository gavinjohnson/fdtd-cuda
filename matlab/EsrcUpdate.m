% Update E source(s)
for s=src
    if s.srcType == 'J'
        if s.dir == 'x'
            Ex(s.i1:s.i2-1,s.j1:s.j2,s.k1:s.k2) = ...
                Ex(s.i1:s.i2-1,s.j1:s.j2,s.k1:s.k2) - cJ*s.srcSig(t);
        elseif s.dir == 'y'
            Ey(s.i1:s.i2,s.j1:s.j2-1,s.k1:s.k2) = ...
                Ey(s.i1:s.i2,s.j1:s.j2-1,s.k1:s.k2) - cJ*s.srcSig(t);
        elseif s.dir == 'z'
            Ez(s.i1:s.i2,s.j1:s.j2,s.k1:s.k2-1) = ...
                Ez(s.i1:s.i2,s.j1:s.j2,s.k1:s.k2-1) - cJ*s.srcSig(t);
        end
    end
end    