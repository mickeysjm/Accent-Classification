%Read Audio Data from foler
function data = readSegData(folder, type,suffix,N)
    %folder = 'grid_mandarin/';
    %suffix = '.csv';
    %type = 'mandarin';
    
    %create cell array for storing data
    data = cell(N,1);
    for i = 1:N
        filename = strcat(folder,type,int2str(i),suffix);
        data{i} = load(filename);
        % You can also use the following line to obtain the sampling rate
        % However, in our dataset, the default rate is the small
        %[y,Fs] = audioread(filename);
    end
end

