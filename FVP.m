% Perform FVP (FeatureValuePropagation) and Find Outliers Factors
function [value_outlier,index_outlier, OF] = FVP(X,GraphNumber, graph_file)
    [~,n]=size(X); %m = dimensions, n = number of points
    %% Fluctuations
    fluction = zeros(n, GraphNumber);
    for i=1:GraphNumber
        fileName = [graph_file num2str(i)  '.txt']; % result from GG_RandomLink.m
        A=load(fileName); 
        %tic measure in demo instead
        Z=X*A; % get some features from X based on the random Link
        test=sum(X); % 1 x m = all features combined to one
        test_demo=sum(Z); % all features of k neighbors and xi combined to one
        fluction(:,i)=(test./test_demo)'; % sum(xi) / sum(xi + neighbors)
    end
    ChangeRate=sum(fluction,2); % sum of fluctuations from different graph generations (1 x m)
    
    %% Outlier Factors
    OF = zeros(n,1);
    for ii=1:n % for each data point
        Nk=find(A(:,ii)~=0); % k+1 values of a point and neighbors
        OF(ii,:)=sum(abs(ChangeRate(ii,:)-ChangeRate(Nk,:))); % sum of (fluc xi - flux neighbors)
    end
    %toc measure in demo instead
    
    [value_outlier,index_outlier]=sort(OF); % default ascending
end

