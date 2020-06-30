%-----------------------------------------------------------------------
% Job saved on 14-Jan-2019 14:55:56 by cfg_util (rev $Rev: 6942 $)
% spm SPM - SPM12 (7219)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
clc;
clear;
roi_dir   ='D:\CBD_EM\Activation\SecondLv\Analysis\Adult_onesampleT_Mask\NeuroOverlapWithChildren';
Neurosynthdir='D:\CBD_EM\Activation\SecondLv\Analysis\Adult_onesampleT_Mask\Mask'
roilist = dir(fullfile(roi_dir,'*.nii'));
roilist = struct2cell(roilist);
roilist = roilist(1,:)';

Neurosynthlist = struct2cell(dir(fullfile(Neurosynthdir,'*.nii')));
Neurosynthlist  = Neurosynthlist (1,:)';
for ii=1
    for kk=1:8
        Input1=strcat(roi_dir,'\',roilist{ii,1},',1')
        Input2=strcat(Neurosynthdir,'\',Neurosynthlist{kk,1},',1')
        Name3=strcat((roilist{ii,1}(1:length(roilist{ii,1})-4)),'_',(Neurosynthlist{kk,1}(1:length(Neurosynthlist{kk,1})-4)))
matlabbatch{1}.spm.util.imcalc.input = {
                                        Input1;Input2
                                        };
matlabbatch{1}.spm.util.imcalc.output = Name3;
matlabbatch{1}.spm.util.imcalc.outdir = {'D:\CBD_EM\Activation\SecondLv\Analysis\Adult_onesampleT_Mask\NeuroOverlapWithChildren'};
matlabbatch{1}.spm.util.imcalc.expression = 'i1.*i2';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 16;
    spm_jobman('initcfg')
spm('defaults', 'FMRI');
spm_jobman('serial', matlabbatch, '',cell(0, 1));
clear matlabbatch
    end
end
% spm_jobman('initcfg')
% spm('defaults', 'FMRI');
% spm_jobman('serial', matlabbatch, '',cell(0, 1));
% clear matlabbatch
