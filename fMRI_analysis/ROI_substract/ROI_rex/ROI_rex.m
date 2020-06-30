clear;clc;
roi_dir='C:\Users\xujiahua\Desktop\mask_Hipp_PHG\';
cd(roi_dir);
roi_name=dir('*.nii');
name={roi_name.name}
ind_dir='E:\CBD_EM\Activation\SecondLv\Adult\Adult\All_Adult'
cd(ind_dir);
ind_name=dir('*.nii');
for i=1:length(ind_name) 
    sub=ind_name(i,1).name;
    for j=1:length(roi_name) 
        roi=[roi_dir,roi_name(j,1).name];
        beta(i,j) = rex(sub,roi);
    end
end
id={ind_name.name}'
for kk=1:length(id)
    id2=id{kk,1}
    subs1{kk,1}=id2(1:[length(id2)-4])
end
beta2=num2cell(beta)
Dataall=[subs1,beta2]
cd(roi_dir);
Filename=[roi_dir,'AllAdult_hippo_PHG.csv'];
cell2csv(Filename,Dataall);
