function varargout = MainForm(varargin)

gui_Singleton = 1;%����������
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MainForm_OpeningFcn, ...
    'gui_OutputFcn',  @MainForm_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);%�����˸�GUI��״��������gui�����֡�����ʵ������ʼ����������������������Լ��ص�������
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});%ȡ��figure�Ͱ����Ŀؼ���CreateFcn�ص����������������ؼ���
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

%��������ɼ�֮ǰִ�С�
function MainForm_OpeningFcn(hObject, eventdata, handles, varargin)

ha=axes('units','normalized','pos',[0 0 1 1]);
uistack(ha,'down');
ii=imread('3.png');
%���ó���ı���ͼΪ1.jpg
image(ii);
colormap gray
set(ha,'handlevisibility','off','visible','off');

rand('seed', 0);
%ѡ��MainForm��Ĭ�����������
handles.output = hObject;
handles.Img = 0;
handles.G = 0;
axes(handles.axes1); cla reset;
set(handles.axes1, 'Box', 'on', 'Color', 'w', 'XTickLabel', '', 'YTickLabel', '');
set(handles.axes2, 'Box', 'on', 'Color', 'w', 'XTickLabel', '', 'YTickLabel', '');
set(handles.textResult, 'String', '');
% ���¾���ṹ
guidata(hObject, handles);


% �˺�����������ص�������.
function varargout = MainForm_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;



function pushbutton1_Callback(hObject, eventdata, handles)
% ��ȡ�������ݿ�
GetDatabase();
GaborDatabse();
PcaDataBase();
S = GetTrainData();
Elm_Type = 1;
NumberofHiddenNeurons = 200;
ActivationFunction = 'sin';
[TrainingTime,TrainingAccuracy] = elm_train(S, Elm_Type, ...
    NumberofHiddenNeurons, ActivationFunction);
msgbox('�����ʼ�����', '��ʾ��Ϣ');


function pushbutton5_Callback(hObject, eventdata, handles)
% �����ʶ��ͼ��
% ����ͼ��
[FileName,PathName,FilterIndex] = uigetfile({'*.tiff;*.jpg;*.tif;*.png;*.gif','All Image Files';...
    '*.*','All Files' },'����ͼ��',...
    './Test/im1.tiff');
if isequal(FileName, 0) || isequal(PathName, 0)
    return;
end
file = fullfile(PathName, FileName);
Img = imread(file);
imshow(Img, [], 'Parent', handles.axes2);
handles.Img = Img;
guidata(hObject, handles);
set(handles.textResult, 'String', '');


function pushbutton6_Callback(hObject, eventdata, handles)
% ELM����ʶ��
if isequal(handles.G, 0)
    return;
end
Img = handles.Img;
G = handles.G;
if ndims(Img) == 3
   Img = rgb2gray(Img);
end
G = handles.G;
if ndims(G) == 3
  G = rgb2gray(G);
end

G = imresize(G, [50 50], 'bilinear');
load(fullfile(pwd, 'model.mat'));
%[G,gabout] = gaborfilter(I,Sx,Sy,f,theta)
[~,gab] = gaborfilter(G,2,4,16,pi/3);%////////////////
b = gab(1:2500);
b = double(b);
b = b - samplemean;%/////////////////////////////////////////////
% ����ÿ������ͼ������ɷ�,�����������ڱ任������ϵ�ϵ�ͶӰ����1��p�׾���
tcoor = b*base;%
c = tcoor;
data = [1 c(:)'];
[~, ~,output1] = elm_predict(data, Img);
switch output1

    case 1
        str = 'ƽ��';
    case 2
        str = '����';
    case 3
        str = '����';
    case 4
        str = '����';
    case 5
        str = '��ŭ';
    case 6
        str = '���';
    case 7
        str = '�־�';
    otherwise
        str = 'ƽ��';
end
%ddd = TrainingAccuracy;
set(handles.textResult, 'String', str);
%set(handles.text7, 'String', ddd);


function pushbutton7_Callback(hObject, eventdata, handles)
if isequal(handles.Img, 0)
    return;
end
Img = handles.Img;
if ndims(Img) == 3
    I = rgb2gray(Img);
else
    I = Img;
end
% ��ȡgabor����
[G,gabout] = gaborfilter(I,2,4,16,pi/3);
imshow(gabout, [], 'Parent', handles.axes2);
handles.G = gabout;
guidata(hObject, handles);


function pushbutton8_Callback(hObject, eventdata, handles)
% �˳�ϵͳ
choice = questdlg('ȷ���˳�?', ...
    '�˳�', ...
    '��','��','ȡ��','ȡ��');
switch choice
    case '��'
        close;
end
