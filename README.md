# Facial_Expression 😁😡🙁😖
Expression is the main communication method for human beings in addition to language, and it is an important way for human beings to express their inner emotions. It contains extremely rich behavioral information. This project realizes the recognition of static expressions, and draws the GUI interface based on Matlab.

## Enviroment

1. **Operation System**: macOS or Win
2. **Development Platform**: >= Matlab2019
3. **Language**: Matlab
4. **Dataset**: JAFFE

## Content

1. This project uses the JAFFE database. There are a total of 213 images in the entire database. There are 10 people, all of them are women. Each person makes 7 kinds of expressions. The 7 kinds of expressions are: sad, happy, angry, disgust, surprise, fear, neutral.
2. Because the Gabor feature has good robustness to interference factors, the spatial locality and direction selectivity of the Gabor feature enable it to fully describe the texture information of the image.


Part of the code:
```
...
load S.mat
%h = waitbar(0,'已处理......', 'Name', 'Gabor 特征提取');
steps = length(S); 
for step = 1 : steps
	% waitbar(step/steps,h,sprintf('已处理%d%%',round(step/steps*100))); 
	file = S(step).filename; 
	fileIn = sprintf('Database/%s', file); 
	fileIn = fullfile(pwd, fileIn); 
	Img = imread(fileIn); 
	if ndims(Img) == 3 
		I = rgb2gray(Img); 
	else 
		I = Img; 
	end 
	% 提取 gabor 特征 
	[G,gabout] = gaborfilter(I,2,4,16,pi/3); 
	% 写出特征 
	[pathstr, name, ext] = fileparts(file); 
	fileOut = sprintf('GaborDatabse/%s.jpg', name); 
	fileOut = fullfile(pwd, fileOut); 
	imwrite(gabout, fileOut); 
	S(step).Gfile = fileOut;
end 
...
```


3. The training model of this project adopts ELM. Extreme learning machine is a fast learning algorithm, in a single hidden layer neural network, it can randomly initialize the input weights and biases and get the corresponding output weights.

Part of the code:
```
... 
InputWeight=rand(NumberofHiddenNeurons,NumberofInputNeurons)*2-1; 
%%将输入权值系数以及隐含层阈值用随机值初始化 BiasofHiddenNeurons=rand(NumberofHiddenNeurons,1); 
tempH=InputWeight*P; %%使用训练样本输入数据计算隐含层输入 
clear P; 
ind=ones(1,NumberofTrainingData); 
BiasMatrix=BiasofHiddenNeurons(:,ind); 
tempH=tempH+BiasMatrix; %%将隐含层输入减去阈值

%%%%%%%%%%% Calculate hidden neuron output matrix H 
switch lower(ActivationFunction) %%加入激活函数计算隐含层输出 
	case {'sig','sigmoid'} 
		%%%%%%%% Sigmoid 
		H = 1 ./ (1 + exp(-tempH)); 
	case {'sin','sine'} 
		%%%%%%%% Sine 
		H = sin(tempH); 
	case {'hardlim'} 
		%%%%%%%% Hard Limit 
		H = hardlim(tempH); 
		%%%%%%%% More activation functions can be added here
end 
clear tempH;

%%%%%%%%%%% Calculate output weights OutputWeight (beta_i)
OutputWeight=pinv(H') * T'; %%通过期望输出反向计算隐含层到输出层权值系数
end_time_train=cputime; %%获取网络训练结束时间 
TrainingTime=end_time_train-start_time_train; %%计算网络训练时长

%%%%%%%%%%% Calculate the training accuracy 
Y=(H' * OutputWeight)'; %%计算神经网络分类实际值 
if Elm_Type == REGRESSION
	TrainingAccuracy=sqrt(mse(T - Y));
	output=Y; 
end 
clear H; 
...
```

4. The GUI design mainly uses the GUI interface function that comes with Matlab, which can be called up by entering `guide` on the command line.

Part of the code:
```
...
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
...
```

## Result
1. GUI interface rendered after running. It has two display boxes and five buttons

2. When we do the initialization procedure, the confusion matrix will appear in the display box on the left.

3. After performing the operation of selecting an image, we can select an image from the `/test/`, and we can get this picture.

4. Then perform Garbor feature extraction, we can get this picture.

5. Finally, we can get the color image output result.


## More

If you want to know more about this code, you can click the detailed explanation of this code or contact me via the link above.😊
