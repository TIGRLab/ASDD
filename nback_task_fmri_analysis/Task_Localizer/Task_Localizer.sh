#For Subject find max in given L/R ROI

#Loop over subjects with Task_Localizer

SUBJECT=$1
DATA_DIR=/scratch/lyoganathan/ASDD_PPI/
ROI=DLPFC
OUTDIR=/scratch/lyoganathan/ASDD_PPI/
for Hemisphere in L R; do
	#Set different ways of saying left and right
	if [ $Hemisphere = "L" ] ; then
		Structure="CORTEX_LEFT"
	elif [ $Hemisphere = "R" ] ; then
		Structure="CORTEX_RIGHT"
	fi
  #Create Search Space of size 25mm
  #Large circle in DLPFC on average surface
  wb_command -surface-geodesic-rois /scratch/colin/epitome/hcp2/cvs_avg35_inMNI152/MNINonLinear/fsaverage_LR32k/cvs_avg35_inMNI152.${Hemisphere}.midthickness.32k_fs_LR.surf.gii 25 ${ROI}_${Hemisphere}_Vertex.txt ${ROI}_${Hemisphere}.func.gii

  #create dense template 
  wb_command -cifti-create-dense-from-template $DATA_DIR/sub-EF001_ses-01/con_0001.dscalar.nii ${ROI}_${Hemisphere}_ROI.dscalar.nii -metric $Structure ${ROI}_${Hemisphere}.func.gii

  #Remove Intermediate Files
  rm  ${ROI}_${Hemisphere}.func.gii
  #Find max vertex within the search space
  #Multiply ROI with con
  wb_command -cifti-math a*b search.dscalar.nii -var a ${ROI}_${Hemisphere}_ROI.dscalar.nii -var b ${DATA_DIR}/${SUBJECT}/con_0001.dscalar.nii
  #Get index to vertex mapping (zero based)
  wb_command -cifti-export-dense-mapping search.dscalar.nii COLUMN -surface $Structure ${Hemisphere}_map.txt
  #Find max index (one based)
  INDEX=$(wb_command -cifti-stats search.dscalar.nii -reduce INDEXMAX)
  #Subtract 1 to get zero based cifti index
  INDEX=$(($INDEX - 1))
  #Find max vertex (match 1st column(cifti index) print 2nd column(surface vertex))
  awk -v i=$INDEX '$1 == i { print $2 }' ${Hemisphere}_map.txt > Peak.txt
  #Create 5mm ROI at vertex
  wb_command -surface-geodesic-rois /scratch/colin/epitome/hcp2/cvs_avg35_inMNI152/MNINonLinear/fsaverage_LR32k/cvs_avg35_inMNI152.${Hemisphere}.midthickness.32k_fs_LR.surf.gii 5 Peak.txt ${ROI}_${Hemisphere}_max.func.gii
  #To dscalar
  wb_command -cifti-create-dense-from-template $DATA_DIR/sub-EF001_ses-01/con_0001.dscalar.nii ${OUTDIR}/${SUBJECT}/${ROI}_${Hemisphere}_max.dscalar.nii -metric $Structure ${ROI}_${Hemisphere}_max.func.gii
  #To nifti
  wb_command -cifti-convert -to-nifti ${OUTDIR}/${SUBJECT}/${ROI}_${Hemisphere}_max.dscalar.nii ${OUTDIR}/${SUBJECT}/${ROI}_${Hemisphere}_max.nii
  #Remove intermediate files
  rm ${Hemisphere}_map.txt search.dscalar.nii Peak.txt ${ROI}_${Hemisphere}_max.func.gii
done
