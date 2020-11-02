function [n_d] = data_normalization(d)

m1 = [];
m2 = [];
      
for j = 1:size(d,2)
    m1 = [m1;max(d{j})];
    m2 = [m2;min(d{j})];
    
end

        m_temp = [m1(:,2); m1(:,7);m1(:,12)];
        m_co = [m1(:,3); m1(:,8);m1(:,13)];
        m_ion = [m1(:,4); m1(:,9);m1(:,14)];
        m_pho = [m1(:,5); m1(:,10);m1(:,15)];
        m_sm = [m1(:,6); m1(:,11);m1(:,16)];
        max_d = [max(m_temp) max(m_co) max(m_ion) max(m_pho) max(m_sm)];
        
        m1 = m2;
        
        m_temp = [m1(:,2); m1(:,7);m1(:,12)];
        m_co = [m1(:,3); m1(:,8);m1(:,13)];
        m_ion = [m1(:,4); m1(:,9);m1(:,14)];
        m_pho = [m1(:,5); m1(:,10);m1(:,15)];
        m_sm = [m1(:,6); m1(:,11);m1(:,16)];
        min_d = [min(m_temp) min(m_co) min(m_ion) min(m_pho) min(m_sm)];
        
        n_d = d;
       
for j = 1:size(d,2)
    
                for sr = 2:6
                ii = 0;
                n_d{j}(:,sr+ii) = (d{j}(:,sr+ii)-min_d(sr-1))/(max_d(sr-1)-min_d(sr-1));
                ii = 5;
                n_d{j}(:,sr+ii) = (d{j}(:,sr+ii)-min_d(sr-1))/(max_d(sr-1)-min_d(sr-1));
                ii = 10;
                n_d{j}(:,sr+ii) = (d{j}(:,sr+ii)-min_d(sr-1))/(max_d(sr-1)-min_d(sr-1));
                end
end        

