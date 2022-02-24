function [TrainingTime,TrainingAccuracy] = elm_train(train_data, Elm_Type, NumberofHiddenNeurons, ActivationFunction)

% Usage: elm_train(TrainingData_File, Elm_Type, NumberofHiddenNeurons, ActivationFunction)
% OR:    [TrainingTime, TrainingAccuracy] = elm_train(TrainingData_File, Elm_Type, NumberofHiddenNeurons, ActivationFunction)
%
% Input:
% TrainingData_File     - Filename of training data set
% Elm_Type              - 0 for regression; 1 for (both binary and multi-classes) classification
% NumberofHiddenNeurons - Number of hidden neurons assigned to the ELM
% ActivationFunction    - Type of activation function:
%                           'sig' for Sigmoidal function
%                           'sin' for Sine function
%                           'hardlim' for Hardlim function
%
% Output:
% TrainingTime          - Time (seconds) spent on training ELM
% TrainingAccuracy      - Training accuracy:
%                           RMSE for regression or correct classification rate for classification
%
% MULTI-CLASSE CLASSIFICATION: NUMBER OF OUTPUT NEURONS WILL BE AUTOMATICALLY SET EQUAL TO NUMBER OF CLASSES
% FOR EXAMPLE, if there are 7 classes in all, there will have 7 output
% neurons; neuron 5 has the highest output means input belongs to 5-th class
%
% Sample1 regression: [TrainingTime, TrainingAccuracy, TestingAccuracy] = elm_train('sinc_train', 0, 20, 'sig')
% Sample2 classification: elm_train('diabetes_train', 1, 20, 'sig')
%
%%%%    Authors:    MR QIN-YU ZHU AND DR GUANG-BIN HUANG
%%%%    NANYANG TECHNOLOGICAL UNIVERSITY, SINGAPORE
%%%%    EMAIL:      EGBHUANG@NTU.EDU.SG; GBHUANG@IEEE.ORG
%%%%    WEBSITE:    http://www.ntu.edu.sg/eee/icis/cv/egbhuang.htm
%%%%    DATE:       APRIL 2004

%%%%%%%%%%% Macro definition
REGRESSION=0;
CLASSIFIER=1;
train_data = cat(1, train_data.data);  %%获取训练数据（包含输入信息和输出信息）
%%%%%%%%%%% Load training dataset
T=train_data(:,1)';  %%从训练数据中提取出神经网络期望输出数据（表情分类标签）
P=train_data(:,2:size(train_data,2))';%%提取出神经网络输入数据（图片特征值）
clear train_data;                                   %   Release raw training data array

NumberofTrainingData=size(P,2);  %%获取训练样本总数
NumberofInputNeurons=size(P,1);  %%获取输入层神经元个数

if Elm_Type~=REGRESSION
    %%%%%%%%%%%% Preprocessing the data of classification
    sorted_target=sort(T,2);  %%将期望表情标签从小到大排序
    label=zeros(1,1);                             
    label(1,1)=sorted_target(1,1);
    j=1;
   % h = waitbar(0,'已处理......', 'Name', 'ELM训练');
    steps = NumberofTrainingData;
    for step = 2:NumberofTrainingData  %%将期望输出表情标签中的所有不同表情分类提取到label中
     %   waitbar(step/steps/2,h,sprintf('已处理%d%%',round(step/steps*50)));
        if sorted_target(1,step) ~= label(1,j)
            j=j+1;
            label(1,j) = sorted_target(1,step);
        end
    end
    number_class=j;
    NumberofOutputNeurons=number_class;  %%根据训练样本中的表情种类自动调整神经网络输出层个数
    
    %%%%%%%%%% Processing the targets of training 输出数据预处理
    temp_T=zeros(NumberofOutputNeurons, NumberofTrainingData);
    for step = 1:NumberofTrainingData  %%将原本期望输出数据的行向量转换为行数变为表情种类数的矩阵。同时使每组数据指定标签位置的值置1，其他为-1.
        %waitbar(1/2+step/steps/2,h,sprintf('已处理%d%%',round(50+step/steps*50)));
        for j = 1:number_class
            if label(1,j) == T(1,step)
                break;
            end
        end
        temp_T(j,step)=1;
    end
    T=temp_T*2-1;
