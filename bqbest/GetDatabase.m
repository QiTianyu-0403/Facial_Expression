function GetDatabase()
% ��ȡͼƬ��
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
% ����
num = length(S);
strNameList = [];
% ���ƹ���
for step = 1 : num
    str = S(step).filename;
    strName = str(1:2);
    strNameList = [strNameList; strName];
end
[C,ia,ic] = unique(strNameList,'rows');
T = [];
% 1 ������ A neutral face NE
% 2 ���� happy HA
% 3 ���� sad SA
% 4 ���� surprise SU
% 5 ��ŭ anger AN
% 6 ��� disgust DI
% 7 �־� fear FE
%h = waitbar(0,'�Ѵ���......', 'Name', '�������ͼ��');
steps = length(C);
for step = 1 : length(C)
  %  waitbar(step/steps,h,sprintf('�Ѵ���%d%%',round(step/steps*100)));
    pause(0.2);
    T(step).DatabseName = C(step, :);
    ind = find(ic == step);
    T(step).fileNameindList = ind;
    % ��ʼ������
    fileNameList = [];
    fileNameListNE = [];
    fileNameListHA = [];
    fileNameListSA = [];
    fileNameListSU = [];
    fileNameListAN = [];
    fileNameListDI = [];
    fileNameListFE = [];
    % �洢
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