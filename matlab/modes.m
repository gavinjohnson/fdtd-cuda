% function for calculating cutoff frequencies
fcut = @(n,m,p) c*sqrt((n/(2.0*Dx))^2 + (m/(2.0*Dy))^2 + (p/(2.0*Dz))^2);
% init cutoff freq var
fc=0;
% struct for encapsulating mode and frequency information
fcs=struct('f',0, 'mode','');
% list to be filled as fcs are calculated
fcList = [];
i=0;
% calculate the modes
for n = 0:9
    for m=0:9
        for p=0:9
            % calculate the cutoff frequency
            fc=round(fcut(n,m,p)/1000000,2);
            % add it to the list if less than max freq
            if fc < fmax
                % check for valid mode
                mnp=sort([n m p]);
                if (mnp(1) ~= 0) || (mnp(2)~=0)
                    i = i + 1;
                    fcList = [fcList fcs];
                    % add to struct
                    fcList(i).f = fc;
                    fcList(i).mode = strcat(int2str(n),int2str(m),int2str(p));
                end
            end
        end
    end
end

% arrays to fill with freqs and modes
cutfreqs=zeros(length(fcList),1);
mods=cell(length(fcList),1);

i=0;
% build arrays
for fr=fcList
    i=i+1;
    mods{i} = '';
    if any(fr.f==cutfreqs)
        j=0;
        for j=1:length(cutfreqs)
            
            if cutfreqs(j) == fr.f
                mods{j} = [mods{j} '\n' fr.mode];
                break
            end
        end
    else
        mods{i} = [num2str(round(fr.f,1)) '[MHz]\n\nMode(s):\n' fr.mode];
    end
    cutfreqs(i) = fr.f;
end

% format the mode strings
for i=1:length(mods)
    mods{i} = sprintf(mods{i});
end
    
    
    
    