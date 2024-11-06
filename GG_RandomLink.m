% Find Nk
function [outputArg1,outputArg2] = GG_RandomLink(X,GraphNumber,k,wm)
[m,n]=size(X); %m = number of points, n = dimensions
A=zeros(m,m);

for iteration=1:GraphNumber % GraphNumber of Nk's
    clear A;
    for i=1:m % Diagonal = 1
        for j=1:m
            if j==i
                A(i,j) = 1;
            end
        end
    end
    for i=1:m
            notEqualNumber=i;
            randomNumber=randperm(m,k);
            while(find(randomNumber==i)) % make sure xi is not in Nk
                randomNumber=randperm(m,k);
            end % get Nk
            for j=1:k
                A(i,randomNumber(:,j))=1; % Neighbors of xi
            end
    end
    wm = sprintf('A_test_SuiJiLink_%d.txt',iteration);
    filename = ['C:\Users\tandi\OneDrive\Desktop\Classes\2024 Fall\EC 503 A1 B1(recite)\Project\Graph\',wm];
    dlmwrite(filename,A','delimiter',' ');	
end
end

