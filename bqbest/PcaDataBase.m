function PcaDataBase()
clc; clear all;
% 如果已经存在模型信息
if ~exist(fullfile(pwd, 'PcaDatabse'), 'dir')
    mkdir(fullfile(pwd, 'PcaDatabse'));
end
load S.mat
%获取所有像素点信息，生成的矩阵行为像素点序号，列为像素点
allsamples = GetSamples(S);
%算得均值
samplemean = mean(allsamples);
%将中心点平移到原点，简化方差的计算
xmean = GetStandSample(allsamples, samplemean);
%计算协方差矩阵
sigma = xmean'*xmean;
% 获取特征植及特征向量
[v, d] = eig(sigma);
d1 = diag(d);

%根据特征值大小将特征值矩阵和特征向量矩阵进行排序
[m,~] = size(d1);
for i = 1 : m-1 
    for j = i : m-1
       if(d1(j+1,1)>d1(j,1)) 
        v(:,[j,j+1]) = v(:,[j+1,j]);
        d1([j,j+1],:) = d1([j+1,j],:);
       end
    end
end
vsort = v;
%设定降维后的维度14*14 = 196
p = 196;
%提取变换矩阵
base = vsort(:,1:p);
% 将模型保存
save(fullfile(pwd, 'model.mat'),'base', 'samplemean');
%h = waitbar(0,'已处理......', 'Name', 'Pca降维处理');

steps = 196;
for step = 1 : length(S)
   % waitbar(1/2+step/steps/2,h,sprintf('已处理%d%%',round(50+step/steps*50)));
    file = S(step).Gfile;
    % 读入测试图像
    a = imread(file);
    a = imresize(a, [50 50], 'bilinear');
    b = a(1:2500);
    b = double(b);
    % 计算每幅测试图像的主成分,即计算它们在变换后坐标系上的投影，是1×p阶矩阵
    %平移到中心点
    b = b - samplemean;
    %基变换，降维
    tcoor = b*base;
    S(step).G = tcoor;
end
%delete(h);
save(fullfile(pwd, 'S.mat'),'S')

function allsamples = GetSamples(S)
%记录图片像素点信息
allsamples = []; 
for i = 1 : length(S)
    file = S(i).filename;
    fileIn = sprintf('Database/%s', file);
    fileIn = fullfile(pwd, fileIn);
    a = imread(fileIn);
    a = imresize(a, [50 50], 'bilinear');
    [row, col] = size(a);
    % b是行矢量1*N，N=row*col，提取顺序是先列后行
    % 即从上到下，从左到右
    b = a(1 : row*col);
    b = double(b);
    % allsamples是一个M*N矩阵，allsamples中每一行数据代
    allsamples = [allsamples; b];
end

function xmean = GetStandSample(allsamples, samplemean)
for i = 1 : size(allsamples, 1)
    xmean(i, :) = allsamples(i, :) - samplemean;
end