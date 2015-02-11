% --------------------------------------------------------------------
%%  Returns a linear interploated signal with a desired sample length
%   from an input signal and a given index for the input signal.
%   Therefore the input sample indeces can be unequally distributed and redundant.
%
%   INPUT
%         input   : input signal or datapoint vector  
%         index   : indeces of the respective input
%         N       : length of output in samples
%
%   OUTPUT
%         output  : output signal or datapoint vector
%         index   : indeces of the respective output
%
% --------------------------------------------------
% [output, index] = smc_interpolation(input,index,N)
% --------------------------------------------------
%
% An example could be:
% .------------------.
% input = [1 3 34 -6 7 -8];
% index = [2 5 53  8 3 53];
% [output, index2] = smc_interpolation(input,index,N)
% figure; stem(index,input);
% figure; stem(index2,output);
% --------------------------------------------------
function [output, index] = smc_interpolation(input,index,N)
    input=input(:)';
    index=index(:)';
    if max(index)>N; fprintf('\nYour input has index values larger than desired length of output.\n smc_interpolation() is now stopped\n'); return; end;
    
    % MEAN the duplicate VALUES 
    % and delete redundant duplicates afterwards
    u = unique(index);
    valueAppearances = histc(index,u);
    numberOfDuplicates = sum(valueAppearances>1);
    duplicateIDs = u(valueAppearances>1);
    for i=1:numberOfDuplicates
       duplicateIndex{i} = find(index==duplicateIDs(i));
       input = [input sum(input(duplicateIndex{i}))/sum(index==duplicateIDs(i))];
       index = [index duplicateIDs(i)];
    end
    if numberOfDuplicates > 0;
      index([duplicateIndex{:}]) = [];
      input([duplicateIndex{:}]) = [];
    end
    % sort the input according to the given index vector
    [index, sortOrder] = sort(index);
    input = input(sortOrder);
    
    % assume first and last value is 0
    if min(index)~=1, input = [0 input]; index = [1 index]; end;
    if max(index)~=N, input = [input 0]; index = [index N]; end;
    
    % find two first dx and dy values.
    i=1;
    while length(input) < N
        x1 = index(i);  
        x2 = index(i+1);
        y1 = input(i); 
        y2 = input(i+1);
        % calculate difference in x and y space 
        dx = x2-x1; dy = y2-y1;
        if dx > 1
            numberOfInputPoints = dx-1;
            input = [input(1:x1) dy/dx*[1:numberOfInputPoints]+input(x1) input(x1+1:end)];
            index = [index(1:x1) x1+1:x2-1 index(x1+1:end)];
        end
        i=i+1;
    end
output = input;
end
