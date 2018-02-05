% The script assumes that the MSRAction3D dataset is stored in the parent
% folder of the working directory
global combs
cd ..
cd MSRAction3D\
cd MSRAction3DSkeleton(20joints)\
fileList = ls;
% Return to working directory
cd ..\..\Human-Action-Recognition\

AS1 = [2 3 5 6 10 13 18 20]; % Action Set 1
totalTrainData = zeros(4, 1000000);
startIndex = 1;
for i = 1:size(fileList, 2)
    k = fileList(i, 3);
    if(ismember(k, AS1))        
        [fileLenth, temp] = readFile2(fileList(i, :));
        totalTrainData(:, startIndex:fileLength) = temp;
        startIndex = startIndex + fileLength; 
    end
end

totalTrainData(:, startIndex:1000000) = [];

[means, covariances, priors] = ComputeGMM(totalTrainData);

FV = zeros(300, 9216);
cnt = 1;
labels = zeros(1, 300);
for i = 1:size(fileList, 2)
    k = fileList(i, 2:3); % Action number
    aNum = 10 * int16(k(1)-48) + int16(k(2)-48);
    k2 = fileList(i, 6:7); % Subject number
    sNum = 10 * int16(k2(1)-48) + int16(k2(2)-48);
    if(ismember(aNum, AS1) && rem(sNum, 2) ~= 0 )
        FV(cnt, :) = ComputeFisherVector(fileList(i, :), means, covariances, priors);
        labels(cnt) = aNum;
        cnt = cnt + 1;        
    end
end

FV(cn

FV(1, :) = ComputeFisherVector(fileList(5, :), means, covariances, priors);
FV(2, :) = ComputeFisherVector(fileList(6, :), means, covariances, priors);
labels = [1 2]';
model = svmtrain(labels, FV, ''); % Using svmtrain from LIBSVM package

FVTest(1, :) = ComputeFisherVector(fileList(7, :), means, covariances, priors);
FVTest(2, :) = ComputeFisherVector(fileList(8, :), means, covariances, priors);
TestLabels = [1 2]';
[ predicted_label, accuracy, prob_estimates ] = ComputeAccuracy( FVTest, TestLabels, model );
accuracy