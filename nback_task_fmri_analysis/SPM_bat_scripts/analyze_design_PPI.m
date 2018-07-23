function  analyze_design_PPI(directory, files, HRF, TR, regress)
%  analyze_spm_design(directory, files, HRF, TR, ons, regress, pmod)
%
% creates the design matrix for PPI using PPI thingies as regressors
% Calls spm_run_fmri_spec.m, with the appropriatly set up inut matrix.
%
% directory is the directory into which the SPM.mat file will be saved.
% Idially, his should probably be a directory for that particulair participant
%
% files is a list of files to be included in the analysis, in a 3-d array.
% The 3rd dimention separated files into different scanning sessions. Note
% that the program will assume that there are the same number of scans in
% each session. This array can be created by calling
% analyze_spm_create_filelist.m
%
% hrf tells the program what HRF you want to use. This variable can be a 1
% (for standard HRF alone), 2, for HRF plus derivative, or 3, for HRF plus
% the derivative and dispersion
%
% TR is the TR of the scans, in seconds
%
% Modieified from analyze_spm12_design
% Colin Hawco, Winter 2011
% updated dec 2013

load basejob2
job.dir = {directory};

%timing info
job.timing.units='secs';
job.timing.RT=TR;
job.timing.fmri_t= 16;
job.timing.fmri_t0= 8;
job.mthresh = 0.2;  %0.5

%HRF to use
if HRF == 1
    disp('Using HRF alone')
    job.bases.hrf.derivs=[0 0];
elseif HRF == 2
    job.bases.hrf.derivs=[1 0];
    disp('Using HRF plus derivative')
elseif HRF == 3
    job.bases.hrf.derivs=[1 1];
    disp('Using HRF plus derivative and dispersion')
else
    disp('Inproper input for variable HRF, assuming we should use HRF alone')
    job.bases.hrf.derivs=[0 0];
end

% again, more basic values that should probably be left alone. AR is the
% autocorrolation 
job.volt= 1;
job.global= 'None';
job.mask= {''};
job.cvi='AR(1)';

% values for sess variables
for idx =1:size(files,3)
    job.sess(idx).cond = []; %number of conditions = 0
    for jdx = 1:length((files(:,1,idx))) % allows for runs of different lengths
        if ~isempty(deblank([files(jdx,:,idx)])) %doesn't include blank entries
            job.sess(idx).scans(jdx) = {[files(jdx,:,idx)]};
        end
    end
    
    job.sess(idx).hpf = 128;
end

%now, the regressos - nargin is input arguments to a function
if nargin > 4
    %regressors
    if ischar(regress) %text files for regressors loaded
        if size(regress, 1) == 1
            Rtemp = textread(regress);
            curnum = 1;
            %write regressors for each session
            for idx = 1:size(files,3)
                
                for jdx = 1:size(Rtemp,2)
                    job.sess(idx).regress(jdx).name = ['R' num2str(jdx)];
                    job.sess(idx).regress(jdx).val = Rtemp(curnum: curnum + size(job.sess(idx).scans,2)-1,jdx);
                end
                curnum = curnum + size(job.sess(idx).scans,2);
            end
        end        
    elseif isnumeric(regress)        
        Rtemp = regress;
        curnum = 1;
        %write regressors for each session
        for idx = 1:size(files,3)            
            for jdx = 1:size(Rtemp,2)
                job.sess(idx).regress(jdx).name = ['R' num2str(jdx)];
                job.sess(idx).regress(jdx).val = Rtemp(curnum: curnum + size(job.sess(idx).scans,2)-1,jdx);
            end
            curnum = curnum + size(job.sess(idx).scans,2);            
        end        
    else % regressors not number or string
        disp(' ')
        disp(' ')
        disp(' ')
        disp('Warning: regressors in unknown format, not included in analysis')
        disp(' ')
        disp(' ')
        disp(' ')
    end  
end

% SPM function to Set up the design matrix and run a design
spm_run_fmri_spec(job)

cd(directory)
load SPM
spm_spm(SPM);
load SPM
% VRes = spm_write_residuals(SPM,NaN);
% collapse_nii_scan('Res*.nii', 'Residuals_allruns');
% Delete('Res_*.nii');


