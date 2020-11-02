clear all
%% import data
fire_scenario = load('fire_scenario');
fire_scenario = fire_scenario.fire_scenario;
all_data = fire_scenario;

true_fire_time_info = load('true_fire_time_info');
true_fire_time_info = true_fire_time_info.true_fire_time_info;

train_index = [1 5 9 13]; % Scenario index that are using for training dataset
test_index = [3 6 7 8 10 11 12 14 15 16]; % Scenario index that are using for testing dataset

data = {};
tfst = [];
len_scenario = [];


for test = 1:length(test_index)
    data{test} = all_data{test_index(test)};
    tfst(test) = true_fire_time_info(test_index(test));
    len_scenario(test) = size(all_data{test_index(test)},1);
end
len_scenario =len_scenario';
num_scenarios = size(data, 2);


%% denoise for thresholding method
for j=1: num_scenarios
    temp_data = data{j};
    for i = 2:16  %loop for number of sensors
        for ee = 6:length(temp_data(:,i))-5
            if (temp_data(ee,i)-temp_data(ee-5,i)) > 0 && (temp_data(ee+5,i) - temp_data(ee,i)) < 0
                temp_data(ee,i) = temp_data(ee-5,i);
            else
                temp_data(ee,i) = temp_data(ee,i);
            end
        end
    end
    
    
    % Denoise again for the CO sensors
    bb = [3 8 13];
    
    for i = 1: length(bb)
        for ee = 4:(length(temp_data(:,bb(i)))-3)
            if (temp_data(ee,bb(i))-temp_data(ee-3,bb(i))) > 0 && ( temp_data(ee+3,bb(i)) - temp_data(ee,bb(i))) < 0
                temp_data(ee,bb(i)) = temp_data(ee-3,bb(i));
            else
                temp_data(ee,bb(i)) = temp_data(ee,bb(i));
            end
        end
    end
    
    dn_data{j} = temp_data;
end




%% Parameter selection for threshgold method

starting_point = 33;
num_sens = 5; %number of sensors in each location
consec_num = 10;
%sensor_data = data; % Use original data
sensor_data = dn_data; % Use Denoised data

%threshold for algorithm 1

%th_temp_1 = 0.20;
%th_co_1 = 16;

th_temp_1 = 0.07;
th_co_1 = 2;

%th_temp_1 = 0.16;
%th_co_1 = 7;

%threshold parameter for algorithm 2
th_temp_2 = 0.2;
th_co_2 = 17;
th_ion_2 = 0.15;

%threshold parameter for algorithm 3 (not used)
th_co_ion_3 = 0.15;
th_co_3 = 16;
th_ion_3 = 0.15;

%th_co_ion_3 = 0.15;
%th_co_3 = 16;
%th_ion_3 = 0.05;


%threshold parameter for algorithm 4
th_temp_4 = 0.2;
th_pho_4 = 0.50;

%th_temp_4 = 0.2;
%th_pho_4 = 0.07;


%threshold parameter for algorithm 5
th_ion_5 = 0.15;
th_pho_5 = 0.50;


%threshold parameter for algorithm 6
th_6 = 10;


%% Start algorithm

y1_p = {};
y2_p = {};
y3_p = {};
y4_p = {};
y5_p = {};
y6_p = {};
efst=[];
yy = {};

