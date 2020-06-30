% Written by Lei Hao
% haolpsy@gmail.com
% 2017/07/11
clear
clc;
%% ------------------------------ Set Up ------------------------------- %%
% Set Path
SPM_Dir    = '/home/xujiahua/toolbox/SPM/spm12';
Script_Dir = 'C:\Users\X\Desktop\Code\FirstLevel\FirstLv_spm12new';

% Basic Configure
YourName   = 'Xu';
RunNumber  = 1;
SubList    = fullfile (Script_Dir,'test.txt');
DataImgDir = 'E：\Data\PreProcessed';

% Individual Activity Statistics
IndiStatsTask = 'EM';
SessList      = 'EM'; % Single Run: 'Run'; Multiple Run: 'Run1'',''Run2'',''Run3'.
IndiStatsDir  = 'D:\BaiduNetdiskDownload\FirstLv';
ContrastDir   = 'C:\Users\X\Desktop\Code\FirstLevel\FirstLv_spm12new\Contrast\contrast_EM_XJH.mat';
TaskDsgnName  = 'taskdesign_pm.m';

%% The following do not need to be modified
%% ------------------------ Individual Analysis ------------------------ %%
% addpath (genpath (SPM_Dir));
% addpath (genpath (Script_Dir));

cd (Script_Dir)
if ~exist('Res_Log','dir')
    mkdir (fullfile(Script_Dir,'Res_Log'))
end

iConfigName = ['Config_Indistats_',IndiStatsTask,'_',YourName,'.m'];
iConfig     = fopen(iConfigName,'a');
fprintf (iConfig,'%s\n',['paralist.YourName = ''',YourName,''';']);
fprintf (iConfig,'%s\n','paralist.data_type = ''nii'';');
fprintf (iConfig,'%s\n','paralist.pipeline = ''swcar'';');
fprintf (iConfig,'%s\n',['paralist.server_path = ''',DataImgDir,''';']);
fprintf (iConfig,'%s\n',['paralist.stats_path = ''',IndiStatsDir,''';']);
fprintf (iConfig,'%s\n','paralist.parent_folder = '''';');
fprintf (iConfig,'%s\n',['fid = fopen(''',SubList,''');']);
fprintf (iConfig,'%s\n','SubLists = {};');
fprintf (iConfig,'%s\n','Cnt_List = 1;');
fprintf (iConfig,'%s\n','while ~feof(fid)');
fprintf (iConfig,'%s\n','    linedata = textscan(fgetl(fid), ''%s'', ''Delimiter'', ''\t'');');
fprintf (iConfig,'%s\n','    SubLists(Cnt_List,:) = linedata{1}; %#ok<*SAGROW>');
fprintf (iConfig,'%s\n','    Cnt_List = Cnt_List + 1;');
fprintf (iConfig,'%s\n','end');
fprintf (iConfig,'%s\n','fclose(fid);');
fprintf (iConfig,'%s\n','paralist.subjectlist = SubLists;');
if RunNumber == 1
    fprintf (iConfig,'%s\n',['paralist.exp_sesslist = ''',SessList,''';']);
end
if RunNumber > 1
    fprintf (iConfig,'%s\n',['paralist.exp_sesslist = {''',SessList,'''};']);
end
fprintf (iConfig,'%s\n',['paralist.task_dsgn = ''',TaskDsgnName,''';']);
fprintf (iConfig,'%s\n',['paralist.contrastmat = ''',ContrastDir,''';']);
fprintf (iConfig,'%s\n','paralist.preprocessed_folder = ''smoothed_spm12'';');
fprintf (iConfig,'%s\n',['paralist.stats_folder = ''',IndiStatsTask,'/stats_spm12_swcar'';']);
fprintf (iConfig,'%s\n','paralist.include_mvmnt = 1;');
fprintf (iConfig,'%s\n','paralist.include_volrepair = 0;');
fprintf (iConfig,'%s\n','paralist.volpipeline = ''swavr'';');
fprintf (iConfig,'%s\n','paralist.volrepaired_folder = ''volrepair_spm12'';');
fprintf (iConfig,'%s\n','paralist.repaired_stats = ''stats_spm12_VolRepair'';');
fprintf (iConfig,'%s\n',['paralist.template_path = ''',fullfile(Script_Dir,'Dependence'),''';']);

IndiviStats_Hao_spm12 (iConfigName)

cd (Script_Dir)
% movefile (iConfigName,fullfile(Script_Dir,'Res_Log'))
% movefile ('Log*',fullfile(Script_Dir,'Res_Log'))

%% All Done
clear
disp ('All Done');