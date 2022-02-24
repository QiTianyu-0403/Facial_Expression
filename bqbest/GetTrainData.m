function S = GetTrainData()
clc; clear all; 
load S.mat
% 1 中性脸 A neutral face NE
% 2 高兴 happy HA
% 3 悲伤 sad SA
% 4 惊奇 surprise SU
% 5 愤怒 anger AN
% 6 厌恶 disgust DI
% 7 恐惧 fear FE
num = length(S);
% 生成训练数据
for i = 1 : num
    temp = S(i).filename;
    if strfind(temp, 'NE')
        v = 1;
    end
    if strfind(temp, 'HA')
        v = 2;
    end
    if strfind(temp, 'SA')
        v = 3;
    end
    if strfind(temp, 'SU')
        v = 4;
    end
    if strfind(temp, 'AN')
        v = 5;
    end
    if strfind(temp, 'DI')
        v = 6;
    end
    if strfind(temp, 'FE')
        v = 7;
    end
    G = S(i).G;
    data = [v G(:)'];
    S(i).data = data;
end
save(fullfile(pwd, 'S.mat'),'S')
