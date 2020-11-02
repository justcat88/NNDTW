function [alarm] = consec_decision(y, consec_num, current_point)


    if sum(y((current_point-consec_num+1):current_point))==consec_num
        alarm = 1;
    else
        alarm = 0;

    end
end
