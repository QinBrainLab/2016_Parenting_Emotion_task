clear;clc;
rawpath='/mnt/hgfs/Share/FTB';%原始数据解压后数据的路径
cd(rawpath);
files=dir('20*');%解压后文档名字开头相同的部分，BNU是按时间的，比如20
filenames={files.name};
 for i=filenames(1,[1:7])%总共多少个被试，或多少个文件夹
 name=char(i{:})
 name2=name(1:17)
     outpath=strcat('//mnt/hgfs/Share/FTB/Nii/',name2);%把IMA转为Nii文档的路径
     mkdir(outpath)
     unix(sprintf('dcm2nii -n -g -o %s %s',outpath,i{:})); 
 end
