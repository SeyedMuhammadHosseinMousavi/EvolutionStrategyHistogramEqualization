
%% Evolution Strategy Algorithm Histogram Equalization - Created in 18 Jan 2022 by Seyed Muhammad Hossein Mousavi
% These lines of code apply Evolution Strategy algorithm on input
% argument of "target histogram" in Histogram Equalization function in
% order to fit the model in an evolutionary form. System uses some pre and
% post processing techniques which could be used as an image enhancement
% method. Obviously, you can use your own image and play with parameters
% depending on your desire. This code is suitable for medical purposes as
% reveals some veins and tissues in low and high quality images.
% ------------------------------------------------ 
% Feel free to contact me if you find any problem using the code: 
% Author: SeyedMuhammadHosseinMousavi
% My Email: mosavi.a.i.buali@gmail.com 
% My Google Scholar: https://scholar.google.com/citations?user=PtvQvAQAAAAJ&hl=en 
% My GitHub: https://github.com/SeyedMuhammadHosseinMousavi?tab=repositories 
% My ORCID: https://orcid.org/0000-0001-6906-2152 
% My Scopus: https://www.scopus.com/authid/detail.uri?authorId=57193122985 
% My MathWorks: https://www.mathworks.com/matlabcentral/profile/authors/9763916#
% my RG: https://www.researchgate.net/profile/Seyed-Mousavi-17
% ------------------------------------------------ 
% Hope it help you, enjoy the code and wish me luck :)

%% Clearing Things
clc
clear
close all
warning ('off');

%% Loading Data
img=imread('lung.jpg');
img=rgb2gray(img);
% Target Histogram
Data=[0,1,3,5,7,9,10,11,12,13,15,17,19,20,22,8,9,10,1,3,6,33,34,35,2];
% Creating Inputs and Targets
Delays = [1];
Data=Data';
[Inputs, Targets] = CreateTargets(Data',Delays);
data.Inputs=Inputs;
data.Targets=Targets;
% Making Data
Inputs=data.Inputs';
Targets=data.Targets';
Targets=Targets(:,1);
nSample=size(Inputs,1);
% Creating Train Vector
pTrain=1.0;
nTrain=round(pTrain*nSample);
TrainInputs=Inputs(1:nTrain,:);
TrainTargets=Targets(1:nTrain,:);
% Making Final Data Struct
data.TrainInputs=TrainInputs;
data.TrainTargets=TrainTargets;
% Making Data
Inputs=data.Inputs';
Targets=data.Targets';
Targets=Targets(:,1);
nSample=size(Inputs,1);
% Creating Train Vector
pTrain=1.0;
nTrain=round(pTrain*nSample);
TrainInputs=Inputs(1:nTrain,:);
TrainTargets=Targets(1:nTrain,:);
% Making Final Data Struct
data.TrainInputs=TrainInputs;
data.TrainTargets=TrainTargets;
%% Basic Fuzzy Model Creation 
% Number of Clusters in FCM
ClusNum=2;
% Creating FIS
fis=GenerateFuzzy(data,ClusNum);

%% Tarining Evolution Strategy Algorithm
ESAlgorithmFis = ESFCN(fis,data); 

%% Train Output Extraction
TrTar=data.TrainTargets;
TrainOutputs=evalfis(data.TrainInputs,ESAlgorithmFis);
% Train calculation
Errors=data.TrainTargets-TrainOutputs; 
r0 = -1 ;
r1 = +1 ;
range = max(Errors) - min(Errors);
Errors = (Errors - min(Errors)) / range;
range2 = r1-r0;
Errors = (Errors * range2) + r0;
MSE=mean(Errors.^2);
RMSE=sqrt(MSE);  
error_mean=mean(Errors);
error_std=std(Errors);
%% Results 
% Basic Histogram Equalization
[basiceq T1] = histeq(img);
% Pre-processing
medfilt = imsharpen(medfilt2(img,[4 4],'symmetric'));
% Evolution Strategy Histogram Equalization
[HisEq, T] = histeq(medfilt,TrainOutputs);
% Fast Local Laplacian Filtering Post-Processing
sigma = 0.2;
alpha = 2.0;
numLevels = 7;
B = imadjust(locallapfilt(HisEq, sigma, alpha, 'NumIntensityLevels', numLevels));
% Plot Results
figure('units','normalized','outerposition',[0 0 1 1])
subplot(2,3,1)
subimage(basiceq);title('Basic Histogram Equalization');
subplot(2,3,2)
subimage(B);title('ES Histogram Equalization');
subplot(2,3,3)
imhist(basiceq,128);title('Basic Image Histogram ');
subplot(2,3,4)
imhist(HisEq,128);title('ES Image Histogram ');
subplot(2,3,5)
plot((0:255)/255,T);title('Basic Transformation Curve');
subplot(2,3,6)
plot((0:255)/255,T1);title('ES Transformation Curve');
figure;
montage({basiceq,B});
