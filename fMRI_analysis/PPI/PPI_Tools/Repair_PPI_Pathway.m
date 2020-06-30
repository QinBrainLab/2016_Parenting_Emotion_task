clc;
clear;
%% Xujiahua 2019/07/25%%%
%% Fix SPM.xY and swd pathway%
%% Any Problems xujiahuapsy@gmail.com
%% data structure 
% Program
%    |____PreProcessing
%    |           |_______year(2017,etc)
%    |                      |_____17-11-01.1math(examples)
%    |                                    |____fmri
%    |                                           |_____task(run)
%    |                                                   |______smoothed_spm12
%    |                                                   |______task_design
%    |                                                   |______unnormalized          
%    |____Firstlevel
%            |_______year(2017,etc)
%    |                      |_____17-11-01.1math(examples)
%    |                                    |____stats_spm12
%    |                                           |_____task(run)
%    |                                                   |______stats_spm12_swcar
workdir='C:\Users\xujiahua\Desktop\gPPI' 
OldPre='/brain/ZHAOLAB/home/YaoYaxin/2fmri_arithrhythm'
prep='C:\Users\xujiahua\Desktop\gPPI\Zhao\preprocessing'
firstlevel='C:\Users\xujiahua\Desktop\gPPI\Zhao\Firstlevel'
subjlist=[workdir filesep 'sublist_zhao.txt']
fid = fopen (subjlist); Subjects = {}; cnt = 1;
while ~feof (fid)
    linedata = textscan (fgetl (fid), '%s', 'Delimiter', '\t');
    Subjects (cnt, :) = linedata {1}; cnt = cnt+1; %#ok<*SAGROW>
end
fclose (fid);

for ii=1:length(Subjects)
  % year = ['20', Subjects{ii}(1:2)];
   cd ([firstlevel filesep Subjects{ii}] )
   copyfile('SPM.mat','SPMold.mat')
  % EPIrun1 = spm_select('ExtFPList',  fullfile(prep, year,Subjects{ii},'fmri','run1','smoothed_spm12'), ['^swca' '.*\.nii$'], Inf); 
   %EPIrun1U=cellstr(EPIrun1);  
   spm_changepath('SPM.mat', [OldPre  '/preprocessingData/'  Subjects{ii}  '/run2'], [prep filesep Subjects{ii} filesep 'run2' ])
   %spm_changepath('SPM.mat', [OldPre filesep year filesep Subjects{ii} filesep 'fmri' filesep 'run2' filesep 'smoothed_spm12'], [prep filesep year filesep Subjects{ii} filesep 'fmri' filesep 'run2' filesep 'smoothed_spm12']);
   %spm_changepath('SPM.mat', [OldPre filesep year filesep Subjects{ii} filesep 'fmri' filesep 'run3' filesep 'smoothed_spm12'], [prep filesep year filesep Subjects{ii} filesep 'fmri' filesep 'run3' filesep 'smoothed_spm12']);
   load ('SPM.mat' )
   SPM.swd=pwd
   %SPM.SPMid='SPM5: spm_spm (v$Rev: 946 $)'
   save('SPM.mat','SPM')
   clear SPM 
end
