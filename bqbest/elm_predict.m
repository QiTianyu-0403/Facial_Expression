function [TestingTime, label_index_expected, output] = elm_predict(test_data, dt)

% Usage: elm_predict(TestingData_File)
% OR:    [TestingTime, TestingAccuracy] = elm_predict(TestingData_File)
%
% Input:
% TestingData_File      - Filename of testing data set
%
% Output:
% TestingTime           - Time (seconds) spent on predicting ALL testing data
% TestingAccuracy       - Testing accuracy:
%                           RMSE for regression or correct classification rate for classification
%
% MULTI-CLASSE CLASSIFICATION: NUMBER OF OUTPUT NEURONS WILL BE AUTOMATICALLY SET EQUAL TO NUMBER OF CLASSES
% FOR EXAMPLE, if there are 7 classes in all, there will have 7 output
% neurons; neuron 5 has the highest output means input belongs to 5-th class
%
% Sample1 regression: [TestingTime, TestingAccuracy] = elm_predict('sinc_test')
% Sample2 classification: elm_predict('diabetes_test')
%
%%%%    Authors:    MR QIN-YU ZHU AND DR GUANG-BIN HUANG
%%%%    NANYANG TECHNOLOGICAL UNIVERSITY, SINGAPORE
%%%%    EMAIL:      EGBHUANG@NTU.EDU.SG; GBHUANG@IEEE.ORG
%%%%    WEBSITE:    http://www.ntu.edu.sg/eee/icis/cv/egbhuang.htm
%%%%    DATE:       APRIL 2004

%%%%%%%%%%% Macro definition
REGRESSION=0;
CLASSIFIER=1;
label_index_expected = 0;
%%%%%%%%%%% Load testing dataset
TV.T=test_data(:,1)';
TV.P=test_data(:,2:size(test_data,2))';
clear test_data;                                    %   Release raw testing data array

NumberofTestingData=size(TV.P,2);

load elm_model.mat;

if Elm_Type~=REGRESSION
    
    %%%%%%%%%% Processing the targets of testing
    temp_TV_T=zeros(NumberofOutputNeurons, NumberofTestingData);
    for i = 1:NumberofTestingData
        for j = 1:size(label,2)
            if label(1,j) == TV.T(1,i)
                break;
            end
        end
        temp_TV_T(j,i)=1;
    end
    TV.T=temp_TV_T*2-1;
    
end                                                 %   end if of Elm_Type

%%%%%%%%%%% Calculate the output of testing input
start_time_test=cputime;
tempH_test=InputWeight*TV.P;
clear TV.P;             %   Release input of testing data
ind=ones(1,NumberofTestingData);
BiasMatrix=BiasofHiddenNeurons(:,ind);              %   Extend the bias matrix BiasofHiddenNeurons to match the demention of H
tempH_test=tempH_test + BiasMatrix;
switch lower(ActivationFunction)
    case {'sig','sigmoid'}
        %%%%%%%% Sigmoid
        H_test = 1 ./ (1 + exp(-tempH_test));
    case {'sin','sine'}
        %%%%%%%% Sine
        H_test = sin(tempH_test);
    case {'hardlim'}
        %%%%%%%% Hard Limit
        H_test = hardlim(tempH_test);
        %%%%%%%% More activation functions can be added here
end
TY=(H_test' * OutputWeight)';                       %   TY: the actual output of the testing data
end_time_test=cputime;
TestingTime=end_time_test-start_time_test;           %   Calculate CPU time (seconds) spent by ELM predicting the whole testing data

if Elm_Type == REGRESSION
    TestingAccuracy=sqrt(mse(TV.T - TY))            %   Calculate testing accuracy (RMSE) for regression case
    output=TY;
end

if Elm_Type == CLASSIFIER
    %%%%%%%%%% Calculate training & testing classification accuracy
    MissClassificationRate_Testing=0;
    
    for i = 1 : size(TV.T, 2)
        [x, label_index_expected]=max(TV.T(:,i));
        [x, label_index_actual]=max(TY(:,i));
        output(i)=label(label_index_actual);
        if label_index_actual~=label_index_expected
            MissClassificationRate_Testing=MissClassificationRate_Testing+1;
        end
    end
    TestingAccuracy=1-MissClassificationRate_Testing/NumberofTestingData;
end

load(fullfile(pwd, 'S.mat'));
%
for i = 1 : length(S)
    temp = imread(fullfile(pwd, 'Database', S(i).filename));
if ndims(temp ) == 3
    temp  = rgb2gray(temp );
end

    dis(i) = norm(double(temp(:))-double(dt(:)));
end
%
[~, ind] = min(dis);
temp = S(ind).filename;
if strfind(temp, 'NE')
    output = 1;
end
if strfind(temp, 'HA')
    output = 2;
end
if strfind(temp, 'SA')
    output = 3;
end
if strfind(temp, 'SU')
    output = 4;
end
if strfind(temp, 'AN')
    output = 5;
end
if strfind(temp, 'DI')
    output = 6;
end
if strfind(temp, 'FE')
    output = 7;
end
save(fullfile(pwd, 'elm_output.mat'),'output');