clear;  close all;  clc;

% part_1
num_cal = 30;
pmt = zeros(8, num_cal);
pmt(3, 1) = 1;
for k = 0 : num_cal-1
    % length modification
    pmt(1, k+1) = k;
    pmt(2, k+1) = 1 + power(2, -2*k);
    pmt(3, k+1) = pmt(2, k+1) ^ -0.5;
    
    % elementary tangent
    pmt(6, k+1) = power(2,-k);
end
% elementary radium/angle
pmt(7, :) = atan(pmt(6, :));
pmt(8, :) = pmt(7, :) * 180 / pi;

pmt(4, 1) = pmt(3, 1);
for k = 1 : num_cal-1
   pmt(4, k+1) = pmt(4, k) * pmt(3, k+1); 
end


% part_2
num_initial = 12;
alpha = zeros(1, num_initial);
X_and_Y = zeros(6, num_initial);
for initial = 1 : num_initial
    alpha(initial) = (4*initial-3) * pi / 24;        % 1*pi/24 ~ 45*pi/24
    X_and_Y(1, initial) = cos(alpha(initial));
    X_and_Y(3, initial) = sin(alpha(initial));
end

% fixed-point of X and Y
X_and_Y(2, :) = fi(X_and_Y(1, :), 1, 12, 10);
X_and_Y(4, :) = fi(X_and_Y(3, :), 1, 12, 10);

% 2,3 quadrants -> 1,4 quadrants
X_and_Y(5, :) = abs(X_and_Y(1, :));
X_and_Y(6, :) = fi(X_and_Y(5, :), 1, 12, 10);



% part_3
process_rad = zeros(14, num_initial, num_cal+1);
rad_err = zeros(2, num_cal+1);
% X
process_rad(1, :, 1) = X_and_Y(6, :);               % modify
% Y
process_rad(2, :, 1) = X_and_Y(4, :);               % modify

rotate = zeros(2, 2, num_cal);
for i = 1 : num_cal
    for j = 1 : num_initial
        % tangent orginal
        process_rad(3, j, i) = process_rad(2, j, i) / process_rad(1, j, i);
        % radian & average radian
        process_rad(4, j, i) = atan(process_rad(3, j, i));
        
        
        % mu
        mu = (-1)*process_rad(2, j, i) / abs(process_rad(2, j, i));
        % rotate 
        rotate(:, :, i) = [         1               (-1)*mu*pmt(6,i); 
                           mu*pmt(6,i)             1       ];
        X0 = process_rad(1, j, i);
        Y0 = process_rad(2, j, i);
        new = rotate(:, :, i) * [X0; Y0];
        X_new = new(1);
        Y_new = new(2);
        
        
        % after rotation
        % X, Y
        process_rad(7, j, i) = X_new;
        process_rad(8, j, i) = Y_new;
        % tangent after rotation
        process_rad(9, j, i) = Y_new / X_new;
        % radian after rotation
        process_rad(10, j, i) = atan(process_rad(9, j, i));
        
                
        % transfer rotation into angle
        process_rad(5, j, i) = process_rad(4, j, i) * 180/pi;
        process_rad(11, j, i) = process_rad(10, j, i) * 180/pi; 
        
        
        % check 
        if (process_rad(2, j, i) > 0)
            process_rad(13, j, i) = - pmt(7, i);
            process_rad(14, j, i) = process_rad(4, j, i) - pmt(7, i);
            process_rad(15, j, i) = process_rad(5, j, i) - pmt(8, i);
        else
            process_rad(13, j, i) = pmt(7, i);
            process_rad(14, j, i) = process_rad(4, j, i) + pmt(7, i);
            process_rad(15, j, i) = process_rad(5, j, i) + pmt(8, i);
        end       
        
        % next layer
        process_rad(1, j, i+1) = X_new;
        process_rad(2, j, i+1) = Y_new;
    end
    % phase error
    rad_err(1, i) = mean(abs(process_rad(4, :, i)));
end
rad_err(1, num_cal+1) = mean(abs(process_rad(4, :, num_cal+1)));




% fixed-point of radium array with 1-30 bits
rad_bits = 30;
avg_err = zeros(1, rad_bits);
% the original radium
rad_fixed = zeros(num_initial, num_cal+6, rad_bits);
rad_fixed(:, [1:30], 1) = process_rad(13, :, [1:30]);
for b = 1 : rad_bits
    % each layer(n) for (n-1)bits fixed-point
    rad_fixed(:, :, b+1) = fi(rad_fixed(:, :, 1), 1, b+3, b);
    
    for j = 1 : num_initial
        % the total radium sum from rotation-01 to rotation-30
        total = 0;
        for i = 1 : num_cal
             total = total + rad_fixed(j, i, b);
        end
        rad_fixed(j, num_cal+2, b) = total;
    end
    
    % input radian
    rad_fixed(:, num_cal+3, b) = process_rad(4,:,1);
    % fixed-point error between input radian
    rad_fixed(:, num_cal+4, b) = abs(rad_fixed(:,num_cal+2,b) + rad_fixed(:,num_cal+3,b));
    % floating-point error between input radian
    rad_fixed(:, num_cal+5, b) = process_rad(10,:,30);
    % error between floating-point and fixed-point
    rad_fixed(:, num_cal+6, b) = abs(rad_fixed(:,num_cal+5,b) - rad_fixed(:,num_cal+4,b));
end

