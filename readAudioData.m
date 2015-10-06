%Read Audio Data and Sample Rate from foler
function [data,fs] = readAudioData(folder, type,suffix,N)
    %folder = 'Mandarin/';
    %suffix = '.wav';
    %type = 'english';
    
    %create cell array for storing data
    data = cell(N,1);
    fs = zeros(N,1);
    for i = 1:N
        filename = strcat(folder,type,int2str(i),suffix);
        [data{i},fs(i)] = audioread(filename);
        % You can also use the following line to obtain the sampling rate
        % However, in our dataset, the default rate is the small
        %[y,Fs] = audioread(filename);
    end
end

