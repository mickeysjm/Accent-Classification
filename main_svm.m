%% add folder and its subfolders to search path 
addpath(genpath('..'));

%% Read In Data
disp('Loading Data')
N_m = 59; % number of mandarin samples
N_e = 100; % number of english samples
N_f = 60; % number of french samples
[data_m,fs_m] = readAudioData('seg/mandarin/','mandarin','.wav',N_m);
[data_e,fs_e] = readAudioData('seg/english/','english','.wav',N_e);
[data_f,fs_f] = readAudioData('seg/french/','french','.wav',N_f);
seg_m = readSegData('seg/grid_mandarin/','mandarin','.csv',N_m);
seg_e = readSegData('seg/grid_english/','english','.csv',N_e);
seg_f = readSegData('seg/grid_french/','french','.csv',N_f);

%% Feature Extraction - Preparation
% Pre-allocate space, assign segment end time, give segment names ...
sid = [1,4,6,8,10,12,15,17,21,24,27,31,35,38,42,45,...
    47,50,52,55,57,59,62,65,66];
segNameCell = {'PleaseCallStella','AskHer','ToBring','TheseThings',...
    'WithHer','FromTheStore','SixSpoons','OfFreshSnowPeas',...
    'FiveThickSlabs','OfBlueCheese','AndMaybeASnack','ForHerBrotherBob',...
    'WeAlsoNeed','ASamllPlasticSnake','AndABig','ToyFrog','ForTheKids',...
    'SheCan','ScoopTheseThings','IntoThree','RedBags','AndWeWill',...
    'GoMeetHer','Wednesday','AtTheTrainStation'...
    };
N_seg = size(sid,2);
sid = [sid, 70]; % for the last segment's end time

features_m_tmp = cell(N_m,N_seg);
features_e_tmp = cell(N_e,N_seg);
features_f_tmp = cell(N_f,N_seg);
min_frame_length = zeros(1,N_seg);
frame_length = zeros(N_m+N_e+N_f,N_seg);
features_m = cell(N_m,N_seg);
features_e = cell(N_e,N_seg);
features_f = cell(N_f,N_seg);

%% Feature Extraction: First Round  
% Using Feature Extractor (MFCC or PLP/RASTA ) to extract original features
% feature_extractor1 <-> PLP/RASTA
% feature_extractor2 <-> MFCC
% As the length of each audio varies, the number of frames will be 
% different, this is a major problem we should deal with in second round.
% Save features in features_m/e/f_tmp cell matrix
% Save each audio's number of frames for each segment in frame_length
% matrix.
N_seg = 25;
disp('First Round');
for k = 1:N_seg % The k-th seg
    disp(strcat(int2str(k), ' Processing: ',segNameCell{k}));
    minFrameLength = 100000; % the minimum frame length of segment k
    for i = 1:N_m
        % start and end time of segment k
        start_time_m = seg_m{i}(sid(k),1);
        end_time_m = seg_m{i}(sid(k+1)-1,2);
        fs = fs_m(i); 
        % audio of segment k
        d_m = data_m{i}(round(start_time_m*fs):round(end_time_m*fs));
        features = feature_extractor2(d_m,fs);
%         [T,features] = evalc('feature_extractor1(d_m,fs);');
        frame_length(i,k) = size(features,2);
        if size(features,2) < minFrameLength
            minFrameLength = size(features,2);
        end
        features_m_tmp{i,k} = features;
    end
    for i = 1:N_e
        % start and end time of segment k
        start_time_e = seg_e{i}(sid(k),1);
        end_time_e = seg_e{i}(sid(k+1)-1,2);
        fs = fs_e(i);
        % audio of segment k
        d_e = data_e{i}(round(start_time_e*fs):round(end_time_e*fs));
        features = feature_extractor2(d_e,fs);
