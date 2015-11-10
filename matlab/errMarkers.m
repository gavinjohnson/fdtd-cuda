% measure the peaks in the fft
% range to search for peaks +/-
freqRange = 20;
uniqueFreqs=unique(cutfreqs);
measPoints = zeros(length(uniqueFreqs),1);
measFreqs = zeros(length(uniqueFreqs),1);
freqErr = zeros(length(uniqueFreqs),1);
err_vec = zeros(length(uniqueFreqs),1);
errMark = cell(length(uniqueFreqs),1);
for i=1:length(uniqueFreqs)
    fr=uniqueFreqs(i);
    minf = fr-freqRange;
    maxf = fr+freqRange;
    measPoints(i) = max(P1((f> minf(1) & f < maxf(1))));
    measFreqs(i) = round(f(P1==measPoints(i)),1);
    err_vec(i) = 100*(abs(measFreqs(i) - fr)/abs(fr));
    freqErr(i) = round(100*(abs(measFreqs(i) - fr)/abs(fr)),1);
    errMark{i} = [num2str(measFreqs(i)) ' [MHz]\nError: ' num2str(freqErr(i)) '%%'];
    errMark{i} = sprintf(errMark{i});
end
