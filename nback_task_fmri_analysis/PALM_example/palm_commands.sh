module load matlab
module load palm/alpha102
module load connectome-workbench
dir=/projects/ttan/ASSD/Data/PALM/


${dir}run_PALM_simpleT.sh  ${dir}HCsublist.txt  ${dir}HC_filelist.txt ${dir}groups/HC_con1
${dir}run_PALM_simpleT.sh  ${dir}HCsublist.txt  ${dir}HC_filelist2.txt ${dir}groups/HC_con2
${dir}run_PALM_simpleT.sh  ${dir}HCsublist.txt  ${dir}HC_filelist2.txt ${dir}groups/HC_con2


${dir}run_PALM_simpleT.sh  ${dir}ASD_above8_sublist.txt  ${dir}above8_filelist.txt ${dir}groups/above8_con1
${dir}run_PALM_simpleT.sh  ${dir}ASD_above8_sublist.txt  ${dir}above8_filelist2.txt ${dir}groups/above8_con2
${dir}run_PALM_simpleT.sh  ${dir}ASD_above8_sublist.txt  ${dir}above8_filelist3.txt ${dir}groups/above8_con3


${dir}run_PALM_simpleT.sh  ${dir}ASD_below8_sublist.txt  ${dir}below8_filelist.txt ${dir}groups/below8_con1
${dir}run_PALM_simpleT.sh  ${dir}ASD_below8_sublist.txt  ${dir}below8_filelist2.txt ${dir}groups/below8_con2
${dir}run_PALM_simpleT.sh  ${dir}ASD_below8_sublist.txt  ${dir}below8_filelist3.txt ${dir}groups/below8_con3




dir=/mnt/tigrlab/projects/colin/ASDD/smooth_activations/PALM/PPI/
${dir}run_PALM_simpleT.sh  ${dir}HCsublist.txt  ${dir}HC_filelist1.txt ${dir}HC_LDLPFC1

${dir}run_PALM_simpleT.sh  ${dir}ASD_above8_sublist.txt  ${dir}above8_filelist1.txt ${dir}above8_LDLPFC1

${dir}run_PALM_simpleT.sh  ${dir}HC_sublist.txt  ${dir}HC_filelist.txt ${dir}groups/HC_2backv0back
${dir}run_PALM_conmat.sh ${dir}  HCvsAbv_sublist.txt  ${dir}HC_Above8_filelist1.txt  ${dir}HC_Above8_LDLPFC1  ${dir}HCvsAbv.csv  ${dir}con.csv

${dir}run_PALM_conmat.sh  ${dir}HCvAbove8_sublist.txt  ${dir}HCvAbove8_filelist1.txt ${dir}groups/stupid8 ${dir}HCvAbove8_design.csv ${dir}HCvAbove8con.csv

${dir}run_PALM_conmat.sh  ${dir}HCvBelow8_sublist.txt  ${dir}HCvBelow8_filelist1.txt ${dir}groups/stupid5 ${dir}HCvBelow8_design.csv ${dir}HCvBelow8con.csv

${dir}run_PALM_conmat.sh  ${dir}Ab8vsBel8_sublist.txt  ${dir}Ab8vsBel8_filelist1.txt ${dir}groups/Ab8vBel8_2backv0Back ${dir}Ab8vsBel8_design.csv ${dir}Ab8vBel8con.csv

${dir}run_PALM_conmat.sh  ${dir}Ab8vsBel8_sublist.txt  ${dir}Ab8vsBel8_filelist1.txt ${dir}groups/stupid4 ${dir}Ab8vsBel8_design.csv ${dir}Ab8vBel8con.csv




### RIGHT
dir=/mnt/tigrlab/projects/colin/ASDD/smooth_activations/PALM/PPI/
${dir}run_PALM_simpleT.sh  ${dir}HCsublist.txt  ${dir}R_HC_filelist1.txt ${dir}R_HC_LDLPFC1

${dir}run_PALM_simpleT.sh  ${dir}ASD_above8_sublist.txt  ${dir}R_above8_filelist1.txt ${dir}R_above8_LDLPFC1

${dir}run_PALM_conmat.sh ${dir}HCvsAbv_sublist.txt ${dir}R_HC_Above8_filelist1.txt   ${dir}R_HC_Above8_LDLPFC1  ${dir}HCvsAbv.csv  ${dir}con.csv







