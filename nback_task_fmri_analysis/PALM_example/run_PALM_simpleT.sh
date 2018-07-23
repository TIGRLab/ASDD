#!/bin/sh

# HCP_DATA is a global variable,
# eg: export HCP_DATA='/scratch/colin/MST_open/hcp/'
module load matlab
module load palm/alpha102
module load connectome-workbench
# assign the variable curdir for current directory
curdir=${PWD}

#sublistids is in the format of "studyod_site_number_visitNum", eg: MST_open_MST036_SESS01/
#users should input the directory of sublistids and filename
sublistids=$1
filename=$2
outdir=$3

#echo $sublistids
HCP_DATA=/scratch/mmanogaran/fmriprep/roi_ASDD_out/ciftify_ses/

infile=allsubs_merged.dscalar.nii
fname=merge_split
#extracting the first element of sublistids file
exampleSubid=$(head -n 1 ${sublistids})
#first Instance of sublistids file
surfL=${HCP_DATA}/sub-${exampleSubid}_ses-01/MNINonLinear/fsaverage_LR32k/sub-${exampleSubid}_ses-01.L.midthickness.32k_fs_LR.surf.gii
surfR=${HCP_DATA}/sub-${exampleSubid}_ses-01/MNINonLinear/fsaverage_LR32k/sub-${exampleSubid}_ses-01.R.midthickness.32k_fs_LR.surf.gii


#outdier is the place where users want to save results in
cd ${outdir}

#stage 1 merge files (do a while loop reading a text file with a lsit of cifti files
args=""
while read ff
do
    args="${args} -cifti $ff"
done < ${filename} #users need to specify the full path for filename file
echo $args

# allsubs_merged.dscalar.nii is the file that PALM will use
wb_command -cifti-merge ${infile} ${args}
#stage 2 separate cifti into gifti

wb_command -cifti-separate $infile COLUMN -volume-all ${fname}_sub.nii -metric CORTEX_LEFT ${fname}_L.func.gii -metric CORTEX_RIGHT ${fname}_R.func.gii
wb_command -gifti-convert BASE64_BINARY ${fname}_L.func.gii ${fname}_L.func.gii
wb_command -gifti-convert BASE64_BINARY ${fname}_R.func.gii ${fname}_R.func.gii

#stage 3 Calculate mean surface
MERGELIST=""
while read subids; do
  dir=${HCP_DATA}/sub-${subids}_ses-01
  MERGELIST="${MERGELIST} -metric $dir/MNINonLinear/fsaverage_LR32k/sub-${subids}_ses-01.L.midthickness.32k_fs_LR.shape.gii";
done < ${sublistids}

#wb_command will automatically save results in the current dir, which is outdir
wb_command -metric-merge L_midthick_va.func.gii ${MERGELIST}
wb_command -metric-reduce L_midthick_va.func.gii MEAN L_area.func.gii

MERGELIST=""
while read subids; do
  dir=${HCP_DATA}/sub-${subids}_ses-01
  MERGELIST="${MERGELIST} -metric $dir/MNINonLinear/fsaverage_LR32k/sub-${subids}_ses-01.R.midthickness.32k_fs_LR.shape.gii";
done < ${sublistids}

wb_command -metric-merge R_midthick_va.func.gii ${MERGELIST}
wb_command -metric-reduce R_midthick_va.func.gii MEAN R_area.func.gii


#stage 4: RUN PALM
palm -i ${fname}_L.func.gii -o results_L_cort -T -tfce2D -s $surfL L_area.func.gii -logp -n 1000
palm -i ${fname}_R.func.gii  -o results_R_cort -T -tfce2D -s $surfR R_area.func.gii -logp -n 1000
palm -i ${fname}_sub.nii  -o results_sub -T -logp -n 1000

wb_command -cifti-create-dense-from-template ${infile} results_cort_tfce_tstat_fwep_c1.dscalar.nii -volume-all results_sub_tfce_tstat_fwep_c1.nii -metric CORTEX_LEFT results_L_cort_tfce_tstat_fwep_c1.gii -metric CORTEX_RIGHT results_R_cort_tfce_tstat_fwep_c1.gii
wb_command -cifti-create-dense-from-template ${infile} results_cort_tfce_tstat_fwep_c2.dscalar.nii  -volume-all results_sub_tfce_tstat_fwep_c2.nii -metric CORTEX_LEFT results_L_cort_tfce_tstat_fwep_c2.gii -metric CORTEX_RIGHT results_R_cort_tfce_tstat_fwep_c2.gii

wb_command -cifti-math '(x-y)' ${fname}_tstat_fwep_c12.dscalar.nii -var x results_cort_tfce_tstat_fwep_c1.dscalar.nii -var y results_cort_tfce_tstat_fwep_c2.dscalar.nii

#back to the previous directory
cd ${curdir}
