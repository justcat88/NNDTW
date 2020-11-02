function [D1, A1, D2, A2] = train_data_fire_sensor(S, R, k, n, m, qq, z1, ff, z3, sensor_num )

% [1 3 6 9 13 14]), 2, 32, 1, 16, 100, 20, 15, 80

% R = 2
% k = 32
% z = 1
% n = 16
% m = 100
% qq = 20
% ff = 15
% fe = 80
% S = ([1 3 6 9 13 14])

% S (vector) scenarios selected
% R (1, 2, or 3) normal scenario
% k window sise,
% z1 time step for normal obsns
% z2 time step for fire obsns
% z3 time step for fire changing obsns
% n observations from each scenario (40% normal, %20% fire, 40% fire starting)
% m total obsns (after getting the obsns from the fire scenario, the remining will be taken from  normal scenarios)
% qq secs normal obsns start time in fire scenarios
% fe secs after the fire starting point for fire obsns
% ff secs after the fire start time for obsns at fire starting points(ff
% should be longer than fe)


fire_scenario = load('fire_scenario'); %load indice for cross validation
fire_scenario = fire_scenario.fire_scenario;


true_fire_time_info = load('true_fire_time_info'); %load indice for cross validation
true_fire_time_info = true_fire_time_info.true_fire_time_info;

non_fire_scenario = load('non_fire_scenario'); %load indice for cross validation
non_fire_scenario = non_fire_scenario.non_fire_scenario;

xx=1;
k = k-1;
q=0;

for j = 1:length(S)
   % if j == length(S)+1
    %            xx=1;
     %           nn = m-q;
      %          for i =  1:nn
      %          D1(:,i)=non_fire_scenario{R}(xx:(xx+k),[sensor_num]);
      %          A1(:,i)=non_fire_scenario{R}(xx:(xx+k),17);  
      %          xx = xx+z1;
      %          end
   % else    
    for t = 1:2
        xx=1;
            if t == 1 %normal point
                for i = 1:floor(0.4*n)
                D1(:,i) = fire_scenario{S(j)}(xx+qq:(xx+k+qq),[sensor_num]);
                A1(:,i) = fire_scenario{S(j)}(xx+k+qq,17);
                xx = xx+z1;
                
                p2 = floor(0.4*n);
                end
                

            elseif t==2 %fire points

                
                for i = 1:floor(0.6*n)
                %TFST = true_fire_time_info(j)+ff; 
                TFST = ff; 
        
                D2(:,i) = fire_scenario{S(j)}(TFST+xx:(TFST+xx+k),[sensor_num]);
                A2(:,i) = fire_scenario{S(j)}((TFST+xx+k),17);
                xx = xx+z3;
                
                end
                p = floor(0.6*n);
            end             
    end
            q = q+p+p2;
   % end
end
    
%     fprintf('Fire scenario %d selected  \n',S)
%     fprintf('Total normal obsns = %d \n',p2)          
%     fprintf('Total fire obsns =%d \n',p)
%     fprintf('---------------------------------')
            

    
    
    
    