%% Importing data

fire_scenario = load('fire_scenario'); 
fire_scenario = fire_scenario.fire_scenario

true_fire_time_info = load('true_fire_time_info'); 
true_fire_time_info = true_fire_time_info.true_fire_time_info

non_fire_scenario = load('non_fire_scenario'); 
non_fire_scenario = non_fire_scenario.non_fire_scenario

train_index = [1 3 6 9 13 14];
test_index = [4 7 8 10 11 12 15 16];

%%
tot_sens_num = 15;

% Data Gathering
Train_in = {};
Train_out = {};
%[Train_in, Train_out] = train_data_fire(([1 3 6 9 13 14]), 2, 32, 1, 10, 60, 20, 15, 80);

sensor_num = 1;

[nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(1, 2, 32, 30, 30, 20, 20, 1000, 200, 3925, 100, sensor_num);

[nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire(1, 2, 32, 30, 30, 20, 20, 1000, 200, 3925, 100);
                         %train_data_fire(S, R, k,   n,  m, qq, z1, fe,   z2,   ff, z3 )
[nor_Train_in6, nor_Train_out6, f_Train_in6, f_Train_out6] = train_data_fire(6, 2, 32, 20, 20, 20, 20, 805, 100, 1500, 100);
[nor_Train_in13, nor_Train_out13, f_Train_in13, f_Train_out13] = train_data_fire(13, 2, 32, 20, 20, 20, 20, 729, 10, 800, 20);

% 
% [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire(1, 2, 32, 30, 30, 20, 20, 1000, 200, 3925, 100);
%                          %train_data_fire(S, R, k,   n,  m, qq, z1, fe,   z2,   ff, z3 )
% [nor_Train_in6, nor_Train_out6, f_Train_in6, f_Train_out6] = train_data_fire(6, 2, 32, 20, 20, 20, 20, 805, 100, 1500, 100);
% [nor_Train_in13, nor_Train_out13, f_Train_in13, f_Train_out13] = train_data_fire(13, 2, 32, 20, 20, 20, 20, 729, 10, 800, 20);
nor_tr_in = [nor_Train_in1, nor_Train_in6, nor_Train_in13];
nor_tr_out = [nor_Train_out1, nor_Train_out6, nor_Train_out13];
f_tr_in = [f_Train_in1, f_Train_in6, f_Train_in13];
f_tr_out = [f_Train_out1, f_Train_out6, f_Train_out13];
% 
% nor_tr_in = [nor_Train_in13];
% nor_tr_out = [nor_Train_out13];
% f_tr_in = [f_Train_in13];
% f_tr_out = [f_Train_out13];

%% 64 points
% [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire(1, 2, 64, 20, 20, 20, 20, 1000, 200, 3925, 140);
%                          %train_data_fire(S, R, k,   n,  m, qq, z1, fe,   z2,   ff, z3 )
% [nor_Train_in6, nor_Train_out6, f_Train_in6, f_Train_out6] = train_data_fire(6, 2, 64, 20, 20, 20, 20, 805, 100, 1500, 100);
% [nor_Train_in13, nor_Train_out13, f_Train_in13, f_Train_out13] = train_data_fire(13, 2, 64, 20, 20, 20, 20, 729, 10, 800, 16);
% 
% nor_tr_in = [nor_Train_in1, nor_Train_in6, nor_Train_in13];
% nor_tr_out = [nor_Train_out1, nor_Train_out6, nor_Train_out13];
% f_tr_in = [f_Train_in1, f_Train_in6, f_Train_in13];
% f_tr_out = [f_Train_out1, f_Train_out6, f_Train_out13];
%%





Train_sensor = []
for j=1:tot_sens_num
    for i = 1:size(nor_tr_in, 2)     
        Train_sensor{j}(i, :) = nor_tr_in{i}(:, j+1)   % Total s array where s is totoal number of sensors which consist nxt where n: number of observtaion, t time points 
    end
end

for j=1:tot_sens_num
    for i = 1:size(f_tr_in, 2)     
        Train_sensor{j}(i+(size(nor_tr_in, 2)), :) = f_tr_in{i}(:, j+1)
    end
end

Train_normal_label = []
for i = 1:size(nor_tr_out, 2)
    Train_normal_label(i) = nor_tr_out{i}   % Total s array where s is totoal number of sensors which consist nxt where n: number of observtaion, t time points
end

Train_abnormal_label = []
for i = 1:size(f_tr_out, 2)
    Train_abnormal_label(i) = f_tr_out{i}   % Total s array where s is totoal number of sensors which consist nxt where n: number of observtaion, t time points
end


Train_label =[Train_normal_label  Train_abnormal_label]'


%%
correct = 0; % Initialize the number we got correct
predicted_distance=[]
predicted_class=[]
win_size = 32
starting_point = win_size+1
voting_num=1
consec_num=1

predicted_class_sensor = []
predicted_class_voting = []




ft=[]
FAR=[]
FDR=[]
EFST=[]
FSTA=[]

for i = 1 : length(test_index) % Loop over every instance in the test set
    
    Testing=fire_scenario{test_index(i)};
    Testing_time = []
    Testing_data = []
    Testing_label = []
    
    for tt=win_size:size(Testing, 1)
        Testing_data{tt-win_size+1} = Testing(((tt-win_size+1):tt),2:16);
        Testing_time(tt-win_size+1) = Testing(tt,1); % Time start from zero
        Testing_label(tt-win_size+1) = Testing(tt,17);
    end
    
    
    for t = 1:length(Testing_time)
        for j = 1:tot_sens_num
            classify_this_object = Testing_data{t}(:, j)';
            this_objects_actual_class = Testing_label(t);
            %[predicted_distance(:,t), predicted_class(t)] = Classification_Algorithm_ED(Train_sensor{j},Train_label, classify_this_object); % Euclidean distance
       
            [predicted_distance(:,t), predicted_class(t)] = Classification_Algorithm_DTW(Train_sensor{j},Train_label, classify_this_object); % Euclidean distance

            predicted_class_sensor{i}(t, j)=predicted_class(t);
        end
        
        if sum(predicted_class_sensor{i}(t, :))>=voting_num
            predicted_class_voting{i}(t) = 1;
        else
            predicted_class_voting{i}(t) = 0;
        end  
        
    end
    
    ft(i) = find(Testing_time==true_fire_time_info(test_index(i)))
    
   FAR(i)=sum(abs(Testing_label - predicted_class_voting{i}))/length(Testing_time)  %False alarm rate
   
   FDR(i) = 1-(sum(abs(Testing_label(ft(i):end) - predicted_class_voting{i}(ft(i):end)))/length(Testing_time(ft(i):end))) %Detection rate
    
    
    for ss = consec_num:length(Testing_time)
        if  consec_decision(predicted_class_voting{i}, consec_num, ss)==1 %If n consecutive point is classified as fire --> Fire
            break
        end
    end
    EFST(i) = Testing_time(ss)
    FSTA(i) = abs(ft(i)-EFST(i))
     
end







