clc;clear
load data.mat
DataX = Data(:,10)
DataY=Data(:,15)
DataAll=[DataX,DataY]
indices = crossvalind('Kfold', 84, 2);%将数据样本随机分割为3部分
S=[];p=[]
for i = 1:2 %循环3次，分别取出第i部分作为测试样本，其余两部分作为训练样本
    test = (indices == i);
    train = ~test;
    trainData = DataAll(train, :);
    testData = DataAll(test, :);
    n=ones(length(trainData(:,1)))
     
   b=regress(trainData(:,2),[n(:,1),trainData(:,1)])
    Yestimate(:,i)=b(1)+b(2)*testData(:,1)
    YActual(:,i)=testData(:,2)
    n2=ones(length(YActual(:,1)))
     [b2,bint,r,rint,stats]=regress(Yestimate(:,i),[n2(:,1),YActual(:,i)])
     p(:,i)=stats(1,3)
end
[RHO,PVAL] = corr(Yestimate,YActual)
 
