function GaborDatabse()
% Gabor特征库
clc; clear all;
if ~exist(fullfile(pwd, 'GaborDatabse'), 'dir')
    mkdir(fullfile(pwd, 'GaborDatabse'));
end
load S.mat
%h = waitbar(0,'已处理......', 'Name', 'Gabor特征提取');
steps = length(S);
for step = 1 : steps
  %  waitbar(step/steps,h,sprintf('已处理%d%%',round(step/steps*100)));
    file = S(step).filename;
    fileIn = sprintf('Database/%s', file);
    fileIn = fullfile(pwd, fileIn);
    Img = imread(fileIn);
    if ndims(Img) == 3
        I = rgb2gray(Img);
    else
        I = Img;
    end
    % 提取gabor特征
    [G,gabout] = gaborfilter(I,2,4,16,pi/3);
    % 写出特征
    [pathstr, name, ext] = fileparts(file);
    fileOut = sprintf('GaborDatabse/%s.jpg', name);
    fileOut = fullfile(pwd, fileOut);
    imwrite(gabout, fileOut);
    S(step).Gfile = fileOut;
end
%delete(h);
save(fullfile(pwd, 'S.mat'),'S')
