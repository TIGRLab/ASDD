#### Code for ASDD

%%% STEPS TO RUN ASDD_nback_GLM-SCRIPT %%%

1.Module load matlab
2.Module load SPM/12
3.In matlab command window: >> spm fmri
4.The output will be in the same folder as the fMRI/*s8.nii
5.You can use this script to generate subs group: /projects/ttan/ASSD/Code/ASDD_GLM_sub_group.m/
6.Then, you can use subj_loop.m in /projects/ttan/ASSD/Code to run GML analysis

%%%%%%%%%%%%%%%%%%%%%END%%%%%%%%%%%%%%%%%%





%%%%%%%                 STEPS TO RUN run_PALM_simpleT.sh SCRIPT                       %%%%%%%%%%

#export HCP_DATA=/scratch/mmanogaran/fmriprep/roi_ASDD_out/ciftify_ses/


%%% Run this loop in terminal to convert the contrast nii file into dscalar to use in HCP %%%

for dir in /projects/ttan/ASSD/Data/testing/*; do
	wb_command -cifti-convert -from-nifti $dir/PPI/PPI_PCC_right/con_0001.nii /projects/colin/ASDD/smooth_activations/sub-EF001_ses-01/con_0001.dscalar.nii $dir/PPI/PPI_PCC_right/con_0001.dscalar.nii;
	wb_command -cifti-convert -from-nifti $dir/PPI/PPI_PCC_right/con_0002.nii /projects/colin/ASDD/smooth_activations/sub-EF001_ses-01/con_0002.dscalar.nii $dir/PPI/PPI_PCC_right/con_0002.dscalar.nii;
	wb_command -cifti-convert -from-nifti $dir/PPI/PPI_PCC_right/con_0003.nii /projects/colin/ASDD/smooth_activations/sub-EF001_ses-01/con_0003.dscalar.nii $dir/PPI/PPI_PCC_right/con_0003.dscalar.nii;

done
	
	wb_command -cifti-convert -from-nifti $dir/con_0002.nii /projects/colin/ASDD/smooth_activations/sub-EF001_ses-01/con_0002.dscalar.nii $dir/con_0002.dscalar.nii;
	wb_command -cifti-convert -from-nifti $dir/con_0003.nii /projects/colin/ASDD/smooth_activations/sub-EF001_ses-01/con_0003.dscalar.nii $dir/con_0003.dscalar.nii;	
done

%%%  Create filelist and sublist for all the subjects based on the fMRI folders  %%%%
for dir in /projects/ttan/ASSD/Data/testing/*; do echo $dir >> filelist.txt; done
%%% /projects/ttan/ASSD/Data/testing/sub-EF001_ses-01 %%%% <--- this filelist.txt contain all the subject paths
for dir in /projects/ttan/ASSD/Data/testing/*; do k=${dir##*sub-}; echo ${k%%_*};
done
%%% EF001 <--- this is the sublist %%%

%%% Create further filelist and sublist of each group (i.e ASD_below8_filelist and sublist). This is what we you to run PALM since this script only run once group in each condition seperately %%%
%%% /projects/ttan/ASSD/Data/testing/sub-EF008_ses-01/con_0003.dscalar.nii %%% <--- this is what it should be in your filelist of each group
%%% Change the con_0001, con_0002, con_0003 depend on which contrast you like to run (i.e con_0001 is for 2back versus 0 back, con_0002 is 0back, con_0003 is N2back) %%%%

IMPORTANT NOTE: DO NOT LEAVE ANY SPACE IN THE SUBLIST AND FILELIST AFTER THE LAST SUBJECT.



%have to make output directory or PALM runs in dir
mkdir $dir/groups
mkdir /projects/ttan/ASSD/PALM/groups/ASD_Above8_2backv0Back

%%% Load this in terminal %%%
module load matlab
module load palm/alpha102
module load connectome-workbench
dir=/projects/ttan/ASSD/Data/PALM/ %%% dir is the path you store your PALM script %%%

${dir}run_PALM_simpleT.sh  ${dir}ASD_above8_sublist.txt  ${dir}above8_filelistPPI.txt ${dir}PPI/Above8/DLPFC_right/2back

${dir}run_PALM_simpleT.sh  ${dir}ASD_below8_sublist.txt  ${dir}below8_filelistPPI.txt ${dir}PPI/Below8/DLPFC_right/0back

${dir}run_PALM_simpleT.sh  ${dir}HC_sublist.txt  ${dir}HC_filelistPPI.txt ${dir}PPI/HC/DLPFC_right/0back

%%% This script only do statistical analysis different condition (N2B vs 0B) within a single group from the con_003_dscalar.nii %%%
%%% This is comparing 2back vs 0B in ASD_Above8 group. The parameters you have to change are: 

sublistids=$1 <-- change the sublist depend on which group you want to run
filelist=$2 <--- in the filelist, you can change the con_003 to con_001 to run different condition for each group
outdir=$3   <--- change this output directory to which condition you want to run for each group

%%%%%%%%%%                              END                           %%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%                 STEPS TO RUN run_PALM_conmat.sh SCRIPT                     %%%%%%%%%%
%%% This script will compare between group (i.e ASD_Above8 versus ASD_Below8) %%%

1. You have to generate designmatrix.csv that specifies a one-sided t-test assessing whether there is a higher activation in the ASD_Above8 compared to ASD_Below8. The following design matrix persoms a t-test with three data points per group, where each column represent a group.
Ab8vsBel8_design.csv
	1,0
	1,0
	1,0
	0,1
	0,1
	0,1
2. Create a Ab8vBel8con.csv
	1,-1 <--- ASD_Above8 > ASD_Below8
	-1,1 <--- ASD_Below8 > ASD_Above8

3. Create a filelist and sublist.txt that contain subjects from ASD_Above to ASD_Below8
	This is Ab8vsBel8_filelist.txt

	/mnt/tigrlab/projects/ttan/ASSD/Data/testing/sub-HEF003_ses-01/con_0003.dscalar.nii
	/projects/ttan/ASSD/Data/testing/sub-EF008_ses-01/con_0003.dscalar.nii
	
	Ab8vsBel8_sublist.txt should follow the filelist order.

4.Create outdir$3, depend on which group comparison you want to run, in /projects/ttan/ASSD/PALM/groups/

5. Run the run_PALM_conmat.sh in terminal by:
	module load matlab
	module load palm/alpha102
	module load connectome-workbench
	dir=/projects/ttan/ASSD/Data/PALM/

${dir}run_PALM_conmat.sh  ${dir}Ab8vsBel8_sublist.txt  ${dir}Ab8vsBel8_filelist1.txt ${dir}groups/Ab8vBel8_2backv0Back ${dir}Ab8vsBel8_design.csv ${dir}Ab8vBel8con.csv

${dir}run_PALM_conmat.sh  ${dir}HCvAbove8_sublist.txt  ${dir}HCvAbove8_filelist1.txt ${dir}PPI/HCvAbove8/DLPFC_right/0back ${dir}HCvAbove8_design.csv ${dir}HCvAbove8con.csv

${dir}run_PALM_conmat.sh  ${dir}HCvBelow8_sublist.txt  ${dir}HCvBelow8_filelist1.txt ${dir}PPI/HCvBel8/DLPFC_right/0back ${dir}HCvBelow8_design.csv ${dir}HCvBelow8con.csv

${dir}run_PALM_conmat.sh  ${dir}Ab8vsBel8_sublist.txt  ${dir}Ab8vsBel8_filelist1.txt ${dir}PPI/Ab8vsBel8/DLPFC_right/0back ${dir}Ab8vsBel8_design.csv ${dir}Ab8vsBel8con.csv

sublistids=$1 <--- change this sublist depend on which group you want to compare
filelist=$2   <--- similar to sublist
outdir=$3     <--- change the dir to the appropriate comparison that you are running otherwise it will override your previous analysis	
desmat=$4     <--- change the design.csv depend on which group comparison you want to run
conmat=$5

%%%%%%%%%%%%%%%%%%%                     END                              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%          STEPS TO RUN HCP_gPPI.m SCRIPT              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

1. Choose and Create your ROIS base on the results generated by run_PALM_simpleT.sh:

Check this for more infor: https://github.com/edickie/ciftify/wiki/ciftify_surface_rois

In linux terminal:

module load python/3.6_ciftify_01
module load connectome-workbench
ciftify_surface_rois DLPFC_left.csv 5 /scratch/colin/epitome/hcp2/cvs_avg35_inMNI152/MNINonLinear/fsaverage_LR32k/cvs_avg35_inMNI152.L.midthickness.32k_fs_LR.surf.gii /scratch/colin/epitome/hcp2/cvs_avg35_inMNI152/MNINonLinear/fsaverage_LR32k/cvs_avg35_inMNI152.R.midthickness.32k_fs_LR.surf.gii DLPFC_left.dscalar.nii

wb_command -cifti-convert -to-nifti DLPFC_right.dscalar.nii DLPFC_right.nii <--- convert back to nii to run HCP_gPPI.m script

2.Open matlab environment and load fmri spm12
3.In matlab, go to the path that contain HCP_gPPI.m script and modify the indicated parameters to run your analysis
4.You can create loop to run all the subjects                  


#AEF in HCP DIR, should be AEF in sublist but file list which points to con, i think it can be different
#As long as everything is in order, and match up.







