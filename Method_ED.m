clear all
%% Obtain training data
train_data_sensor_200obs;

%% restructure the data : array{sensor}[obs X time] --> array{sensor}[time X obs]

tot_sens_num = 15;


Train_sensor = [];

for i =1:5
    Train_sensor{i}=[train_in_nor_1{i}; train_in_f_1{i}] ;

end


Train_sensor = [Train_sensor Train_sensor Train_sensor]; %Final Training dataset

Train_label = [train_out_nor_1{1}'; train_out_f_1{1}']; %Training datset label





%% Importing data

fire_scenario = load('fire_scenario'); %Load fire scenarios
fire_scenario = fire_scenario.fire_scenario; 

true_fire_time_info = load('true_fire_time_info'); %Load true fire starting time for each scenario
true_fire_time_info = true_fire_time_info.true_fire_time_info;

train_index = [1 5 9 13]; % Scenario index that are using for training dataset
test_index = [3 6 7 8 10 11 12 14 15 16]; % Scenario index that are using for testing dataset



%% Run ED-NN method

% Parameters setting
win_size = 32; % Size of the window (= # of past data +1 that we are using) 


% Initialize variables
predicted_distance=[];
predicted_class=[];
predicted_class_sensor = [];
predicted_class_voting = [];
idx=[];
ft=[];
FAR=[];
FDR=[];
EFST=[];
FSTA=[];
Testing_time = [];
Testing_label = [];
predicted_distance=[];

for i = 1 : length(test_index) % Loop over every instance in the test set
    
    Testing=fire_scenario{test_index(i)};
    Testing_data = [];
    for tt=win_size:size(Testing, 1)
        Testing_data{tt-win_size+1} = Testing(((tt-win_size+1):tt),2:16);
        Testing_time{i}(tt-win_size+1) = Testing(tt,1); % Time start from zero
        Testing_label{i}(tt-win_size+1) = Testing(tt,17);
    end
%end

    for t = 1:length(Testing_time{i})
        for j = 1:tot_sens_num
            classify_this_object = Testing_data{t}(:, j)';
            this_objects_actual_class = Testing_label{i}(t);
            [predicted_distance{i}(:,t), predicted_class(t) , idx{i}(t, j)] = Classification_Algorithm_ED(Train_sensor{j},Train_label, classify_this_object); % Using Euclidean distance

            predicted_class_sensor{i}(t, j)=predicted_class(t);
        end      
    end
    
   i;
     
end


%% obtaining results

voting_num=3; % k-out-of-15 voting rules
consec_num=10; % q-consecutive time


for i = 1:length(test_index)
    
    for t = 1:length(Testing_time{i})
        if sum(predicted_class_sensor{i}(t, :))>=voting_num
            predicted_class_voting{i}(t) = 1;
        else
            predicted_class_voting{i}(t) = 0;
        end
    end
    
    ft(i) = find(Testing_time{i}==true_fire_time_info(test_index(i)));
    
    FAR(i) = (sum(abs(Testing_label{i}(1:ft(i)-1) - predicted_class_voting{i}(1:ft(i)-1)))/length(Testing_time{i}(1:ft(i)-1))); %False alarm rate
    
    for ss = consec_num:length(Testing_time{i})
        if  consec_decision(predicted_class_voting{i}, consec_num, ss)==1 %If n consecutive point is classified as fire --> Fire
            break
        end
    end
    EFST(i) = Testing_time{i}(ss); % Estimated Fire Starting Time
    FSTA(i) = abs(true_fire_time_info(test_index(i))-EFST(i)); % Fire Starting Time Accuracy 
end
result = [EFST' FSTA' FAR'*100]; % Obtain result

average_results = mean(result); % Average of results from all scenarios
std_results = std(result); % Standard Deviation of results from all scenarios

    r = result;
    a = average_results;
    b = std_results;
    
    
    disp('ED-NN Method results')
    disp('        EFST        FSTA        FAR')
    disp('-----------------------------------')
    disp(round(r,2))
    disp('Average')
    disp(round(a,2))
    disp('Std')
    disp(round(b,2))
    disp('-----------------------------------')

%% k and q optimization

%performance_result = [];
%performance_av_result =[];
%performance_FSTA_result=[];
%performance_MCR_result=[];
%performance_FDR_result=[];
%performance_FAR_result=[];

%for s_num = 1:15
%    for  c_num=1:30
%        
%        voting_num=s_num
%        consec_num=c_num
%        for i = 1:length(test_index)
%            
%            for t = 1:length(Testing_time{i})
%                if sum(predicted_class_sensor{i}(t, :))>=voting_num
%                    predicted_class_voting{i}(t) = 1;
%                else
%                    predicted_class_voting{i}(t) = 0;
%                end
%           end
            
%            ft(i) = find(Testing_time{i}==true_fire_time_info(test_index(i)));
%            
%            FAR(i) = (sum(abs(Testing_label{i}(1:ft(i)-1) - predicted_class_voting{i}(1:ft(i)-1)))/length(Testing_time{i}(1:ft(i)-1))); %Fire Detection rate

         
%            for ss = consec_num:length(Testing_time{i})
%                if  consec_decision(predicted_class_voting{i}, consec_num, ss)==1 %If n consecutive point is classified as fire --> Fire
%                    break
%                end
%            end
%            EFST(i) = Testing_time{i}(ss);
%            FSTA(i) = abs(true_fire_time_info(test_index(i))-EFST(i));
            
%        end
%        result = [EFST' FSTA' FAR'*100] % Obtain result
%        av_result = mean(result);
%        performance_result{s_num, c_num} = result;
%        performance_av_result{s_num, c_num} = av_result;
%        performance_FSTA_result(s_num, c_num) = av_result(2);
%        performance_FAR_result(s_num, c_num) = av_result(3);

%    end
%end

%figure


%plot(performance_FAR_result(:, 1),'-','color','k', 'LineWidth',1.0, 'DisplayName','FAR')
%        legend
%        ylim([0 50]);
%        xlim([1 15]);
%        title('Effect of parameter k on FAR ','FontSize',12)
%        xlabel('k','FontSize',11)
%        ylabel('FAR (%)','FontSize',11)

%figure        
%plot(performance_FSTA_result(:, 3),'-','color','k', 'LineWidth',1.0, 'DisplayName','FSTA')
%legend
%        xlim([1 15]);
%        title('Effect of parameter k on FSTA ','FontSize',12)
%        xlabel('k','FontSize',11)
%        ylabel('FSTA (min.)','FontSize',11)
        

