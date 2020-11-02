clc

%% Data Gathering
Train_in = {};
Train_out = {};
%[Train_in, Train_out] = train_data_fire(([1 3 6 9 13 14]), 2, 32, 1, 10, 60, 20, 15, 80);
%% 32 points

%sensor_num = 1
%[nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(1, 2, 32, 20, 20, 20, 20, 3925, 100, sensor_num);

train_in_nor_1= {};
        train_out_nor_1={};
        train_in_f_1 = {};
        train_out_f_1 = {};

dp = 32; %past points
n = 50; %observations

nn2 = 0.6*floor(n);
nn1 = 0.4*floor(n);

% scenario 1

s = 1;
sensor_num = [2 3 4 5 6];

for i = 1:5
    if i == 1
       % i=1
        sen = sensor_num(i);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2, dp, n, n, 20, 20, 4920, 4, sen);
        train_in_nor_1{i} = nor_Train_in1';
        train_out_nor_1{i} = nor_Train_out1;
        train_in_f_1{i} = f_Train_in1';
        train_out_f_1{i} = f_Train_out1;
        
    elseif i == 2
        sen = sensor_num(i);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2, dp, n, n, 20, 20, 4200, 28, sen);
        train_in_nor_1{i} = nor_Train_in1';
        train_out_nor_1{i} = nor_Train_out1;
        train_in_f_1{i} = f_Train_in1';
        train_out_f_1{i} = f_Train_out1;
    elseif i== 3
        sen = sensor_num(i);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2, dp, n, n, 20, 20, 4900, 5, sen);
        train_in_nor_1{i} = nor_Train_in1';
        train_out_nor_1{i} = nor_Train_out1;
        train_in_f_1{i} = f_Train_in1';
        train_out_f_1{i} = f_Train_out1;
    elseif i == 4
        sen = sensor_num(i); 
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2, dp, n, n, 20, 20, 4890, 5, sen); %4900
        %[nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2, dp, n, n, 20, 20, 4850, 15, sen);
        
        train_in_nor_1{i} = nor_Train_in1';
        train_out_nor_1{i} = nor_Train_out1;
        train_in_f_1{i} = f_Train_in1';
        train_out_f_1{i} = f_Train_out1;
    elseif i== 5
        sen = sensor_num(i); %4900
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2, dp, n, n, 20, 20, 4900, 5, sen);
        %[nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2, dp, n, n, 20, 20, 4875, 15, sen);
        
        train_in_nor_1{i} = nor_Train_in1';
        train_out_nor_1{i} = nor_Train_out1;
        train_in_f_1{i} = f_Train_in1';
        train_out_f_1{i} = f_Train_out1;
    end
end
%scenario 5


