% written by l.hao (ver_18.09.17)
% rock3.hao@gmail.com
% qinlab.BNU
restoredefaultpath
clc
clear
%% Set

resubmask  =0;
img_type   = 'con'; % 'spmT' or 'con'
task_name  = 'EM';
cond_name  = {'Adult'};
rsa_file   = {
  'D:\CBD_EM\Activation\SecondLv\Analysis\All_Adult_onesampleT\con_0001.nii'
%'D:\CBD_EM\Activation\SecondLv\Analysis\All_Adult_onesampleT\spmT_0001.nii'
    };

spm_dir   = 'C:\Imaging_Toolbox\Toolbox\spm12';
roi_dir   ='D:\CBD_EM\Activation\SecondLv\Analysis\Adult_onesampleT_Mask\Mask';
firlv_dir = 'D:\CBD_EM\Activation\Firstlv\Activation_PPI_Data\CBDHC';
subjlist  = 'D:\CBD_EM\Activation\SecondLv\Analysis\Adult_onesampleT_Mask\overlap_mask\CBDHC.txt';

%% RSA correlation
% Read subject list
fid = fopen(subjlist); sublist = {}; cnt_list = 1;
while ~feof(fid)
    linedata = textscan(fgetl(fid), '%s', 'Delimiter', '\t');
    sublist(cnt_list,:) = linedata{1}; cnt_list = cnt_list + 1; %#ok<*SAGROW>
end
fclose(fid);

% Acquire ROIs list
roilist = dir(fullfile(roi_dir,'*.nii'));
roilist = struct2cell(roilist);
roilist = roilist(1,:)';

% Add path
addpath(genpath(spm_dir));

allres = {'Scan_ID'};
for con_i = 1:length(cond_name)
    
    for roi_i = 1:length(roilist)
        allres{1,roi_i+1} = roilist{roi_i,1}(1:end-4);
        roifile = fullfile(roi_dir, roilist{roi_i,1});
        
        mask     = spm_read_vols(spm_vol(roifile));
        rsa_img  = spm_read_vols(spm_vol(rsa_file{con_i,1}));
        rsa_vect = rsa_img(mask(:)==1);
        
         %rsa_vect(isnan(rsa_vect)) = nanmean(rsa_vect);
    
       
        for sub_i = 1:length(sublist)
            allres{sub_i+1,1} = sublist{sub_i,1};
            
            yearID  = ['20',sublist{sub_i,1}(1:2)];
            sub_file = fullfile(firlv_dir, yearID, sublist{sub_i,1},...
                'fmri', 'stats_spm12', task_name, 'stats_spm8_swcar', ...
                [img_type, '_0003','.nii']);%, num2str(con_i), '.nii']);
            
            sub_img = spm_read_vols(spm_vol(sub_file));
%             if resubmask == 1
%                 sub_vect_nan = sub_img(mask(:)==1);
%                 rsa_vect = rsa_vect(~isnan(sub_vect_nan));
%                 
%                 submaskfile = fullfile(firlv_dir, yearID, sublist{sub_i,1},...
%                     'fmri', 'stats_spm12', task_name, 'stats_spm8_swcar', 'mask.nii');
%                 submask = spm_read_vols(spm_vol(submaskfile));
%                 mask = submask & mask;
%             end

            sub_vect = sub_img(mask(:)==1);
%      
tind1=(~isnan(rsa_vect))&(~isnan(sub_vect))
          % tind=(~isnan(rsa_vect)==1)&(~isnan(sub_vect)==1)
           rsa_vect1= rsa_vect(tind1==1)
           sub_vect=sub_vect(tind1==1)
      %     sub_vect(isnan(sub_vect)) = nanmean(sub_vect);
            [rsa_r, rsa_p] = corr(rsa_vect1, sub_vect);
            allres{sub_i+1,roi_i+1} = 0.5*log((1+rsa_r)/(1-rsa_r));
        end
    end
    % save Results
    save_name = ['CBDHC_neurosynth', cond_name{con_i,1}, '_', img_type,'.csv'];
    
    fid = fopen(save_name, 'w');
    [nrows,ncols] = size(allres);
    col_num = '%s';
    for col_i = 1:(ncols-1); col_num = [col_num,',','%s']; end %#ok<*AGROW>
    col_num = [col_num, '\n'];
    for row_i = 1:nrows; fprintf(fid, col_num, allres{row_i,:}); end;
    fclose(fid);
end

%% Done
disp('=== RSA calculate done ===');