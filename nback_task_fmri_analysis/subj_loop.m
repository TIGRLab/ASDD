load /mnt/tigrlab/projects/ttan/ASSD/Data/subs.mat
addpath ('/projects/ttan/ASSD/Code/gPPI/PPPIv13/')
addpath /projects/ttan/ASSD/Code/SPM/SPM_bat_scripts
for idx = 3:size(subs,1)
    subs{idx};
    %ASDD_nback_GLM(subs{idx})
    cd /projects/ttan/ASSD/Code/
    HCP_gPPI(subs{idx})
end