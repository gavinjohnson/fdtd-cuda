% update H source(s)
for s=src
    if s.srcType == 'M'
        if s.dir == 'x'
            Hx(s.i1:s.i2,s.j1:s.j2,s.k1:s.k2) = ...
                Hx(s.i1:s.i2,s.j1:s.j2,s.k1:s.k2) - cM*s.srcSig(t);
        elseif s.dir == 'y'
            Hy(s.i1:s.i2,s.j1:s.j2,s.k1:s.k2) = ...
                Hy(s.i1:s.i2,s.j1:s.j2,s.k1:s.k2) - cM*s.srcSig(t);
        elseif s.dir == 'z'
            Hz(s.i1:s.i2,s.j1:s.j2,s.k1:s.k2) = ...
                Hz(s.i1:s.i2,s.j1:s.j2,s.k1:s.k2) - cM*s.srcSig(t);
        end
    end
end