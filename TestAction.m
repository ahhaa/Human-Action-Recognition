function [ predicted_label, accuracy, prob_estimates ] = TestAction( fileName, means, covariances, priors, model )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
fileID = fopen(fileName,'r');
formatSpec = '%f %f %f %f';
sizeA = [4 Inf];
A = fscanf(fileID,formatSpec,sizeA);

A = A';
l = size(A, 1);
B=reshape(A,20,l/20,4);


tempComp = [0 0 0 0];

combs = zeros(4845, 4);

cnt = 1;


for i=1:17
    tempComp(1) = i;
    for j=i+1:18
        tempComp(2) = j;
        for k=j+1:19
            tempComp(3) = k;
            for m=k+1:20
                tempComp(4) = m;
                for n=1:4
                    combs(cnt, n) = tempComp(n);
                end
                cnt = cnt+1;
            end
        end
    end
end


tempQuad = zeros(4, 3);
quads = zeros(size(B, 2), size(combs, 1), 6);
for i = 1:size(B, 2)
    for j = 1:size(combs, 1)
        for k = 1:4
            for m = 1:3
                tempQuad(k, m) = B(combs(j, k), i, m);
                quads(i, j, 1:6) = skeletalQuad(tempQuad');
            end
        end
    end
end

quadsFinal = reshape(quads, size(quads, 1) * size(quads, 2), 6);
quadsFinal = quadsFinal';

length = size(quadsFinal, 1);

fisherEncoding(1, :) = vl_fisher(quadsFinal(1:6, 1:length/3), means, covariances, priors, 'improved');
fisherEncoding(2, :) = vl_fisher(quadsFinal(1:6, length/3+1:2*length/3), means, covariances, priors, 'improved');
fisherEncoding(3, :) = vl_fisher(quadsFinal(1:6, 2*length/3+1:length), means, covariances, priors, 'improved');

fisherEncoding(4, :) = vl_fisher(quadsFinal(1:6, 1:length/2), means, covariances, priors, 'improved');
fisherEncoding(5, :) = vl_fisher(quadsFinal(1:6, length/2+1:length), means, covariances, priors, 'improved');

fisherEncoding(6, :) = vl_fisher(quadsFinal(1:6, 1:length), means, covariances, priors, 'improved');

for i = 1:6
    for j = 1:size(fisherEncoding, 2)
        fisherEncoding(i, j) = sign(fisherEncoding(i, j)) * (abs(fisherEncoding(i, j)) ^ 0.3);
    end        
end

actual = [-1, -1, -1, -1, -1, -1];
actual = actual';
[predicted_label, accuracy, prob_estimates] = svmpredict(actual, fisherEncoding, model, '-b 1');

end