for j=1: num_scenarios
    
    temp_data=sensor_data{j};
    
    temp_tfst=tfst(j);
    
    t1 = temp_data(:,1);
    temp_liv = temp_data(:,2);
    co_liv = temp_data(:,3);
    ion_liv = temp_data(:,4);
    pho_liv = temp_data(:,5);
    
    temp_bed = temp_data(:,7);
    co_bed = temp_data(:,8);
    ion_bed = temp_data(:,9);
    pho_bed = temp_data(:,10);
    
    
    temp_kit = temp_data(:,12);
    co_kit = temp_data(:,13);
    ion_kit = temp_data(:,14);
    pho_kit = temp_data(:,15);
    
    Y = temp_data(:,17);
    yy{j}=Y';
    
    
    
    corr_identify_1=0; corr_identify_2 = 0; corr_identify_3 = 0; corr_identify_4=0; corr_identify_5=0; corr_identify_6=0;
    
    for pp = starting_point: length(t1)
        
        d_temp_liv = ((temp_liv(pp)-temp_liv(pp-5))/(t1(pp)-t1(pp-5)));
        d_temp_kit = ((temp_kit(pp)-temp_kit(pp-5))/(t1(pp)-t1(pp-5)));
        d_temp_bed = ((temp_bed(pp)-temp_bed(pp-5))/(t1(pp)-t1(pp-5)));
        
        
        % method 1
        if d_temp_liv > th_temp_1 || co_liv(pp) > th_co_1
            y1_p{j}(pp) = 1;
            
        elseif d_temp_kit > th_temp_1 || co_kit(pp) > th_co_1
            y1_p{j}(pp) = 1;
        elseif d_temp_bed > th_temp_1 || co_bed(pp) > th_co_1
            y1_p{j}(pp) = 1;
        else
            y1_p{j}(pp) = 0;
        end
        
        
        
        % method 2
        if d_temp_liv > th_temp_2 || co_liv(pp) > th_co_2 || ion_liv(pp)> th_ion_2
            y2_p{j}(pp) = 1;
            
        elseif d_temp_kit > th_temp_2 || co_kit(pp) > th_co_2 || ion_kit(pp)> th_ion_2
            y2_p{j}(pp) = 1;
            
        elseif d_temp_bed > th_temp_2 || co_bed(pp) > th_co_2 || ion_bed(pp)> th_ion_2
            y2_p{j}(pp) = 1;
        else
            y2_p{j}(pp) = 0;
        end
        
        
        
        % method 3
        if (ion_liv(pp)*(co_liv(pp)-5) > th_co_ion_3 && ion_liv(pp)>0) || co_liv(pp)> th_co_3 || ion_liv(pp)> th_ion_3
            y3_p{j}(pp) = 1;
            
        elseif (ion_bed(pp)*(co_bed(pp)-5) > th_co_ion_3 && ion_bed(pp)>0) || co_bed(pp)> th_co_3 || ion_bed(pp)> th_ion_3
            y3_p{j}(pp) = 1;
            
        elseif (ion_kit(pp)*(co_kit(pp)-5) > th_co_ion_3 && ion_kit(pp)>0) || co_kit(pp)> th_co_3 || ion_kit(pp)> th_ion_3
           y3_p{j}(pp) = 1;
        else
            y3_p{j}(pp) = 0;
        end
        
        
        % method 4
        if d_temp_liv > th_temp_4 || pho_liv(pp)> th_pho_4
            y4_p{j}(pp) = 1;
        elseif d_temp_bed > th_temp_4 || pho_bed(pp)> th_pho_4
            y4_p{j}(pp) = 1;
            
        elseif d_temp_kit > th_temp_4 || pho_kit(pp)> th_pho_4
            y4_p{j}(pp) = 1;
        else
            y4_p{j}(pp) = 0;
        end
        
        
        
        
        
        % method 5
        if ion_liv(pp) > th_ion_5 || pho_liv(pp)> th_pho_5
            y5_p{j}(pp) = 1;
        elseif ion_bed(pp) > th_ion_5 || pho_bed(pp)> th_pho_5
            y5_p{j}(pp) = 1;
            
        elseif ion_kit(pp) > th_ion_5 || pho_kit(pp)> th_pho_5
            y5_p{j}(pp) = 1;
        else
            y5_p{j}(pp) = 0;
        end
        
        
        
        % method 6
        
        if (co_liv(pp)*ion_liv(pp) > th_6 && (co_liv(pp)>0 && ion_liv(pp)>0)) || (co_bed(pp)*ion_bed(pp) > th_6 && (co_bed(pp)>0 && ion_bed(pp)>0)) || (co_kit(pp)*ion_kit(pp) > th_6 && (co_kit(pp)>0 && ion_kit(pp)>0))
            y6_p{j}(pp) = 1;
        else
            y6_p{j}(pp) = 0;
        end
        
        
        
        corr_identify_1 = corr_identify_1 + abs(y1_p{j}(pp) - Y(pp));
        corr_identify_2 = corr_identify_2 + abs(y2_p{j}(pp) - Y(pp));
        corr_identify_3 = corr_identify_3 + abs(y3_p{j}(pp) - Y(pp));
        corr_identify_4 = corr_identify_4 + abs(y4_p{j}(pp) - Y(pp));
        corr_identify_5 = corr_identify_5 + abs(y5_p{j}(pp) - Y(pp));
        corr_identify_6 = corr_identify_6 + abs(y6_p{j}(pp) - Y(pp));
        
    end
    
    t_sig1 = 0;
    t_sig2 = 0;
    t_sig3 = 0;
    t_sig4 = 0;
    t_sig5 = 0;
    t_sig6 = 0;
    kk = 0;
    
    for tt = temp_tfst:length(t1)
        t_sig1 = t_sig1 + abs(y1_p{j}(tt) - Y(tt));
        t_sig2 = t_sig2 + abs(y2_p{j}(tt) - Y(tt));
        t_sig3 = t_sig3 + abs(y3_p{j}(tt) - Y(tt));
        t_sig4 = t_sig4 + abs(y4_p{j}(tt) - Y(tt));
        t_sig5 = t_sig5 + abs(y5_p{j}(tt) - Y(tt));
        t_sig6 = t_sig6 + abs(y6_p{j}(tt) - Y(tt));
        kk = kk +1;
    end
    
   
    
    % Algorithm 1 EFST
    for tt = starting_point:length(t1)
        
        if  consec_decision(y1_p{j}, consec_num, tt)==1 %If n consecutive point is classified as fire --> Fire
            break
        end
        
    end
    
    if tt == length(t1)
        efst(j,1) = length(t1);
    else
        efst(j,1) = tt;
    end
    
    
    % Algorithm 2 EFST
    for tt = starting_point:length(t1)
        
        if  consec_decision(y2_p{j}, consec_num, tt)==1 %If n consecutive point is classified as fire --> Fire
            break
        end
        
    end
    
    if tt == length(t1)
        efst(j,2) = length(t1);
    else
        efst(j,2) = tt;
    end
    
    
    
    % Algorithm 3 EFST
    for tt = starting_point:length(t1)
        
        if  consec_decision(y3_p{j}, consec_num, tt)==1 %If n consecutive point is classified as fire --> Fire
            break
        end
        
    end
    
    
    
    if tt == length(t1)
        efst(j,3) = length(t1);
    else
        efst(j,3) = tt;
    end
    
    
    
    
    % Algorithm 4 EFST
    for tt = starting_point:length(t1)
        
        if  consec_decision(y4_p{j}, consec_num, tt)==1 %If n consecutive point is classified as fire --> Fire
            break
        end
        
    end
    
    if tt == length(t1)
        efst(j,4) = length(t1);
    else
        efst(j,4) = tt;
    end
    
    
    
    % Algorithm 5 EFST
    for tt = starting_point:length(t1)
        
        if  consec_decision(y5_p{j}, consec_num, tt)==1 %If n consecutive point is classified as fire --> Fire
            break
        end
        
    end
    
    if tt == length(t1)
        efst(j,5) = length(t1);
    else
        efst(j,5) = tt;
    end
    
    % Algorithm 6 EFST
    for tt = starting_point:length(t1)
        
        if  consec_decision(y6_p{j}, consec_num, tt)==1 %If n consecutive point is classified as fire --> Fire
            break
        end
        
    end
    
    if tt == length(t1)
        efst(j,6) = length(t1);
    else
        efst(j,6) = tt;
    end
    
    
