%Loops through ASDD_hcp2 directory and calls HCP_gPPI on eerbody. Can also
%use this with Make_Contrasts
load /mnt/tigrlab/projects/ttan/ASSD/Data/subs.mat
addpath ('/projects/ttan/ASSD/Code/gPPI/PPPIv13/')
addpath /projects/ttan/ASSD/Code/SPM/SPM_bat_scripts

s=dir('/projects/ttan/ASSD/Data/testing/');%struct of each folder %change

for i=3:(length(s))%3 cause first 2 are . & ..
    subj = s(i).name;
    if subj(10) == 'H'%
         %k = dir(['/projects/lyoganathan/ASDD_hcp/' subj '/smooth_nback/mask.nii']);
         k = dir(['/projects/lyoganathan/ASDD_hcp/' subj '/']);
         
          if isempty(k)
                    ['No scan data for ' subj];
                else
                    cd /projects/ttan/ASSD/Code/
                    ['Running ' subj]
                    try
                    HCP_gPPI(subj);%
                    end
                end
    else
        [subj 'is not ASD']%
    end
end

%parfor version for speed
s=dir('/projects/lyoganathan/ASDD_hcp2/');%struct of each folder %change
parpool('local', 8)

parfor i=3:(length(s))%3 cause first 2 are . & ..
    subj = s(i).name;
    k = dir(['/projects/lyoganathan/ASDD_hcp2/' subj '/smooth_nback/mask.nii']);
    if isempty(k)
        ['No scan data for ' subj];
    else
        cd /scratch/lyoganathan/Scripts/MATLAB_SPM
        ['Running ' subj]
        try
          HCP_gPPI(subj);%
        end
    end
end
