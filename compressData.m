%Input: data: cell array; L: length of output, unit:second
function result = compressData(data,L) %number of samples
    F = 44100; %default sampling rate
    p = L*F;
    N = size(data,1); %# of samples
    
    result = cell(N,1); %per-allocate spaces
    for i = 1:N
        %disp('This is '), i
        q = size(data{i},1);
        result{i} = resample(data{i},p/100,round(q/100));
    end
end