clear;clc;
load('/mnt/hgfs/Share/FTB/database_ftb_last15.mat');%需要制作一个mat文档，cell类型。一共两列，第一列是dicom2nii后的名字，第二列是类似于17-12-16.1的名字。
rawpath='/mnt/hgfs/Share/FTB/Nii';%上一步生成的文档储存路径
datapath='/home/xujiahua/Preprocessed/';%制作成的数据路径格式
cd(rawpath);
files=dir('Children*');%上一步生成的文档共有名称
filenames={files.name};
   for i=filenames(1,[8])     %总共多少个被试，或多少个文件夹
      cd(i{:});
     for ii=1:length(database(:,1))
      subid(ii)=ismember(database{ii,1},i(1,1))
     end
      file_id=database{subid,2};   
S2path1=strcat(datapath,file_id,'/fmri/RS/unnormalized/');   mkdir(S2path1); 
S2path2=strcat(datapath,file_id,'/fmri/SR/unnormalized/');   mkdir(S2path2); 
S2path3=strcat(datapath,file_id,'/fmri/ANT1/unnormalized/'); mkdir(S2path3); 
S2path4=strcat(datapath,file_id,'/fmri/BART/unnormalized/'); mkdir(S2path4);
S2path5=strcat(datapath,file_id,'/fmri/EM/unnormalized/');   mkdir(S2path5);
S2path6=strcat(datapath,file_id,'/fmri/WM/unnormalized/');   mkdir(S2path6);
S2path7=strcat(datapath,file_id,'/fmri/ANT2/unnormalized/'); mkdir(S2path7);
S2path8=strcat(datapath,file_id,'/fmri/FH/unnormalized/');   mkdir(S2path8); 
S2path9=strcat(datapath,file_id,'/fmri/VN/unnormalized/');   mkdir(S2path9);
     disp('==================================================================');
     fprintf('converting %s',i{:});
 VN='*VN*nii.gz';
    S2outpath9=strcat(S2path9,'I.nii.gz');
    unix(sprintf('fslroi %s %s 1 159',VN,S2outpath9));
 FH='*FH*nii.gz';
    S2outpath8=strcat(S2path8,'I.nii.gz');
    unix(sprintf('fslroi %s %s 4 181',FH,S2outpath8));
 ANT2='*ANT2*nii.gz';
    S2outpath7=strcat(S2path7,'I.nii.gz');
    unix(sprintf('fslroi %s %s 4 173',ANT2,S2outpath7));  
 RS='*rest*nii.gz';
    S2outpath1=strcat(S2path1,'I.nii.gz');
    unix(sprintf('fslroi %s %s 10 170',RS,S2outpath1));   
 SR='*SR*nii.gz';
    S2outpath2=strcat(S2path2,'I.nii.gz');
    unix(sprintf('fslroi %s %s 4 171',SR,S2outpath2));
 ANT1='*ANT1*nii.gz';
    S2outpath3=strcat(S2path3,'I.nii.gz');
    unix(sprintf('fslroi %s %s 4 173',ANT1,S2outpath3));
 BA='*bart*nii.gz';
    S2outpath4=strcat(S2path4,'I.nii.gz');
    unix(sprintf('fslroi %s %s 4 180',BA,S2outpath4));  
EM='*emotion*nii.gz';
    S2outpath5=strcat(S2path5,'I.nii.gz');
    unix(sprintf('fslroi %s %s 4 175',EM,S2outpath5)); 
WM='*WM*nii.gz';
    S2outpath6=strcat(S2path6,'I.nii.gz');
    unix(sprintf('fslroi %s %s 4 228',WM,S2outpath6));    
    S1path1=strcat(datapath,file_id,'/mri/anatomy/');   mkdir(S1path1); 
     disp('==================================================================');
     fprintf('converting %s',i{:});
T1='co*t1*nii.gz';
    S1outpath1=strcat(S1path1,'I.nii.gz');
    unix(sprintf('cp %s %s',T1,S1outpath1));
   cd('../');
  end
