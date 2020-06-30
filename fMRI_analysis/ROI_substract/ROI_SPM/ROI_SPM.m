clear;clc;
roi_dir='D:\CBD_EM\Activation\SecondLv\Analysis\Adult_onesampleT_Mask\originMask\';
cd(roi_dir);
roi_files=dir('*.nii');
roi={roi_files.name}';
data_dir='D:\CBD_EM\Activation\SecondLv\Adult\Adult\All_Adult\';
cd(data_dir);
data_files=dir('*.nii');
data_files={data_files.name}';

roi_data_allValues=cell(1);
for i=1:length(roi)
    roi_index=spm_vol_nifti([roi_dir,roi{i,1}]);
    roi_index=spm_read_vols(roi_index);
    
    for j=1:length(data_files)
    data_temp=spm_vol_nifti([data_dir,data_files{j,1}]);
    data_temp=spm_read_vols(data_temp);
    data=data_temp(find(roi_index==1));
    
    roi_data_allValues{i}(j,:)=data';
    roi_data_meanValues(j,i)=nanmean(data);
    end
end
cd(roi_dir)
    save    All_Adult_roi.mat     data_files   roi_data_allValues roi_data_meanValues roi
