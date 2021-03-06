addpath /mnt/tigrlab/projects/ttan/ASSD/Data/testing

datadir = dir('testing');
filenames = rmfield(datadir, 'date');
filenames = rmfield(filenames, 'bytes');
filenames = rmfield(filenames, 'isdir');
filenames = rmfield(filenames, 'datenum');
filesnames = {filenames.name};
filesnames = filesnames(1,3:61);

for k = 1:length(filesnames)
    if k < 40
    cellcontents = filesnames{k};
    filesnames{k} = cellcontents(5:9);
    else
    cellcontents = filesnames{k};
    filesnames{k} = cellcontents(5:10);
    end
end
filesnames = transpose(filesnames);
subs = filesnames;
save('subs.mat');