%         [T,features] = evalc('feature_extractor1(d_e,fs);');
        frame_length(i+N_m,k) = size(features,2);
        if size(features,2) < minFrameLength
            minFrameLength = size(features,2);
        end
        features_e_tmp{i,k} = features;
    end
    for i = 1:N_f
        % start and end time of segment k
        start_time_f = seg_f{i}(sid(k),1);
        end_time_f = seg_f{i}(sid(k+1)-1,2);
        fs = fs_f(i);
        % audio of segment k
        d_f = data_f{i}(round(start_time_f*fs):round(end_time_f*fs));
        features = feature_extractor2(d_f,fs);
%         [T,features] = evalc('feature_extractor1(d_f,fs);');
        frame_length(i+N_m+N_e,k) = size(features,2);
        if size(features,2) < minFrameLength
            minFrameLength = size(features,2);
        end
        features_f_tmp{i,k} = features;
    end
    min_frame_length(k) = minFrameLength;
end

%% Feature Extraction: Second Round
% for each audio's each segment, extract F frames
% I believe the start and end frames are really important, so if the
% minimum length of that segment's frames larger than 15, I will select
% the first three frames and last seven frames.
disp('Second Round');
F_length = zeros(1,N_seg);
for k = 1:N_seg
    disp(strcat(int2str(k), ' Processing: ',segNameCell{k}));
    num_of_frame = min_frame_length(k);
    if num_of_frame < 15
        F = num_of_frame; 
    end
    if num_of_frame >= 15 && num_of_frame < 30
        F = 15;
    end
    if num_of_frame >= 30 && num_of_frame < 45
        F = 30;
    end
    if num_of_frame >= 45
        F = 45;
    end
    F_length(k) = F;
    
    for i = 1:N_m
        features = features_m_tmp{i,k};
        numOfFrame = size(features,2);
        if F < 15 % Just extract num_of_frame frames
            selectFrameIndex = sort(randsample(1:numOfFrame,F));
            features_m{i,k} = features(:,selectFrameIndex);
        end
        if F >= 15 % 3 header frames, 7 tail frames, the rest are body frames
            startFrame = features(:,1:3);
            endFrame = features(:,numOfFrame-6:numOfFrame);
            bodyFrameIndex = sort(randsample(4:numOfFrame-7,F-10));
            bodyFrame = features(:,bodyFrameIndex);
            features_m{i,k} = [startFrame, bodyFrame, endFrame];
        end
    end
    
    for i = 1:N_e
        features = features_e_tmp{i,k};
        numOfFrame = size(features,2);
        if F < 15 % Just extract num_of_frame frames
            selectFrameIndex = sort(randsample(1:numOfFrame,F));
            features_e{i,k} = features(:,selectFrameIndex);
        end
        if F >= 15 % 3 header frames, 7 tail frames, the rest are body frames
            startFrame = features(:,1:3);
            endFrame = features(:,numOfFrame-6:numOfFrame);
            bodyFrameIndex = sort(randsample(4:numOfFrame-7,F-10));
            bodyFrame = features(:,bodyFrameIndex);
            features_e{i,k} = [startFrame, bodyFrame, endFrame];
        end
    end
        
    for i = 1:N_f
        features = features_f_tmp{i,k};
        numOfFrame = size(features,2);
        if F < 15 % Just extract num_of_frame frames
            selectFrameIndex = sort(randsample(1:numOfFrame,F));
            features_f{i,k} = features(:,selectFrameIndex);
        end
        if F >= 15 % 3 header frames, 7 tail frames, the rest are body frames
            startFrame = features(:,1:3);
            endFrame = features(:,numOfFrame-6:numOfFrame);
            bodyFrameIndex = sort(randsample(4:numOfFrame-7,F-10));
            bodyFrame = features(:,bodyFrameIndex);
            features_f{i,k} = [startFrame, bodyFrame, endFrame];
        end
    end
end

%% Import the data for External Usage, say Mathematica
save('Mandarin.mat','features_m');
save('English.mat','features_e');
save('French.mat','features_f');

