clear all
%% Obtain Training data
train_data_sensor_200obs;



%% restructure the data : array{sensor}[obs X time] --> array{sensor}[time X obs]

tot_sens_num = 15;


Train_sensor = [];

for i =1:5
    Train_sensor{i}=[train_in_nor_1{i}; train_in_f_1{i}];

end

%% Importing test data

fire_scenario = load('fire_scenario'); 
fire_scenario = fire_scenario.fire_scenario;

true_fire_time_info = load('true_fire_time_info'); 
true_fire_time_info = true_fire_time_info.true_fire_time_info;

train_index = [1 5 9 13];


test_index = [3 6 7 8 10 11 12 14 15 16];



%% vectorized observation for PCA
Vec_Train_sensor = [];
num_normal = 80;

for i = 1:num_normal
    
    Vec_Train_sensor(i, :)=[Train_sensor{1}(i, :) Train_sensor{2}(i, :) Train_sensor{3}(i, :) Train_sensor{4}(i, :) Train_sensor{5}(i, :)];
    
end




Vec_Train_sensor=[Vec_Train_sensor Vec_Train_sensor Vec_Train_sensor];

Train_label = [train_out_nor_1{1}'];

%% Obtain PCA matrix

win_size = 32; %window size


num_var = size(Vec_Train_sensor, 2);
N = size(Vec_Train_sensor, 1);
[eigenval,eigenvec,explain,Y,mean_vec]=  pca_fun(Vec_Train_sensor', num_var);
PCA_dimension = max(find(eigenval>=mean(eigenval)));
[eigenval,eigenvec,explain,Y,mean_vec]=  pca_fun(Vec_Train_sensor', PCA_dimension);

score_matrix=Y';
S=cov(score_matrix);



%% Algorithm 9 (Q-test)

% obtain confrol limit for Q-test
residual=Vec_Train_sensor-(eigenvec*eigenvec'*Vec_Train_sensor')';

res_cov = cov(residual);
theta_1 = trace(res_cov);
theta_2 = trace(res_cov^2);
theta_3 = trace(res_cov^3);
h_0 = 1-(2*theta_1*theta_3/(3*theta_2^2));
alpha2 = 0.999; %0.99 or 0.999
z_score = icdf('normal',alpha2,0,1);
PCA_clt2 = theta_1*(1-((theta_2*h_0*(1-h_0))/(theta_1^2))+((z_score*(2*theta_2*h_0^2)^(1/2))/(theta_1)))^(1/h_0);



% Run algorithm
Q_statistic=[];
Testing_time=[];
Testing_label=[];
predicted_class_voting=[];
for i = 1 : length(test_index) % Loop over every instance in the test set
    
    Testing=fire_scenario{test_index(i)};
    Testing_data_PCA=[];
    
    for tt=win_size:size(Testing, 1)
        
        Testing_data_PCA(tt-win_size+1, :)=reshape(Testing(((tt-win_size+1):tt),2:16), 1, []);
        Testing_time{i}(tt-win_size+1) = Testing(tt,1); % Time start from zero
        Testing_label{i}(tt-win_size+1) = Testing(tt,17);
        
    end
    
    
    for t = 1:length(Testing_time{i})
        
        current_observation=Testing_data_PCA(t, :);       
        test_residual=current_observation-(eigenvec*(eigenvec'*current_observation'))'; %Obtain residuals  
        Q_statistic = sqrt(sum(test_residual.^2)); %Obtain Q-statistic
        
        if Q_statistic>PCA_clt2
            Q_Classification{i}(t) = 1;
            
            
        else
            Q_Classification{i}(t) = 0;
            
        end
    end
    
    i;
    
end


%% Algorithm 10 (T^2 Test)

%obtain control limit for T^2 Test
alpha = 0.99;
PCA_clt = (PCA_dimension*(N^2-1))/(N*(N-PCA_dimension))*finv(alpha,PCA_dimension,(N-PCA_dimension)); % Control limit



% Run algorithm
Testing_time=[];
Testing_label=[];
predicted_class_voting=[];
for i = 1 : length(test_index) % Loop over every instance in the test set
    
    Testing=fire_scenario{test_index(i)};
    Testing_data_PCA=[];
    
    for tt=win_size:size(Testing, 1)
        
        Testing_data_PCA(tt-win_size+1, :)=reshape(Testing(((tt-win_size+1):tt),2:16), 1, []);
        Testing_time{i}(tt-win_size+1) = Testing(tt,1); % Time start from zero
        Testing_label{i}(tt-win_size+1) = Testing(tt,17);
        
    end
      
    for t = 1:length(Testing_time{i})
        
        normalized_Testing=Testing_data_PCA(t, :);
        z_new = normalized_Testing*eigenvec*inv(eigenvec'*eigenvec); %obtain trainsformed data (z_new)
        M_dist=(z_new-mean(score_matrix))*inv(S)*(z_new-mean(score_matrix))'; % Calculate mahalonobis distance from the training dataset
        
        if M_dist>PCA_clt
            Tsquared_classification{i}(t) = 1;
            
        else
            Tsquared_classification{i}(t) = 0;          
        end       
    end 
    i   ;
end




%% Obtain result for Algorithm 9 (Q-test)

consec_num=10;

for i = 1:length(test_index)
    
    
    ft(i) = find(Testing_time{i}==true_fire_time_info(test_index(i)));
         
    for ss = consec_num:length(Testing_time{i})
        if  consec_decision(Q_Classification{i}, consec_num, ss)==1 %If n consecutive point is classified as fire --> Fire
            break
        end
    end
    EFST(i) = Testing_time{i}(ss); % Estimated Fire Starting Time
    FSTA(i) = abs(true_fire_time_info(test_index(i))-EFST(i)); % Fire Starting Time Accuracy 
    
    FAR(i) = (sum(abs(Testing_label{i}(1:ft(i)-1) - Q_Classification{i}(1:ft(i)-1)))/length(Testing_time{i}(1:ft(i)-1))); %False Alarm rate

end
format long g
result_Q = [EFST' FSTA' FAR'*100]; %obtain results
average_results_q = mean(result_Q); % average of results from all scenarios
std_results_q = std(result_Q); % standard deviation of results from all scenarios

    rq = result_Q;
    aq = average_results_q;
    bq = std_results_q;
    
    
    disp('PCA-Q results')
    disp('                      EFST                      FSTA                      FAR')
    disp('------------------------------------------------------------------------------')
    disp(round(rq,2))
    disp('Average')
    disp(round(aq,2))
    disp('Std')
    disp(round(bq,2))
    disp('------------------------------------------------------------------------------')





%% obtaining result for Algorithm 10 (T^2 Test)
consec_num=10;
EFST=[];
FSTA=[];
FAR=[];
MCE=[];
for i = 1:length(test_index)
        
    ft(i) = find(Testing_time{i}==true_fire_time_info(test_index(i)));
        
    for ss = consec_num:length(Testing_time{i})
        if  consec_decision(Tsquared_classification{i}, consec_num, ss)==1 %If n consecutive point is classified as fire --> Fire
            break
        end
    end
    EFST(i) = Testing_time{i}(ss); % Estimated Fire Starting Time
    FSTA(i) = abs(true_fire_time_info(test_index(i))-EFST(i)); % Fire Starting Time Accuracy 
    
    FAR(i) = (sum(abs(Testing_label{i}(1:ft(i)-1) - Tsquared_classification{i}(1:ft(i)-1)))/length(Testing_time{i}(1:ft(i)-1)));

end
result_T = [EFST' FSTA' FAR'*100]; % obtain results
average_results_T = mean(result_T);  % average of results from all scenarios
std_results_T = std(result_T); % standard deviation of results from all scenarios

    rt = result_T;
    at = average_results_T;
    bt = std_results_T;
    
    
    disp('PCA-T^2 results')
    disp('                      EFST                      FSTA                      FAR')
    disp('------------------------------------------------------------------------------')
    disp(round(rt,2))
    disp('Average')
    disp(round(at,2))
    disp('Std')
    disp(round(bt,2))
    disp('------------------------------------------------------------------------------')






