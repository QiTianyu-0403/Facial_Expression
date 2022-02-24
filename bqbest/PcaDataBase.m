function PcaDataBase()
clc; clear all;
% ����Ѿ�����ģ����Ϣ
if ~exist(fullfile(pwd, 'PcaDatabse'), 'dir')
    mkdir(fullfile(pwd, 'PcaDatabse'));
end
load S.mat
%��ȡ�������ص���Ϣ�����ɵľ�����Ϊ���ص���ţ���Ϊ���ص�
allsamples = GetSamples(S);
%��þ�ֵ
samplemean = mean(allsamples);
%�����ĵ�ƽ�Ƶ�ԭ�㣬�򻯷���ļ���
xmean = GetStandSample(allsamples, samplemean);
%����Э�������
sigma = xmean'*xmean;
% ��ȡ����ֲ����������
[v, d] = eig(sigma);
d1 = diag(d);

%��������ֵ��С������ֵ������������������������
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
%�趨��ά���ά��14*14 = 196
p = 196;
%��ȡ�任����
base = vsort(:,1:p);
% ��ģ�ͱ���
save(fullfile(pwd, 'model.mat'),'base', 'samplemean');
%h = waitbar(0,'�Ѵ���......', 'Name', 'Pca��ά����');

steps = 196;
for step = 1 : length(S)
   % waitbar(1/2+step/steps/2,h,sprintf('�Ѵ���%d%%',round(50+step/steps*50)));
    file = S(step).Gfile;
    % �������ͼ��
    a = imread(file);
    a = imresize(a, [50 50], 'bilinear');
    b = a(1:2500);
    b = double(b);
    % ����ÿ������ͼ������ɷ�,�����������ڱ任������ϵ�ϵ�ͶӰ����1��p�׾���
    %ƽ�Ƶ����ĵ�
    b = b - samplemean;
    %���任����ά
    tcoor = b*base;
    S(step).G = tcoor;
end
%delete(h);
save(fullfile(pwd, 'S.mat'),'S')

function allsamples = GetSamples(S)
%��¼ͼƬ���ص���Ϣ
allsamples = []; 
for i = 1 : length(S)
    file = S(i).filename;
    fileIn = sprintf('Database/%s', file);
    fileIn = fullfile(pwd, fileIn);
    a = imread(fileIn);
    a = imresize(a, [50 50], 'bilinear');
    [row, col] = size(a);
    % b����ʸ��1*N��N=row*col����ȡ˳�������к���
    % �����ϵ��£�������
    b = a(1 : row*col);
    b = double(b);
    % allsamples��һ��M*N����allsamples��ÿһ�����ݴ�
    allsamples = [allsamples; b];
end

function xmean = GetStandSample(allsamples, samplemean)
for i = 1 : size(allsamples, 1)
    xmean(i, :) = allsamples(i, :) - samplemean;
end