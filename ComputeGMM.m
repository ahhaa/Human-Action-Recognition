function [ quadsFinal ] = ComputeGMM( jointsData )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

global combs;

combs = GenerateCombinations(); % The combinations that will be used
                                % to generate quads

quads = GenerateQuads(jointsData);

disp('Quads Generated');

t1 = isnan(quads);
for i = 1:size(t1, 1)
    for j = 1:size(t1, 2)
        if(t1(i, j) == 1)
            disp('nan found at');
            quads(i, j)
            i
            j
        end
    end
end

quads(t1==1) = 0;
t2 = isinf(quads);
for i = 1:size(t2, 1)
    for j = 1:size(t2, 2)
        if(t2(i, j) == 1)
            disp('inf found at');
            quads(i, j)
            i
            j
        end
    end
end
quads(t2 == 1) = 0;

disp('Done checking for nans and Infs');

quadsFinal = reshape(quads, size(quads, 1) * size(quads, 2), 6);
quadsFinal = quadsFinal';


end

