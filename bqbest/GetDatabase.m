function GetDatabase()
% 获取图片库
clc; clear all; 
file = fullfile(pwd, 'Database/list.txt');
fid = fopen(file, 'r');
S = [];
while ~feof(fid)
    tline = fgetl(fid);
    ind = strfind(tline, ' ');
    if ~isempty(ind)
        filename = tline(ind(end)+1:end);
        s.filename = filename;
        S = [S s];
    end
end
fclose(fid);
% 个数
num = length(S);
strNameList = [];
% 名称过滤
for step = 1 : num
    str = S(step).filename;
    strName = str(1:2);
    strNameList = [strNameList; strName];
end
[C,ia,ic] = unique(strNameList,'rows');
T = [];
% 1 中性脸 A neutral face NE
% 2 高兴 happy HA
% 3 悲伤 sad SA
% 4 惊奇 surprise SU
% 5 愤怒 anger AN
% 6 厌恶 disgust DI
% 7 恐惧 fear FE
%h = waitbar(0,'已处理......', 'Name', '载入表情图像');
steps = length(C);
for step = 1 : length(C)
  %  waitbar(step/steps,h,sprintf('已处理%d%%',round(step/steps*100)));
    pause(0.2);
    T(step).DatabseName = C(step, :);
    ind = find(ic == step);
    T(step).fileNameindList = ind;
    % 初始化变量
    fileNameList = [];
    fileNameListNE = [];
    fileNameListHA = [];
    fileNameListSA = [];
    fileNameListSU = [];
    fileNameListAN = [];
    fileNameListDI = [];
    fileNameListFE = [];
    % 存储
    for j = 1 : length(ind)
        temp = S(ind(j)).filename;
        fileNameList{j} = temp;
        if strfind(temp, 'NE')
            fileNameListNE{end+1} = temp;
        end
        if strfind(temp, 'HA')
            fileNameListHA{end+1} = temp;
        end
        if strfind(temp, 'SA')
            fileNameListSA{end+1} = temp;
        end
        if strfind(temp, 'SU')
            fileNameListSU{end+1} = temp;
        end
        if strfind(temp, 'AN')
            fileNameListAN{end+1} = temp;
        end
        if strfind(temp, 'DI')
            fileNameListDI{end+1} = temp;
        end
        if strfind(temp, 'FE')
            fileNameListFE{end+1} = temp;
        end
    end
    T(step).fileNameList = fileNameList;
    T(step).fileNameListNE = fileNameListNE;
    T(step).fileNameListHA = fileNameListHA;
    T(step).fileNameListSA = fileNameListSA;
    T(step).fileNameListSU = fileNameListSU;
    T(step).fileNameListAN = fileNameListAN;
    T(step).fileNameListDI = fileNameListDI;
    T(step).fileNameListFE = fileNameListFE;
end
%delete(h);
save(fullfile(pwd, 'S.mat'),'S')
save(fullfile(pwd, 'T.mat'), 'T')