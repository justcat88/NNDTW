clear all
%% Obtain wavelet denoised Training data for ANN
train_data_ANN; %wdenoise package in the MATLAB should be installed


%% restructure the data : array{sensor}[obs X time] --> array{sensor}[time X obs]

tot_sens_num = 15;


Train_sensor=([(train_in_nor_1); (train_in_f_1)]);

Train_sensor = [ Train_sensor Train_sensor Train_sensor];

Train_label = ([(train_out_nor_1'); (train_out_f_1')]);


% 800 for scenio 13 sensor 5

%% Importing data

fire_scenario = X;

true_fire_time_info = load('true_fire_time_info'); 
true_fire_time_info = true_fire_time_info.true_fire_time_info;


train_index = [1 5 9 13];


test_index = [3 6 7 8  10 11 12 14 15 16];

%% Obtain testing observations

correct = 0; % Initialize the number we got correct
predicted_distance=[];
predicted_class=[];
win_size = 32;
starting_point = win_size+1;
predicted_class_sensor = [];
predicted_class_voting = [];

test_index = [3 6 7 8  10 11 12 14 15 16];


ft=[];
FAR=[];
FDR=[];
EFST=[];
FSTA=[];

Testing_time = [];
Testing_label = [];
te_data = [];
length(test_index);
for i = 1 : length(test_index) % Loop over every instance in the test set
    
    Testing=fire_scenario{test_index(i)};
    Testing_data = [];
    test_index(i);
    for tt=win_size:size(Testing, 1)
        Testing_data{tt-win_size+1} = Testing(((tt-win_size+1):tt),2:16);
        Testing_time{i}(tt-win_size+1) = Testing(tt,1); % Time start from zero
        Testing_label{i}(tt-win_size+1) = Testing(tt,17);
    end
    
     
%     vectorized observation for PNN
   for j = 1:size(Testing_data,2)
       te_data1=[];
       for q = 1:size(Testing_data{j}',1)
           q;
           te_data1= [te_data1 Testing_data{j}(:,q)'];       
       end
       te_data= [te_data ; te_data1];
   end

 end

te_data3={};
for i = 1 : length(Testing_time)
   i
   if i == 1
       
      er=size(Testing_time{i},2);
       ar= 0;
   
       te_data3{i}= te_data(ar+1:er,:);
   else
       er = er + size(Testing_time{i},2);
       ar = ar + size(Testing_time{i-1},2);
       te_data3{i} = te_data(ar+1:er,:);
   end
     
end

% For time saving, load the ANN_test_data_scenariowise file to obtain
% vectorized observation
%  te_data3 = load('ANN_test_data_scenariowise'); 
%  te_data3 = te_data3.te_data3;

%% Start NN algorithm
%training
P = Train_sensor';
Tc = Train_label';

Tc(Tc==1)=2;
Tc(Tc==0)=1;


T = ind2vec(Tc);

pnn_a_results = [];
pnn_afsta = [];
pnn_afar = [];

sig = 0.07;
    net = newpnn(P,T,sig);
    Y = sim(net,P);
    Yc = vec2ind(Y);

%testing
    NN_classification={}; 

    for j = 1:length(te_data3)
        P2 = [te_data3{j}]';
        Y2 = sim(net,P2);
        Y2c = vec2ind(Y2);
        
        Y2c(Y2c==1)=0;
        Y2c(Y2c==2)=1;
        NN_classification{j} = Y2c';
    end
    
%% obtaining result
    consec_num=10; %time points

    NN_classification_temp = NN_classification;

    for i = 1:length(te_data3)
        NN_classification_temp{i} = NN_classification{i}';
          
        ft(i) = find(Testing_time{i}==true_fire_time_info(test_index(i)));
    
        for ss = consec_num:length(Testing_time{i})
            if  consec_decision(NN_classification_temp{i}, consec_num, ss)==1 %If n consecutive point is classified as fire --> Fire
                break
            end
        end
        EFST(i) = Testing_time{i}(ss); %calaute estiamted starting time
        FSTA(i) = abs((true_fire_time_info(test_index(i)))-EFST(i)); % Fire Starting Time Accuracy 
        
        FAR(i) = sum(abs(Testing_label{i}(1:ft(i)-1) - NN_classification_temp{i}(1:ft(i)-1)))/(ft(i)-1); % False Alarm Rate
    end
    result = [EFST' FSTA' FAR'*100]; % Obtain results
    
    average_results = mean(result); % Obtain average of results from all scenario
    std_results = std(result); %  Obtain standard deviation of results from all scenario

    r = result;
    a = average_results;
    b = std_results;
    
    
    disp('PNN Method results')
    disp('        EFST        FSTA        FAR')
    disp('-----------------------------------')
    disp(round(r,2))
    disp('Average')
    disp(round(a,2))
    disp('Std')
    disp(round(b,2))
    disp('-----------------------------------')

 
        
        
