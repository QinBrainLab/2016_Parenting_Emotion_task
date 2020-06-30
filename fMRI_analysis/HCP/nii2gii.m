% Adapted by Bingsen for windows system @2018-8-31

% written by hao (2017/09/23)
% rock3.hao@gmail.com
% qinlab.BNU
clear;
clc;

%% Set up
msk_dir = 'D:\Project\Analysis\Age_group_onesampleT\Workbench\ValueNotMask';  
% Workbench and Atlas
bin_dir = 'D:\Imaging_Toolbox\Down_Toolbox\workbench\bin_windows64';
tsf_dir = 'D:\Imaging_Toolbox\Down_Toolbox\workbench_atlas\32k_ConteAtlas_v2';
% Tranform Surface File
tsf_L = fullfile(tsf_dir, 'Conte69.L.midthickness.32k_fs_LR.surf.gii');
tsf_R = fullfile(tsf_dir, 'Conte69.R.midthickness.32k_fs_LR.surf.gii');

%% Convert .nii to .shape.gii
% When convert ROI and the resulting surface image have strange shading
% around the edges of the ROIs. Use "-enclosing" instead of "-trilinear"
nii_list = dir(fullfile(msk_dir,'*.nii'));
for i = 1: length(nii_list)
    nii_file = fullfile(msk_dir, nii_list(i).name);
    system(cat(2,bin_dir,'\wb_command -volume-to-surface-mapping ',nii_file,' ',tsf_L,...
        ' ',fullfile(msk_dir,[nii_list(i).name(1:end-4),'L.shape.gii ']),'-trilinear'));
    system(cat(2,bin_dir,'\wb_command -volume-to-surface-mapping ',nii_file,' ',tsf_R,...
        ' ',fullfile(msk_dir,[nii_list(i).name(1:end-4),'R.shape.gii ']),'-trilinear'));
end
disp('=== Convert Done ===');
