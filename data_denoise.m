function [n_d] = data_denoise(d)


       n_d = d;
for j = 1:size(d,2)
    

    for i= 1:3
        
        if i == 1
            ii = 0;
            
        
            for sr = 2:6
               n_d{j}(:,sr+ii) = wdenoise(d{j}(:,sr+ii));
               
            end
        elseif i == 2
            
            ii = 5;
            for sr = 2:6
                n_d{j}(:,sr+ii) = wdenoise(d{j}(:,sr+ii));
            end
            
        elseif i == 3
            ii = 10;
            for sr = 2:6
                n_d{j}(:,sr+ii) = wdenoise(d{j}(:,sr+ii));
            end
        end
    end
end
