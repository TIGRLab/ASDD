#!/bin/bash

module load python/3.6_ciftify_01
module load connectome-workbench

#Create ROI
ciftify_surface_rois DLPFC_left.csv 5 /scratch/colin/epitome/hcp2/cvs_avg35_inMNI152/MNINonLinear/fsaverage_LR32k/cvs_avg35_inMNI152.L.midthickness.32k_fs_LR.surf.gii /scratch/colin/epitome/hcp2/cvs_avg35_inMNI152/MNINonLinear/fsaverage_LR32k/cvs_avg35_inMNI152.R.midthickness.32k_fs_LR.surf.gii DLPFC_left.dscalar.nii

ciftify_surface_rois PCC_left.csv 5 /scratch/colin/epitome/hcp2/cvs_avg35_inMNI152/MNINonLinear/fsaverage_LR32k/cvs_avg35_inMNI152.L.midthickness.32k_fs_LR.surf.gii /scratch/colin/epitome/hcp2/cvs_avg35_inMNI152/MNINonLinear/fsaverage_LR32k/cvs_avg35_inMNI152.R.midthickness.32k_fs_LR.surf.gii PCC_left.dscalar.nii


#Convert to Nifti

wb_command -cifti-convert -to-nifti DLPFC_right.dscalar.nii DLPFC_right.nii
wb_command -cifti-convert -to-nifti DLPFC_left.dscalar.nii DLPFC_left.nii
wb_command -cifti-convert -to-nifti PCC_right.dscalar.nii PCC_right.nii
wb_command -cifti-convert -to-nifti PCC_left.dscalar.nii PCC_left.nii