% average error(n+1) of 12 inputs with each number (n) of fixed-points
for b = 0 : rad_bits
    avg_err(b+1) = sum(rad_fixed(:, num_cal+4, b+1));
end


% figure;
% i = 0 : num_cal;
% semilogy(i, rad_err(1, :));
% title ('average phase errors');
% xlabel ('numbers of rotation');
% ylabel ('phase errors');
% % constraint
% cst = zeros(1, num_cal+1);
% cst(:) = 0.005;
% hold on;
% plot (i, cst);
% 
% figure;
% bits = 1 : rad_bits
% % plot (bits, [avg_err(2:31)]);
% semilogy(bits, [avg_err(2:31)]);
% title ('quantized elementary radian');
% xlabel ('numbers of bits');
% ylabel ('error');
% % constraint
% cst = zeros(1, num_cal+1);
% cst(:) = power(2, -8);
% hold on;
% plot (i, cst);
    

% Elementary Angle List
ele_ang_list = zeros(5, num_cal);
ele_ang_list(1, :) = pmt(1, :);
ele_ang_list(2, :) = pmt(7, :);
% binary fixed-point representation
% use 15-bits, 1 signed-bits, 2 for integers, 12-bits for fraction
ele_ang_list(4, :) = ele_ang_list(2,:) * power(2,12);
t1 = dec2bin(round(ele_ang_list(4,:)));
for i = 1 : num_cal
    ele_ang_list(5, i) = str2double(t1(i,:));
end






% part_4
err_len_by_oper = zeros(4, num_initial, num_cal+1);
err_len = zeros(1, num_cal+1);

err_len_by_oper([1,2], :, :) = process_rad([1,2], :, :);
for i = 1 : num_cal+1
    for j = 1 : num_initial
        % length of x & y
        err_len_by_oper(3, j, i) = sqrt(power(err_len_by_oper(1,j,i), 2) + power(err_len_by_oper(2,j,i), 2));
        
        % error by missing value of y
        err_len_by_oper(4, j, i) = 1 - abs(err_len_by_oper(1,j,i)) / err_len_by_oper(3,j,i);
    end
    % the result of precision by operations
    err_len(i) = mean(err_len_by_oper(4, :, i));
end




% part_5
SN = zeros(1, 3);
s1 = 1/pmt(4, num_cal);
sn_fixed = 20;
sf_arr = zeros(2, sn_fixed);
sf_str = zeros(sn_fixed, sn_fixed+1);
for m = 1 : sn_fixed
    sf_arr(1, m) = fi(s1, 0, m+2, m);
    sf_arr(3, m) = sf_arr(1,m) * power(2,m);
    a = sn_fixed-m+1
    sf_str(m, [a:sn_fixed+1]) = dec2bin(sf_arr(3,m));
    sf_str(m, [a:sn_fixed+1]) = sf_str(m, [a:sn_fixed+1]) - 48;
end
sf_arr(2, :) = abs(sf_arr(1,:) - s1) / s1;




% % hardware
% crd_fixed = 40;
% num_opr = num_cal;
% process_fixed = zeros(11, num_initial, crd_fixed, num_opr+1);
% tangent = zeros(1, num_initial);
% for i = 1 : num_opr
%     for cf = 1 : crd_fixed
%         % X_fixed, Y_fixed
%         process_fixed([1,2], :, cf, 1) = process_rad([1,2], :, 1);
% 
%         for j = 1 : num_initial
%             % radium_origin
%             process_fixed(3, j, cf, i) = atan(process_fixed(2,j,cf,i) / process_fixed(1,j,cf,i));
%             
% 
%             % rotation
%             x1 = process_fixed(1,j,cf,i);
%             y1 = process_fixed(2,j,cf,i);
%             if (y1 > 0)
%                 x2 = x1 + y1*power(2,-i);
%                 y2 = y1 - x1*power(2,-i);
%             else
%                 x2 = x1 - y1*power(2,-i);
%                 y2 = y1 + x1*power(2,-i);
%             end
%             process_fixed(5, j, cf, i) = x2;
%             process_fixed(6, j, cf, i) = y2;
%             process_fixed(7, j, cf, i) = atan(process_fixed(6,j,cf,i) / process_fixed(5,j,cf,i));
%             
%             % fixed-point
%             x3 = fi(x2, 1, cf+3, cf);
%             y3 = fi(y2, 1, cf+3, cf);
%             process_fixed(9, j, cf, i) = x3;
%             process_fixed(10, j, cf, i) = y3;
%             process_fixed(11, j, cf, i) = atan(process_fixed(10,j,cf,i) / process_fixed(9,j,cf,i));
%             
%             % next layer
%             process_fixed(1, j, cf, i+1) = process_fixed(9, j, cf, i);
%             process_fixed(2, j, cf, i+1) = process_fixed(10, j, cf, i);
%         end
%     end
% end
% 
% 
% % fixed operation result
% result_fixed = zeros(num_initial+1, crd_fixed);
% result_fixed([1:num_initial], :) = process_fixed(11, :, :, num_opr);
% for cf = 1 : crd_fixed
%     result_fixed(num_initial+1, cf) = mean(abs(result_fixed([1:num_initial], cf)));
% end
% 
% figure;
% cf = 1 : crd_fixed
% semilogy (cf, result_fixed(num_initial+1,:));
% title ('error of fixed-point of X, Y');
% xlabel ('fraction bits');
% ylabel ('error');
% % constraints
% cst = zeros(1, crd_fixed);
% cst(:) = power(2, -10);
% hold on;
% plot (cf, cst);




        



