%% Preparation for Model Training
% for each segment, export to files, read grid.py to get the best 
% parameter for svm training
% Pay Attention to the path change
% You should cd into ../libsvm-3.20/matlab directory

% shuffling, THIS IS VERY IMPORTANT!! % 
% shuffle = randsample( 1:(N_m+N_e+N_f), N_m+N_e+N_f );
% Save the shuffle order for reproduce experiment
% save('shuffle.mat','shuffle');
N_seg = 25;
load('shuffle.mat');
% shuffle = shuffle.shuffle;
TrainingFeatures = cell(1,25);
TrainingLabels = cell(1,25);
TestingFeatures = cell(1,25);
TestingLabels = cell(1,25);

N_feature = 39;
for k = 1:N_seg
    X = zeros( N_m + N_e + N_f, N_feature * F_length(k) );
    for i = 1: (N_m + N_e + N_f)
        if i <= N_m
           X(i,:) = reshape(features_m{i,k}',1,N_feature*F_length(k));
        end
        if (i > N_m) && (i <= (N_m + N_e))
           X(i,:) = reshape(features_e{i-N_m,k}', 1, N_feature*F_length(k)); 
        end
        if (i > ( N_m + N_e) ) && ( i <= (N_m + N_e + N_f))
           X(i,:) = reshape(features_f{i-N_m-N_e,k}, 1, N_feature*F_length(k));
        end
    end
    % 1:mandarin, 2:english, 3:french
    Y = [repmat(1,N_m,1);repmat(2,N_e,1);repmat(3,N_f,1)];
    XX = X(shuffle,:);
    
    YY = Y(shuffle,:);
    X_training = XX(1:round( size(X,1) * 0.7 ),:);
    X_testing = XX(round( size(X,1) * 0.7 ):end,:);
    Y_training = YY(1:round( size(Y,1) * 0.7 ));
    Y_testing = YY(round( size(Y,1) * 0.7 ):end);
    
    TrainingFeatures{1,k} = X_training;
    TrainingLabels{1,k} = Y_training;
    TestingFeatures{1,k} = X_testing;
    TestingLabels{1,k} = Y_testing;

    libsvmwrite(int2str(k),Y_training,sparse(X_training));
    libsvmwrite(strcat(int2str(k),'.t'),Y_testing,sparse(X_testing));
end

%% Reading In Paramters
% These parameters are important when deal with SVM model 
% You should run the grid.py and get the parameters.csv first
para = load('parameters.csv');

%% SVM Model for each segment
% For each segment k train a SVM model
% Save the prediction label and accuracy for each segment

PredictLabel = zeros(67,N_seg);
Accuracy = zeros(1,N_seg);

for k = 1:N_seg
    option = char(strcat({'-c '},{num2str(para(k,2))},{' '},{'-g '},{num2str(para(k,3))}));
    disp(strcat(int2str(k),' ',option))
    Y_training = TrainingLabels{1,k};
    X_training = TrainingFeatures{1,k};
    Y_testing = TestingLabels{1,k};
    X_testing = TestingFeatures{1,k};
    model = svmtrain(Y_training, sparse(X_training),option);
    [p,a,d] = svmpredict(Y_testing, X_testing, model);
    PredictLabel(:,k) = p;
    Accuracy(1,k) = a(1);
end

%% Further Decision Based on Each SVM results
%
Count = zeros(67,3);
for i = 1:67
    for c = 1:3
        Count(i,c) = sum(PredictLabel(i,:) == c );
    end
end
trueLabel = TestingLabels{1,1};
[V,predictLabel] = max(Count,[],2);
correct = sum(predictLabel == trueLabel);
all = 67;
totalAccuarcy = correct/all
%% Save Results
save('PredictLabel_MFCC_SVM.mat', 'PredictLabel');
save('Accuracy_MFCC_SVM.mat', 'Accuracy');
save('totalAccuarcy_MFCC_SVM.mat','totalAccuarcy');