s = 5;
sensor_num = [12 3 14 10 6];
for i = 1:5
    if i == 1
        sen = sensor_num(i);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2, dp, n, n, 20, 20, 2220, 5, sen);
        train_in_nor_1{i} = [train_in_nor_1{i}; nor_Train_in1'];
        train_out_nor_1{i} = [train_out_nor_1{i} nor_Train_out1];
        train_in_f_1{i} = [train_in_f_1{i}; f_Train_in1'];
        train_out_f_1{i} = [train_out_f_1{i} f_Train_out1];
        
    elseif i == 2 % 2305
        sen = sensor_num(i);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2,  dp, n, n, 20, 20, 2305, 2, sen);
        train_in_nor_1{i} = [train_in_nor_1{i}; nor_Train_in1'];
        train_out_nor_1{i} = [train_out_nor_1{i} nor_Train_out1];
        train_in_f_1{i} = [train_in_f_1{i}; f_Train_in1'];
        train_out_f_1{i} = [train_out_f_1{i} f_Train_out1];
    elseif i== 3
        sen = sensor_num(i);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2,  dp, n, n, 20, 20, 2250, 4, sen);
        train_in_nor_1{i} = [train_in_nor_1{i}; nor_Train_in1'];
        train_out_nor_1{i} = [train_out_nor_1{i} nor_Train_out1];
        train_in_f_1{i} = [train_in_f_1{i}; f_Train_in1'];
        train_out_f_1{i} = [train_out_f_1{i} f_Train_out1];
    elseif i == 4
        sen = sensor_num(i); %1500
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2,  dp, n, n, 20, 20, 1500, 19, sen);
        
        train_in_nor_1{i} = [train_in_nor_1{i}; nor_Train_in1'];
        train_out_nor_1{i} = [train_out_nor_1{i} nor_Train_out1];
        train_in_f_1{i} = [train_in_f_1{i}; f_Train_in1'];
        train_out_f_1{i} = [train_out_f_1{i} f_Train_out1];
    elseif i== 5
        sen = sensor_num(i);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2,  dp, n, n, 20, 20, 1800, 20, sen);
        
        train_in_nor_1{i} = [train_in_nor_1{i}; nor_Train_in1'];
        train_out_nor_1{i} = [train_out_nor_1{i} nor_Train_out1];
        train_in_f_1{i} = [train_in_f_1{i}; f_Train_in1'];
        train_out_f_1{i} = [train_out_f_1{i} f_Train_out1];
    end
end


%scenario 9


s = 9;
sensor_num = [2 3 4 5 6];
for i = 1:5
    if i == 1
        sen = sensor_num(i);%922
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2, dp, n, n, 20, 20, 920, 3, sen);
        train_in_nor_1{i} = [train_in_nor_1{i}; nor_Train_in1'];
        train_out_nor_1{i} = [train_out_nor_1{i} nor_Train_out1];
        train_in_f_1{i} = [train_in_f_1{i}; f_Train_in1'];
        train_out_f_1{i} = [train_out_f_1{i} f_Train_out1];
        
    elseif i == 2
        sen = sensor_num(i);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2,  dp, n, n, 20, 20, 994, 1, sen);
        
        
        train_in_nor_1{i} = [train_in_nor_1{i}; nor_Train_in1'];
        train_out_nor_1{i} = [train_out_nor_1{i} nor_Train_out1];
        train_in_f_1{i} = [train_in_f_1{i}; f_Train_in1'];
        train_out_f_1{i} = [train_out_f_1{i} f_Train_out1];
    elseif i== 3
        sen = sensor_num(i);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2,  dp, n, n, 20, 20, 868, 5, sen);
        train_in_nor_1{i} = [train_in_nor_1{i}; nor_Train_in1'];
        train_out_nor_1{i} = [train_out_nor_1{i} nor_Train_out1];
        train_in_f_1{i} = [train_in_f_1{i}; f_Train_in1'];
        train_out_f_1{i} = [train_out_f_1{i} f_Train_out1];
    elseif i == 4
        sen = sensor_num(i);
        %[nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2,  dp, n, n, 20, 20, 797, 12, sen);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2,  dp, n, n, 20, 20, 891, 4, sen);
        
        train_in_nor_1{i} = [train_in_nor_1{i}; nor_Train_in1'];
        train_out_nor_1{i} = [train_out_nor_1{i} nor_Train_out1];
        train_in_f_1{i} = [train_in_f_1{i}; f_Train_in1'];
        train_out_f_1{i} = [train_out_f_1{i} f_Train_out1];
    elseif i== 5
        sen = sensor_num(i);
        %[nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2,  dp, n, n, 20, 20, 744, 11, sen);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2,  dp, n, n, 20, 20, 906, 4, sen);
        
        train_in_nor_1{i} = [train_in_nor_1{i}; nor_Train_in1'];
        train_out_nor_1{i} = [train_out_nor_1{i} nor_Train_out1];
        train_in_f_1{i} = [train_in_f_1{i}; f_Train_in1'];
        train_out_f_1{i} = [train_out_f_1{i} f_Train_out1];
    end
end



% Scenario 13

s = 13;
sensor_num = [7 8 9 10 11];
for i = 1:5
    if i == 1
        sen = sensor_num(i);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2, dp, n, n, 20, 2, 782, 5, sen);
        train_in_nor_1{i} = [train_in_nor_1{i}; nor_Train_in1'];
        train_out_nor_1{i} = [train_out_nor_1{i} nor_Train_out1];
        train_in_f_1{i} = [train_in_f_1{i}; f_Train_in1'];
        train_out_f_1{i} = [train_out_f_1{i} f_Train_out1];
        
        
 
    elseif i == 2
        sen = sensor_num(i);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2,  dp, n, n, 20, 20, 912, 1, sen);
                
        
        train_in_nor_1{i} = [train_in_nor_1{i}; nor_Train_in1'];
        train_out_nor_1{i} = [train_out_nor_1{i} nor_Train_out1];
        train_in_f_1{i} = [train_in_f_1{i}; f_Train_in1'];
        train_out_f_1{i} = [train_out_f_1{i} f_Train_out1];
    elseif i== 3
        sen = sensor_num(i);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2,  dp, n, n, 20, 20, 791, 5, sen);
        train_in_nor_1{i} = [train_in_nor_1{i}; nor_Train_in1'];
        train_out_nor_1{i} = [train_out_nor_1{i} nor_Train_out1];
        train_in_f_1{i} = [train_in_f_1{i}; f_Train_in1'];
        train_out_f_1{i} = [train_out_f_1{i} f_Train_out1];
    elseif i == 4
        sen = sensor_num(i);
        %[nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2,  dp, n, n, 20, 20, 797, 12, sen);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2,  dp, n, n, 20, 20, 782, 5, sen);
        
        train_in_nor_1{i} = [train_in_nor_1{i}; nor_Train_in1'];
        train_out_nor_1{i} = [train_out_nor_1{i} nor_Train_out1];
        train_in_f_1{i} = [train_in_f_1{i}; f_Train_in1'];
        train_out_f_1{i} = [train_out_f_1{i} f_Train_out1];
    elseif i== 5
        sen = sensor_num(i);
        %[nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2,  dp, n, n, 20, 20, 744, 11, sen);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2,  dp, n, n, 20, 20, 770, 5, sen);
        
        train_in_nor_1{i} = [train_in_nor_1{i}; nor_Train_in1'];
        train_out_nor_1{i} = [train_out_nor_1{i} nor_Train_out1];
        train_in_f_1{i} = [train_in_f_1{i}; f_Train_in1'];
        train_out_f_1{i} = [train_out_f_1{i} f_Train_out1];
    end
end

% scenario 3



%[Test_in, Test_out] = train_data_fire(([2 4 5 7 8 10 11 12 15 16]), 2, 64, 1, 16, 100, 20, 15, 80);

% 1 3 6 9 13 14 scenarios selected
% 2nd normal scenario
% 32 window sise,
% 1 time step
% 16 observations from each scenario (40% normal, %20% fire, 40% fire starting)
% 100 total obsns (after getting the obsns from the
% fire scenario, the remining will be taken from  normal scenarios)
% 20 secs normal obsns start time in fire scenarios
% 15 secs before the fire start time for obsns at fire starting points
% 50 secs after the fire starting point for fire obsns




