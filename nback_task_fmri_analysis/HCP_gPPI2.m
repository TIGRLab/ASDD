%addpath ('/projects/ttan/ASSD/Code/gPPI/PPPIv13/')

%Make sure gPPI toolbox is in your path (tested on PPPIv13)
%If you download PPPIv13 toolbox newly, make sure line 278 is
%if ~strcmp(spm('Ver'),'SPM8') && ~strncmpi(spm('Ver'),'SPM12',5)
%if you want to use SPM12

%can be used in loop for each ASD/HC subj (have to write separte loop that
%calls this function (gPPI_Loop.m).
%loops thru and add contrasts at the end...
%based on first level GLM which has already been estimated, this just adds
%more columns to the GLM which contain PPI info (conditions and ROI time
%course)
%Create individual Peak ROIs using Task_Localizer.sh and point that to P.VOI
%Lines that end with % means you have to change for each new ROI
%you want to run PPI on

%From the Manual:

%Required Options:
%			subject -- 	A string with the subject number
%			directory -- 	Either a string with the path to the first-level SPM.mat directory, or if you are
%					only estimating a PPI model, then path to the first-level PPI directory.
%VOI --	Either a string with a filename and path OR a structure variable (details will be in a future version of the manual) defining the seed region. The file should be a VOI.mat file or an image file of the ROI (see create_sphere_image package).
%			Region -- 	A string containing the basename of output file(s), if doing physiophysiological 						interaction, then two names separated by a space are needed.
%			analysis --	Specifies psychophysiological interaction ('psy'); physiophysiological interaction 						('phys'); or psychophysiophysiological interactions ('psyphy').
%method --	Specifies traditional SPM PPI ('trad') or generalized condition-specific PPI ('cond'). It is recommend that the ‘cond’ approach is always selected (see McLaren et al. 2012 in NeuroImage for details).

function HCP_gPPI(subj)
P.subject = subj;
%First level GLM directory
P.directory = ['/projects/ttan/ASSD/Data/testing/' subj '/'];

%Fixed:
P.VOI = ['/projects/ttan/ASSD/Data/PPI_ROI/DLPFC_right.nii'];%

%Moving: (Need to set up with scripts in Task_Localizer)
%P.VOI = ['/projects/lyoganathan/ASDD_hcp2/' subj '/masks/TMS_Left_max.nii'];%

P.Region = 'DLPFC_right';%
P.analysis = 'psy';
P.method = 'cond';
%P.contrast = {'Effects of Interest'};%Why do we need this?
P.extract='eig';
P.outdir = ['/projects/ttan/ASSD/Data/testing/' subj '/PPI']; %only works when estimate is 1
P.Tasks = {'1' 'condition1' 'condition2'};
P.equalroi=0;
P.Estimate = 1;
mkdir (P.outdir);

%For some reason with SPM12, saves cons as img instead of nii(unless u run twice - known glitch)
%img can't be used in second level
%uncomment when a cure is found, for now I manually create contrasts using
%Colins contrast script
%P.CompContrasts = 1
%P.Contrasts(1).left={'condition2'}
%P.Contrasts(1).right={'condition1'}
%P.Contrasts(1).STAT='T';
%P.Contrasts(2).left={'condition1'}
%P.Contrasts(2).right={'condition2'}
%P.Contrasts(2).STAT='T';


%PPPI(paramteres, structure file) <- refer to gPPI manual for more info
PPPI(P,'struct.mat') %struct.mat is created automatically by gPPI and holds info from P? I think...

%loop through and create contrasts
directory = ['/projects/ttan/ASSD/Data/testing/' subj '/PPI/PPI_DLPFC_right'];%
con_names = {'2back_0back';'0 back';'2 back'};
con_matrix = {[-1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 -1 1 0 zeros(1,11) 0];%2back-0back
    [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 zeros(1,11)  0]; %0back
    [0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1 0 zeros(1,11)  0]}; %2back

if ~isempty(con_names)
    if isstr(con_names)
        name = textread(name,'%s','delimiter','\n')
            for idx =  1:size(contasts, 1)
                contrasts.names{idx} = in(idx); 
            end
    end
    if iscell(con_names)
        for idx =  1:size(con_matrix, 1)
            contrasts.names{1,idx} = con_names{idx};
        end
    end % if iscell
else %names not provided
     for idx =  1:size(con_matrix, 1)
            contrasts.names{1,idx} = ['c' num2str(idx)];
     end
end

for idx = 1:size(con_matrix, 1)
    if size(con_matrix{idx},1) == 1 %decide whether contrast is T or F
        contrasts.types{idx} = 'T';
    else
        contrasts.types{idx} = 'F';
    end
    tc{idx} = con_matrix(idx,:);
end

cd(directory)
load SPM
% any existing contrasts are removed, to make sure we know what is what
% after the program is finished. 
% this also removes an empty contrast field SPM writes into the SPM.mat
% file, which gave problems in the for loop below. 


SPM = rmfield(SPM, 'xCon') %% #ok<NOPRT>
% SPM.xCon - Contrast definitions structure array, can use spm_FcUtil to
% write to it

for c=1:length(tc)
    SPM.xCon(c)= spm_FcUtil('Set',contrasts.names{c},contrasts.types{c},'c',tc{c}{1}',SPM.xX.xKXs);
    %SPM.xX.xKXs - space structure for K*W*X, the 'filtered and whitened'
    %design matrix, design matrix information
end

spm_contrasts(SPM, 1:length(tc)); %writes con_000? files to directory
clear SPM