end

% False Alarm Rate
for j = 1:num_scenarios
    FAR(j,1) = sum(abs(yy{j}(1:tfst(j)-1) - y1_p{j}(1:tfst(j)-1)))/(tfst(j)-1);
    FAR(j,2) = sum(abs(yy{j}(1:tfst(j)-1) - y2_p{j}(1:tfst(j)-1)))/(tfst(j)-1);
    FAR(j,3) = sum(abs(yy{j}(1:tfst(j)-1) - y3_p{j}(1:tfst(j)-1)))/(tfst(j)-1);
    FAR(j,4) = sum(abs(yy{j}(1:tfst(j)-1) - y4_p{j}(1:tfst(j)-1)))/(tfst(j)-1);
    FAR(j,5) = sum(abs(yy{j}(1:tfst(j)-1) - y5_p{j}(1:tfst(j)-1)))/(tfst(j)-1);
    FAR(j,6) = sum(abs(yy{j}(1:tfst(j)-1) - y6_p{j}(1:tfst(j)-1)))/(tfst(j)-1);
    
end

result_efst = efst;  %estimated fire starting time result
result_FSTA = abs(efst-tfst'); %fire starting time accuracy result
result_FAR = FAR*100; %False alarm rate result

%% Results for TBA 1-5

algorithm_used= [1 2 4 5 6];
len = length(algorithm_used);
algorithm_result = {}
format long g


for j=1:len
    o = algorithm_used(j);
    algorithm_result{j}(:, 1) = result_efst(:, o);
    algorithm_result{j}(:, 2) = result_FSTA(:, o);
    algorithm_result{j}(:, 3) = round(result_FAR(:, o),2);
    average_results{j} = mean(algorithm_result{j});
    std_results{j} = std(algorithm_result{j});
    r = algorithm_result{j};
    a = [average_results{j}];
    b = [std_results{j}];
    
    
    fprintf('TBA %d results  \n',j)
    disp('        EFST        FSTA        FAR')
    disp('-----------------------------------')
    disp(r)
    disp('Average')
    disp(round(a,2))
    disp('Std')
    disp(round(b,2))
    disp('-----------------------------------')

   
end