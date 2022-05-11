function [outputArg1,outputArg2] = GG_RandomLink(X,GraphNumber,k,wm)
[m,n]=size(X);
A=zeros(m,m);

for iteration=1:GraphNumber
    clear A;
for i=1:m
    for j=1:m
        if j==i
            A(i,j) = 1;
        end
    end
end
for i=1:m
        notEqualNumber=i;
        randomNumber=randperm(m,k);
        while(find(randomNumber==i))
            randomNumber=randperm(m,k);
        end
        for j=1:k
            A(i,randomNumber(:,j))=1;
        end
end
wm = sprintf('A_test_SuiJiLink_%d.txt',iteration);
filename = ['D:\matlab2019a\matlab files\FVP\Tabular Outlier Detection\Graph\',wm];
dlmwrite(filename,A','delimiter',' ');	
end
end

