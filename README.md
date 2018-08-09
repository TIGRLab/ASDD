# Code for ASDD n-Back task analysis


## Steps to run first level GLMs in SPM

1. Module load matlab
2. Module load SPM/12
3. In matlab command window: spm fmri
4. The scripts that does the work is ASDD_nback_GLM.m in SPM_bat_scripts. Currently set to run only Pre Subjects.
5. The output will be in the same folder as the fMRI/*s8.nii
6. The ASDD_GLM_sub_group.m script will generate a subject list.
7. Use subj_loop.m to iterate over subjects and run the GLM. old_loop.m is the old way where you just loop over directories instead of generating a subject list.

## Steps to run PALM using run_PALM_simpleT.sh script                       

1. export your HCP directory HCP_DATA=/scratch/mmanogaran/fmriprep/roi_ASDD_out/ciftify_ses/

2. Run a loop similar to this in terminal to convert you SPM outputs into dscalar to use in PALM:

```
for dir in /projects/ttan/ASSD/Data/testing/*; do
	wb_command -cifti-convert -from-nifti $dir/PPI/PPI_PCC_right/con_0001.nii /projects/colin/ASDD/smooth_activations/sub-EF001_ses-01/con_0001.dscalar.nii $dir/PPI/PPI_PCC_right/con_0001.dscalar.nii;
	wb_command -cifti-convert -from-nifti $dir/PPI/PPI_PCC_right/con_0002.nii /projects/colin/ASDD/smooth_activations/sub-EF001_ses-01/con_0002.dscalar.nii $dir/PPI/PPI_PCC_right/con_0002.dscalar.nii;
	wb_command -cifti-convert -from-nifti $dir/PPI/PPI_PCC_right/con_0003.nii /projects/colin/ASDD/smooth_activations/sub-EF001_ses-01/con_0003.dscalar.nii $dir/PPI/PPI_PCC_right/con_0003.dscalar.nii;
done
```

3. Create filelist and sublist for all the subjects based on the fMRI folders:

```
for dir in /projects/ttan/ASSD/Data/testing/*; do echo $dir >> filelist.txt; done

for dir in /projects/ttan/ASSD/Data/testing/*; do k=${dir##*sub-}; echo ${k%%_*} >> sublist.txt; done
```

4. Create further filelist and sublist of each group (i.e ASD_below8_filelist and sublist) via copying and pasting. This is what you want to run PALM on. Change the con_0001, con_0002, con_0003 depend on which contrast you like to run (i.e con_0001 is for 2back versus 0 back, con_0002 is 0back, con_0003 is 2back). IMPORTANT NOTE: DO NOT LEAVE ANY SPACE IN THE SUBLIST AND FILELIST AFTER THE LAST SUBJECT.

5. Run PALM! Make sure  output directory or PALM runs in current directory:

```
module load matlab
module load palm/alpha102
module load connectome-workbench

dir=/projects/ttan/ASSD/Data/PALM/ # dir is the path you store your PALM script

${dir}run_PALM_simpleT.sh ${dir}ASD_above8_sublist.txt ${dir}above8_filelistPPI.txt ${dir}PPI/Above8/DLPFC_right/2back
```

## Steps to run PALM using run_PALM_conmat.sh

1. You have to generate an FSL style designmatrix.csv, using ones and zeros to indicate group membership. This should align with your group filelist and sublist.
```
	1,0
	1,0
	1,0
	0,1
	0,1
	0,1
```
2. Create an FSL style contrast matrix:
```
	1,-1
	-1,1
```
3. Create your group filelist and sublists.
4. Run the run_PALM_conmat.sh in terminal by:

```
	module load matlab
	module load palm/alpha102
	module load connectome-workbench
	dir=/projects/ttan/ASSD/Data/PALM/

${dir}run_PALM_conmat.sh  ${dir}Ab8vsBel8_sublist.txt  ${dir}Ab8vsBel8_filelist1.txt ${dir}groups/Ab8vBel8_2backv0Back ${dir}Ab8vsBel8_design.csv ${dir}Ab8vBel8con.csv
```

## Steps to run gPPI using fixed ROI

1. The main script is HCP_gPPI.m.
2. Choose verticies and create your ROIS using ciftify_surface_rois:

Check this for more info: https://github.com/edickie/ciftify/wiki/ciftify_surface_rois

```
module load python/3.6_ciftify_01
module load connectome-workbench
ciftify_surface_rois DLPFC_left.csv 5 /scratch/colin/epitome/hcp2/cvs_avg35_inMNI152/MNINonLinear/fsaverage_LR32k/cvs_avg35_inMNI152.L.midthickness.32k_fs_LR.surf.gii /scratch/colin/epitome/hcp2/cvs_avg35_inMNI152/MNINonLinear/fsaverage_LR32k/cvs_avg35_inMNI152.R.midthickness.32k_fs_LR.surf.gii DLPFC_left.dscalar.nii

wb_command -cifti-convert -to-nifti DLPFC_right.dscalar.nii DLPFC_right.nii
```

3. Module load matlab and SPM. Add the gPPI toolbox to your path.
4. You can use subj_loop to run all the subjects.

## Steps to run gPPI using task localizer

1. The main script is still HCP_gPPI.m
2. Instead of a single ROI being used for everyone, each subject gets a unique ROI based on their activation.
3. Run Task_Localizer.sh with the loop. The one in the repo currently will generate a 25mm ROI around the DLPFC vertex. It can be modified to be lareger, and can also be constrained to the fronto-parietal and salience networks from yeo atlas.
4. The task localizer basically will find the maximum vertex of activation in the search space, and draw a 5mm ROI around that.
5. Change your HCP_gPPI.m script to point to the individualized ROIs.

## Other things to note:

AEF in HCP DIR, should be AEF in sublist but not in file list which points to con, i think it can be different As long as everything is in order, and match up.
EF036_01 has improper TRs