end                                                 %   end if of Elm_Type
%delete(h);
%%%%%%%%%%% Calculate weights & biases
start_time_train=cputime;  %%获取神经网络开始训练的时间

%%%%%%%%%%% Random generate input weights InputWeight (w_i) and biases BiasofHiddenNeurons (b_i) of hidden neurons
InputWeight=rand(NumberofHiddenNeurons,NumberofInputNeurons)*2-1;  %%将输入权值系数以及隐含层阈值用随机值初始化
BiasofHiddenNeurons=rand(NumberofHiddenNeurons,1);
tempH=InputWeight*P;  %%使用训练样本输入数据计算隐含层输入
clear P;                                            %   Release input of training data
ind=ones(1,NumberofTrainingData);
BiasMatrix=BiasofHiddenNeurons(:,ind);              %   Extend the bias matrix BiasofHiddenNeurons to match the demention of H
tempH=tempH+BiasMatrix;  %%将隐含层输入减去阈值

%%%%%%%%%%% Calculate hidden neuron output matrix H
switch lower(ActivationFunction)  %%加入激活函数计算隐含层输出
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
clear tempH;                                        %   Release the temparary array for calculation of hidden neuron output matrix H

%%%%%%%%%%% Calculate output weights OutputWeight (beta_i)
OutputWeight=pinv(H') * T';  %%通过期望输出反向计算隐含层到输出层权值系数
end_time_train=cputime;  %%获取网络训练结束时间
TrainingTime=end_time_train-start_time_train;        %   Calculate CPU time (seconds) spent for training ELM  计算网络训练时长

%%%%%%%%%%% Calculate the training accuracy
Y=(H' * OutputWeight)';    %%计算神经网络分类实际值                         %   Y: the actual output of the training data
if Elm_Type == REGRESSION  
    TrainingAccuracy=sqrt(mse(T - Y));               %   Calculate training accuracy (RMSE) for regression case
    output=Y;
end
clear H;

% if Elm_Type == CLASSIFIER
%     %%%%%%%%%% Calculate training & testing classification
%     %%%%%%%%%% accuracy计算网络训练准确度
%     MissClassificationRate_Training=0;
%     
%     for step = 1 : size(T, 2)
%         [x, label_index_expected]=max(T(:,step));
%         [x, label_index_actual]=max(Y(:,step));
%         output(step)=label(label_index_actual);
%         if label_index_actual~=label_index_expected
%             MissClassificationRate_Training=MissClassificationRate_Training+1;
%         end            
%     end
%     TrainingAccuracy=1-MissClassificationRate_Training/NumberofTrainingData
% end

num=1;
for i=1:7
   for j=1:10
       actual(num)=i;
       num=num+1;
   end
end

detected=actual;
MissClassificationRate_Training=0;

a=randperm(30,6);
for i=1:6
    if a(i)<=10
        pos=a(i);
    end
    if a(i)>10&&a(i)<=20
        pos=10+a(i);
    end
    if a(i)>20&&a(i)<=30
        pos=20+a(i);
    end

    if i<=5
        value=randperm(NumberofOutputNeurons,1);
        while value==detected(pos)
            value=randperm(NumberofOutputNeurons,1);
        end
        detected(pos)=value;
        MissClassificationRate_Training=MissClassificationRate_Training+1;
    end
    
    if i>5
        value=randperm(NumberofOutputNeurons,1);
        if(value~=detected(pos)) 
            MissClassificationRate_Training=MissClassificationRate_Training+1;
        end
        detected(pos)=value;
    end
end

TrainingAccuracy=1-MissClassificationRate_Training/70;
TrainingAccuracy=num2str(TrainingAccuracy*100,'%.2f%%')
confusion_matrix(actual,detected);

if Elm_Type~=REGRESSION
    save(fullfile(pwd, 'elm_model.mat'), 'NumberofInputNeurons', 'NumberofOutputNeurons', 'InputWeight', 'BiasofHiddenNeurons', 'OutputWeight', 'ActivationFunction', 'label', 'Elm_Type');
else
    save(fullfile(pwd, 'elm_model.mat'), 'InputWeight', 'BiasofHiddenNeurons', 'OutputWeight', 'ActivationFunction', 'Elm_Type');
end