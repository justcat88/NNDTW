clear all

%% import dataset

fire_scenario = load('fire_scenario'); %load indice for cross validation
d = fire_scenario.fire_scenario;

dd = data_denoise(d);

X = data_normalization(dd);
%% Data Gathering
Train_in = {};
Train_out = {};
%[Train_in, Train_out] = train_data_fire(([1 3 6 9 13 14]), 2, 32, 1, 10, 60, 20, 15, 80);
%% 32 points
dp = 32; %past points
n = 50; %observations

nn2 = 0.6*floor(n);
nn1 = 0.4*floor(n);

% scenario 1
for sn = 1:4
    if sn == 1
        s = 1;
sensor_num = [2 3 4 5 6];
for i = 1:5
    if i == 1
        sen = sensor_num(i);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor_ann(X, s, 2, dp, n, n, 20, 20, 4920, 4, sen);
        train_in_nor_1 = nor_Train_in1';
        train_out_nor_1 = nor_Train_out1';
        train_in_f_1 = f_Train_in1';
        train_out_f_1 = f_Train_out1';
        
    elseif i == 2
        sen = sensor_num(i);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor_ann(X, s, 2, dp, n, n, 20, 20, 4200, 28, sen);
        train_in_nor_1 =[train_in_nor_1 nor_Train_in1'];
        train_out_nor_1 =[train_out_nor_1 nor_Train_out1'];
        train_in_f_1 =[train_in_f_1 f_Train_in1'];
        train_out_f_1 = [train_out_f_1 f_Train_out1'];
    elseif i== 3
        sen = sensor_num(i);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor_ann(X, s, 2, dp, n, n, 20, 20, 4900, 5, sen);
        train_in_nor_1 =[train_in_nor_1 nor_Train_in1'];
        train_out_nor_1 =[train_out_nor_1 nor_Train_out1'];
        train_in_f_1 =[train_in_f_1 f_Train_in1'];
        train_out_f_1 = [train_out_f_1 f_Train_out1'];
    elseif i == 4
        sen = sensor_num(i); 
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor_ann(X, s, 2, dp, n, n, 20, 20, 4890, 5, sen); %4900
        %[nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2, dp, n, n, 20, 20, 4850, 15, sen);
        
        train_in_nor_1 =[train_in_nor_1 nor_Train_in1'];
        train_out_nor_1 =[train_out_nor_1 nor_Train_out1'];
        train_in_f_1 =[train_in_f_1 f_Train_in1'];
        train_out_f_1 = [train_out_f_1 f_Train_out1'];
    elseif i== 5
        sen = sensor_num(i); %4900
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor_ann(X, s, 2, dp, n, n, 20, 20, 4900, 5, sen);
        %[nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2, dp, n, n, 20, 20, 4875, 15, sen);
        
        train_in_nor_1 =[train_in_nor_1 nor_Train_in1'];
        train_out_nor_1 =[ nor_Train_out1];
        train_in_f_1 =[train_in_f_1 f_Train_in1'];
        train_out_f_1 = [ f_Train_out1];
    end
end

    tr_in_nor {sn} = train_in_nor_1;
    tr_out_nor {sn} = train_out_nor_1;
    tr_in_f {sn} = train_in_f_1;
    tr_out_f {sn} = train_out_f_1;

%scenario 5

    elseif sn == 2
s = 5;
sensor_num = [12 3 14 10 6];
for i = 1:5
    if i == 1
        sen = sensor_num(i);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor_ann(X,s, 2, dp, n, n, 20, 20, 2220, 5, sen);
        train_in_nor_1 = nor_Train_in1';
        train_out_nor_1 = nor_Train_out1';
        train_in_f_1 = f_Train_in1';
        train_out_f_1 = f_Train_out1';
                
    elseif i == 2 % 2305
        sen = sensor_num(i);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor_ann(X, s, 2,  dp, n, n, 20, 20, 2305, 2, sen);
        train_in_nor_1 =[train_in_nor_1 nor_Train_in1'];
        train_out_nor_1 =[train_out_nor_1 nor_Train_out1'];
        train_in_f_1 =[train_in_f_1 f_Train_in1'];
        train_out_f_1 = [train_out_f_1 f_Train_out1'];
    elseif i== 3
        sen = sensor_num(i);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor_ann(X, s, 2,  dp, n, n, 20, 20, 2250, 4, sen);
        train_in_nor_1 =[train_in_nor_1 nor_Train_in1'];
        train_out_nor_1 =[train_out_nor_1 nor_Train_out1'];
        train_in_f_1 =[train_in_f_1 f_Train_in1'];
        train_out_f_1 = [train_out_f_1 f_Train_out1'];
    elseif i == 4
        sen = sensor_num(i); %1500
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor_ann(X, s, 2,  dp, n, n, 20, 20, 1500, 19, sen);
        
        train_in_nor_1 =[train_in_nor_1 nor_Train_in1'];
        train_out_nor_1 =[train_out_nor_1 nor_Train_out1'];
        train_in_f_1 =[train_in_f_1 f_Train_in1'];
        train_out_f_1 = [train_out_f_1 f_Train_out1'];
    elseif i== 5
        sen = sensor_num(i);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor_ann(X, s, 2,  dp, n, n, 20, 20, 1800, 20, sen);
        
        train_in_nor_1 =[train_in_nor_1 nor_Train_in1'];
        train_out_nor_1 =[ nor_Train_out1];
        train_in_f_1 =[train_in_f_1 f_Train_in1'];
        train_out_f_1 = [ f_Train_out1];
    end
end

    tr_in_nor {sn} = train_in_nor_1;
    tr_out_nor {sn} = train_out_nor_1;
    tr_in_f {sn} = train_in_f_1;
    tr_out_f {sn} = train_out_f_1;

%scenario 9
    elseif sn == 3

s = 9;
sensor_num = [2 3 4 5 6];
for i = 1:5
    if i == 1
        sen = sensor_num(i);%922
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor_ann(X, s, 2, dp, n, n, 20, 20, 920, 3, sen);
        train_in_nor_1 = nor_Train_in1';
        train_out_nor_1 = nor_Train_out1';
        train_in_f_1 = f_Train_in1';
        train_out_f_1 = f_Train_out1';
        
    elseif i == 2
        sen = sensor_num(i);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor_ann(X, s, 2,  dp, n, n, 20, 20, 994, 1, sen);
        
        
        train_in_nor_1 =[train_in_nor_1 nor_Train_in1'];
        train_out_nor_1 =[train_out_nor_1 nor_Train_out1'];
        train_in_f_1 =[train_in_f_1 f_Train_in1'];
        train_out_f_1 = [train_out_f_1 f_Train_out1'];
    elseif i== 3
        sen = sensor_num(i);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor_ann(X, s, 2,  dp, n, n, 20, 20, 868, 5, sen);
        train_in_nor_1 =[train_in_nor_1 nor_Train_in1'];
        train_out_nor_1 =[train_out_nor_1 nor_Train_out1'];
        train_in_f_1 =[train_in_f_1 f_Train_in1'];
        train_out_f_1 = [train_out_f_1 f_Train_out1'];
    elseif i == 4
        sen = sensor_num(i);
        %[nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2,  dp, n, n, 20, 20, 797, 12, sen);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor_ann(X, s, 2,  dp, n, n, 20, 20, 891, 4, sen);
        
        train_in_nor_1 =[train_in_nor_1 nor_Train_in1'];
        train_out_nor_1 =[train_out_nor_1 nor_Train_out1'];
        train_in_f_1 =[train_in_f_1 f_Train_in1'];
        train_out_f_1 = [train_out_f_1 f_Train_out1'];
    elseif i== 5
        sen = sensor_num(i);
        %[nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2,  dp, n, n, 20, 20, 744, 11, sen);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor_ann(X, s, 2,  dp, n, n, 20, 20, 906, 4, sen);
        
        train_in_nor_1 =[train_in_nor_1 nor_Train_in1'];
        train_out_nor_1 =[ nor_Train_out1];
        train_in_f_1 =[train_in_f_1 f_Train_in1'];
        train_out_f_1 = [ f_Train_out1];
    end
end

    tr_in_nor {sn} = train_in_nor_1;
    tr_out_nor {sn} = train_out_nor_1;
    tr_in_f {sn} = train_in_f_1;
    tr_out_f {sn} = train_out_f_1;



% Scenario 13

    elseif sn == 4

s = 13;
sensor_num = [7 8 9 10 11];
for i = 1:5
    if i == 1
        sen = sensor_num(i);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor_ann(X, s, 2, dp, n, n, 20, 2, 782, 5, sen);
        train_in_nor_1 = nor_Train_in1';
        train_out_nor_1 = nor_Train_out1';
        train_in_f_1 = f_Train_in1';
        train_out_f_1 = f_Train_out1';
        
        
 
    elseif i == 2
        sen = sensor_num(i);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor_ann(X, s, 2,  dp, n, n, 20, 20, 912, 1, sen);
                
        
        train_in_nor_1 =[train_in_nor_1 nor_Train_in1'];
        train_out_nor_1 =[train_out_nor_1 nor_Train_out1'];
        train_in_f_1 =[train_in_f_1 f_Train_in1'];
        train_out_f_1 = [train_out_f_1 f_Train_out1'];
    elseif i== 3
        sen = sensor_num(i);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor_ann(X, s, 2,  dp, n, n, 20, 20, 791, 5, sen);
        train_in_nor_1 =[train_in_nor_1 nor_Train_in1'];
        train_out_nor_1 =[train_out_nor_1 nor_Train_out1'];
        train_in_f_1 =[train_in_f_1 f_Train_in1'];
        train_out_f_1 = [train_out_f_1 f_Train_out1'];
    elseif i == 4
        sen = sensor_num(i);
        %[nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2,  dp, n, n, 20, 20, 797, 12, sen);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor_ann(X, s, 2,  dp, n, n, 20, 20, 782, 5, sen);
        
        train_in_nor_1 =[train_in_nor_1 nor_Train_in1'];
        train_out_nor_1 =[train_out_nor_1 nor_Train_out1'];
        train_in_f_1 =[train_in_f_1 f_Train_in1'];
        train_out_f_1 = [train_out_f_1 f_Train_out1'];
    elseif i== 5
        sen = sensor_num(i);
        %[nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor(s, 2,  dp, n, n, 20, 20, 744, 11, sen);
        [nor_Train_in1, nor_Train_out1, f_Train_in1, f_Train_out1] = train_data_fire_sensor_ann(X, s, 2,  dp, n, n, 20, 20, 770, 5, sen);
        
        train_in_nor_1 =[train_in_nor_1 nor_Train_in1'];
        train_out_nor_1 =[ nor_Train_out1];
        train_in_f_1 =[train_in_f_1 f_Train_in1'];
        train_out_f_1 = [ f_Train_out1];
    end
end
    tr_in_nor {sn} = train_in_nor_1;
    tr_out_nor {sn} = train_out_nor_1;
    tr_in_f {sn} = train_in_f_1;
    tr_out_f {sn} = train_out_f_1;

    end
end



%% reverting back to old matrix names

train_in_nor_1 =[];
train_out_nor_1 =[];
train_in_f_1 =[];
train_out_f_1 = [];

for i = 1:size(tr_in_nor,2)

        train_in_nor_1 =[train_in_nor_1; tr_in_nor{i}];
        train_out_nor_1 =[train_out_nor_1 tr_out_nor{i}];
        train_in_f_1 =[train_in_f_1; tr_in_f{i}];
        train_out_f_1 = [train_out_f_1 tr_out_f{i}];
end

