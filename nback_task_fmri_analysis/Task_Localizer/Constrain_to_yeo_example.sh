#L/R ROI of DLPFC
module load connectome-workbench
#RIGHT
#Large circle in DLPFC on average surface
wb_command -surface-geodesic-rois /scratch/colin/epitome/hcp2/cvs_avg35_inMNI152/MNINonLinear/fsaverage_LR32k/cvs_avg35_inMNI152.R.midthickness.32k_fs_LR.surf.gii 45 DLPFC_R_Vertex.txt DLPFC_R.func.gii
#Create ROI of FPN areas
wb_command -cifti-label-to-roi /projects/colin/SPINS_hcp/rs_maps/fsaverage.Yeo2011_7Networks_N1000.32k_fs_LR.dlabel.nii FPN_ROI.dscalar.nii -name R_7Networks_6
#Separate to gifti
wb_command -cifti-separate FPN_ROI.dscalar.nii COLUMN -metric CORTEX_RIGHT FPN_R.func.gii
#Multiply with large DLPFC
wb_command -metric-math a*b DLPFC_R_ROI_1.func.gii -var a FPN_R.func.gii -var b DLPFC_R.func.gii

#Small DLPFC circle
wb_command -surface-geodesic-rois /scratch/colin/epitome/hcp2/cvs_avg35_inMNI152/MNINonLinear/fsaverage_LR32k/cvs_avg35_inMNI152.R.midthickness.32k_fs_LR.surf.gii 30 DLPFC_R_Vertex.txt DLPFC_R.func.gii
#Create ROI of Salience areas
wb_command -cifti-label-to-roi /projects/colin/SPINS_hcp/rs_maps/fsaverage.Yeo2011_7Networks_N1000.32k_fs_LR.dlabel.nii SAL_ROI.dscalar.nii -name R_7Networks_4
#seperate to func.gii
wb_command -cifti-separate SAL_ROI.dscalar.nii COLUMN -metric CORTEX_RIGHT SAL_R.func.gii
#Multiply by small DLPFC
wb_command -metric-math a*b DLPFC_R_ROI_2.func.gii -var a SAL_R.func.gii -var b DLPFC_R.func.gii
#Add small and big ROIs
wb_command -metric-math a+b DLPFC_R_ROI.func.gii -var a DLPFC_R_ROI_1.func.gii -var b DLPFC_R_ROI_2.func.gii -fixnan 0

#create dense template
wb_command -cifti-create-dense-from-template /projects/ttan/ASSD/Data/testing/sub-EF001_ses-01/con_0001.dscalar.nii DLPFC_R_ROI.dscalar.nii -metric CORTEX_RIGHT DLPFC_R_ROI_1.func.gii

#Remove Intermediate Files
rm  DLPFC_R_ROI.func.gii DLPFC_R.func.gii DLPFC_R_ROI_2.func.gii DLPFC_R_ROI_1.func.gii SAL_R.func.gii FPN_R.func.gii

#LEFT
#Large circle in DLPFC on average surface
wb_command -surface-geodesic-rois /scratch/colin/epitome/hcp2/cvs_avg35_inMNI152/MNINonLinear/fsaverage_LR32k/cvs_avg35_inMNI152.L.midthickness.32k_fs_LR.surf.gii 45 DLPFC_L_Vertex.txt DLPFC_L.func.gii
#Create ROI of FPN areas
wb_command -cifti-label-to-roi /projects/colin/SPINS_hcp/rs_maps/fsaverage.Yeo2011_7Networks_N1000.32k_fs_LR.dlabel.nii FPN_ROI.dscalar.nii -name L_7Networks_6
#Separate to gifti
wb_command -cifti-separate FPN_ROI.dscalar.nii COLUMN -metric CORTEX_LEFT FPN_L.func.gii
#Multiply with large DLPFC
wb_command -metric-math a*b DLPFC_L_ROI_1.func.gii -var a FPN_L.func.gii -var b DLPFC_L.func.gii

#Small DLPFC circle
wb_command -surface-geodesic-rois /scratch/colin/epitome/hcp2/cvs_avg35_inMNI152/MNINonLinear/fsaverage_LR32k/cvs_avg35_inMNI152.R.midthickness.32k_fs_LR.surf.gii 30 DLPFC_L_Vertex.txt DLPFC_L.func.gii
#Create ROI of Salience areas
wb_command -cifti-label-to-roi /projects/colin/SPINS_hcp/rs_maps/fsaverage.Yeo2011_7Networks_N1000.32k_fs_LR.dlabel.nii SAL_ROI.dscalar.nii -name L_7Networks_4
#seperate to func.gii
wb_command -cifti-separate SAL_ROI.dscalar.nii COLUMN -metric CORTEX_LEFT SAL_L.func.gii
#Multiply by small DLPFC
wb_command -metric-math a*b DLPFC_L_ROI_2.func.gii -var a SAL_L.func.gii -var b DLPFC_L.func.gii
#Add small and big ROIs
wb_command -metric-math a+b DLPFC_L_ROI.func.gii -var a DLPFC_L_ROI_1.func.gii -var b DLPFC_L_ROI_2.func.gii -fixnan 0
#create dense template
wb_command -cifti-create-dense-from-template /projects/ttan/ASSD/Data/testing/sub-EF001_ses-01/con_0001.dscalar.nii DLPFC_L_ROI.dscalar.nii -metric CORTEX_LEFT DLPFC_L_ROI_1.func.gii

#Remove Intermediate files

rm DLPFC_L_ROI.func.gii DLPFC_L.func.gii SAL_ROI.dscalar.nii FPN_ROI.dscalar.nii DLPFC_L_ROI_2.func.gii DLPFC_L_ROI_1.func.gii SAL_L.func.gii FPN_L.func.gii
