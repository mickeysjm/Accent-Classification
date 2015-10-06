%% SVM Model
% For each segment I train a SVM model 
PredictLabel = zeros(67,N_seg);
Accuracy = zeros(1,N_seg);
DecValues = zeros(67,N_seg);
for k = 1:N_seg
    option = strcat({'-c '},{num2str(para(k,2))},{'-g '},{num2str(para(k,3))});
    disp(option)
    Y_training = TrainingLabels{1,k};
    X_training = TrainingFeatures{1,k};
    Y_testing = TestingLabels{1,k};
    X_testing = TestingFeatures{1,k};
    model = svmtrain(Y_training, sparse(X_training), option);
    [PredictLabel(:,k), Accuracy(1,k), DecValues(:,k)] = svmpredict(Y_testing, X_testing, model);
end