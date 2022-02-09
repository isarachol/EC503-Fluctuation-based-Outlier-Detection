scatter(test(:,1),test(:,2));
demo=load('Label_breastw.txt');
[value,index]=find(demo~=0);
[m,n]=size(value);
for i=1:m
    scatter(test(value(i,:),1),test(value(i,:),2),75,'g','d');
    hold on
end