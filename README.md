# Facial_Expression ππ‘ππ
Expression is the main communication method for human beings in addition to language, and it is an important way for human beings to express their inner emotions. It contains extremely rich behavioral information. This project realizes the recognition of static expressions, and draws the GUI interface based on Matlab.

## Enviroment

1. **Operation System**: macOS or Win
2. **Development Platform**: >= Matlab2019
3. **Language**: Matlab
4. **Dataset**: JAFFE

## Content

1. This project uses the JAFFE database. There are a total of 213 images in the entire database. There are 10 people, all of them are women. Each person makes 7 kinds of expressions. The 7 kinds of expressions are: sad, happy, angry, disgust, surprise, fear, neutral.

<img src="https://github.com/QiTianyu-0403/Facial_Expression/blob/main/pic/1.png" width="600" >

2. Because the Gabor feature has good robustness to interference factors, the spatial locality and direction selectivity of the Gabor feature enable it to fully describe the texture information of the image.

<img src="https://github.com/QiTianyu-0403/Facial_Expression/blob/main/pic/2.png" width="500" >

Part of the code:
```
...
load S.mat
%h = waitbar(0,'ε·²ε€η......', 'Name', 'Gabor ηΉεΎζε');
steps = length(S); 
for step = 1 : steps
	% waitbar(step/steps,h,sprintf('ε·²ε€η%d%%',round(step/steps*100))); 
	file = S(step).filename; 
	fileIn = sprintf('Database/%s', file); 
	fileIn = fullfile(pwd, fileIn); 
	Img = imread(fileIn); 
	if ndims(Img) == 3 
		I = rgb2gray(Img); 
	else 
		I = Img; 
	end 
	% ζε gabor ηΉεΎ 
	[G,gabout] = gaborfilter(I,2,4,16,pi/3); 
	% εεΊηΉεΎ 
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
%%ε°θΎε₯ζεΌη³»ζ°δ»₯ειε«ε±ιεΌη¨ιζΊεΌεε§ε BiasofHiddenNeurons=rand(NumberofHiddenNeurons,1); 
tempH=InputWeight*P; %%δ½Ώη¨θ?­η»ζ ·ζ¬θΎε₯ζ°ζ?θ?‘η?ιε«ε±θΎε₯ 
clear P; 
ind=ones(1,NumberofTrainingData); 
BiasMatrix=BiasofHiddenNeurons(:,ind); 
tempH=tempH+BiasMatrix; %%ε°ιε«ε±θΎε₯εε»ιεΌ

%%%%%%%%%%% Calculate hidden neuron output matrix H 
switch lower(ActivationFunction) %%ε ε₯ζΏζ΄»ε½ζ°θ?‘η?ιε«ε±θΎεΊ 
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
OutputWeight=pinv(H') * T'; %%ιθΏζζθΎεΊεεθ?‘η?ιε«ε±ε°θΎεΊε±ζεΌη³»ζ°
end_time_train=cputime; %%θ·εη½η»θ?­η»η»ζζΆι΄ 
TrainingTime=end_time_train-start_time_train; %%θ?‘η?η½η»θ?­η»ζΆιΏ

%%%%%%%%%%% Calculate the training accuracy 
Y=(H' * OutputWeight)'; %%θ?‘η?η₯η»η½η»εη±»ε?ιεΌ 
if Elm_Type == REGRESSION
	TrainingAccuracy=sqrt(mse(T - Y));
	output=Y; 
end 
clear H; 
...
```

4. The GUI design mainly uses the GUI interface function that comes with Matlab, which can be called up by entering `guide` on the command line.

<img src="https://github.com/QiTianyu-0403/Facial_Expression/blob/main/pic/3.png" width="600" >

Part of the code:
```
...
function pushbutton1_Callback(hObject, eventdata, handles) 
% θ·εδΊΊθΈζ°ζ?εΊ 
GetDatabase(); 
GaborDatabse(); 
PcaDataBase(); 
S = GetTrainData(); 
Elm_Type = 1; 
NumberofHiddenNeurons = 200; 
ActivationFunction = 'sin'; 
[TrainingTime,TrainingAccuracy] = elm_train(S, Elm_Type, ...
	NumberofHiddenNeurons, ActivationFunction); 
msgbox('η¨εΊεε§εε?ζ―', 'ζη€ΊδΏ‘ζ―'); 
...
```

## Result
1. GUI interface rendered after running. It has two display boxes and five buttons

<img src="https://github.com/QiTianyu-0403/Facial_Expression/blob/main/pic/4.png" width="600" >

2. When we do the initialization procedure, the confusion matrix will appear in the display box on the left.

<img src="https://github.com/QiTianyu-0403/Facial_Expression/blob/main/pic/5.png" width="600" >

3. After performing the operation of selecting an image, we can select an image from the `/test/`, and we can get this picture.

<img src="https://github.com/QiTianyu-0403/Facial_Expression/blob/main/pic/6.png" width="600" >

4. Then perform Garbor feature extraction, we can get this picture.

<img src="https://github.com/QiTianyu-0403/Facial_Expression/blob/main/pic/7.png" width="600" >

5. Finally, we can get the color image output result.

<img src="https://github.com/QiTianyu-0403/Facial_Expression/blob/main/pic/8.png" width="600" >

<img src="https://github.com/QiTianyu-0403/Facial_Expression/blob/main/pic/9.png" width="450" >

## More

If you want to know more about this code, you can click [the detailed explanation](https://zhuanlan.zhihu.com/p/482125899) of this code or contact me via the link above.π
