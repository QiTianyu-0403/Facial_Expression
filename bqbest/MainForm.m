function varargout = MainForm(varargin)

gui_Singleton = 1;%单窗口运行
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MainForm_OpeningFcn, ...
    'gui_OutputFcn',  @MainForm_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);%描述了该GUI的状况，包括gui的名字、运行实例、初始化函数、输出函数、布局以及回调函数。
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});%取得figure和包含的控件的CreateFcn回调函数，创建各个控件。
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

%在主窗体可见之前执行。
function MainForm_OpeningFcn(hObject, eventdata, handles, varargin)

ha=axes('units','normalized','pos',[0 0 1 1]);
uistack(ha,'down');
ii=imread('3.png');
%设置程序的背景图为1.jpg
image(ii);
colormap gray
set(ha,'handlevisibility','off','visible','off');

rand('seed', 0);
%选择MainForm的默认命令行输出
handles.output = hObject;
handles.Img = 0;
handles.G = 0;
axes(handles.axes1); cla reset;
set(handles.axes1, 'Box', 'on', 'Color', 'w', 'XTickLabel', '', 'YTickLabel', '');
set(handles.axes2, 'Box', 'on', 'Color', 'w', 'XTickLabel', '', 'YTickLabel', '');
set(handles.textResult, 'String', '');
% 更新句柄结构
guidata(hObject, handles);


% 此函数的输出返回到命令行.
function varargout = MainForm_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;



function pushbutton1_Callback(hObject, eventdata, handles)
% 获取人脸数据库
GetDatabase();
GaborDatabse();
PcaDataBase();
S = GetTrainData();
Elm_Type = 1;
NumberofHiddenNeurons = 200;
ActivationFunction = 'sin';
[TrainingTime,TrainingAccuracy] = elm_train(S, Elm_Type, ...
    NumberofHiddenNeurons, ActivationFunction);
msgbox('程序初始化完毕', '提示信息');


function pushbutton5_Callback(hObject, eventdata, handles)
% 载入待识别图像
% 载入图像
[FileName,PathName,FilterIndex] = uigetfile({'*.tiff;*.jpg;*.tif;*.png;*.gif','All Image Files';...
    '*.*','All Files' },'载入图像',...
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
% ELM分类识别
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
% 计算每幅测试图像的主成分,即计算它们在变换后坐标系上的投影，是1×p阶矩阵
tcoor = b*base;%
c = tcoor;
data = [1 c(:)'];
[~, ~,output1] = elm_predict(data, Img);
switch output1

    case 1
        str = '平静';
    case 2
        str = '高兴';
    case 3
        str = '悲伤';
    case 4
        str = '惊讶';
    case 5
        str = '愤怒';
    case 6
        str = '厌恶';
    case 7
        str = '恐惧';
    otherwise
        str = '平静';
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
% 提取gabor特征
[G,gabout] = gaborfilter(I,2,4,16,pi/3);
imshow(gabout, [], 'Parent', handles.axes2);
handles.G = gabout;
guidata(hObject, handles);


function pushbutton8_Callback(hObject, eventdata, handles)
% 退出系统
choice = questdlg('确定退出?', ...
    '退出', ...
    '是','否','取消','取消');
switch choice
    case '是'
        close;
end
