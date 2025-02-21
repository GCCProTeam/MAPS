function  v_correct = resCorrectSFWin(v_recon7, v_recon8,win)
%According to the input residual data sequences, 
%the correction value is calculated

%INPUT:
%v_recon7： Reconstructed residuals for the first frequency (e.g., L1)
%v_recon8： Reconstructed residuals for the second frequency (e.g., L2)
%win：window size for the matching process

%OUTPUT:
%v_correct - Corrected residuals after win-based matching

% Copyright (C) GCC Group
%--------------------------------------------------------------------------
% Initialize the output cell array
v_correct = cell( size(v_recon8,1),1 );

% Loop through each satellite's residual data
for i=1:size(v_recon8,1)
    if( ~isempty(v_recon8{i}) && ~isempty(v_recon7{i}) )
        v1 = v_recon7{i};  v2 = v_recon8{i};
        % Normalize the time stamps to within a day (86400 seconds)
        v1(:, 1) = mod(v1(:, 1), 86400);  
        v2(:, 1) = mod(v2(:, 1), 86400);
        % Find common time stamps between the two datasets
        [~, ia, ib] = intersect(v1(:, 1), v2(:, 1));  
        v1 = v1(ia, :); 
        v2 = v2(ib, :);
         % Check if there are enough data points for window-based correction
        if(size(v1,1)>=win )
           v2_=[ v2(:,1:2), v2(:,3:6)*0 ];
           for ind = 3:4
               if ind==3
                  index=5;
               end
               if ind==4
                  index=6;
               end
               for j = 30:size(v2,1)
  
                   j_min = max(1, j - 30); 
                   j_max = min(size(v1, 1), j + win);
                        
                   search = v1(j_min:j_max,[ind,index]);
                   if size(search,1)<win
                      search=v1(end-win+1:end,[ind,index]);
                   end
                   tempt = v2(j-29:j,[ind,index]);
                   % Find the best matching window
                   match = Fun_match(tempt,search);
                   % Compute the affine transformation coefficients
                   [a,b] = Fun_least(tempt,match);
                   % Apply the correction to the current data point    
                   v2_(j,ind) = a*match(30,1)+b;
                   v2_(j,index)=a*a*match(30,2);
                   % Apply the correction to the initial 30 data points
                   if(j==30)
                      v2_(1:30,ind) = a*match(:,1)+b;
                      v2_(1:30,index) = a*a*match(:,2);
                   end
                   % Handle cases where the window size is too small
                   if(size(v2_,1)<=win)
                      v2_(:,[ind,index]) = 0;
                   end
                end
            end
            v_correct{i} = v2_;
         else
            v_correct{i} = [ v2(:,1:2), v2(:,3:6)*0 ];
        end
   end
end
end
%% --------------------------Sunfunction----------------------------
function match=Fun_match(tempt,search)
%Find the best matching window for the target window

%INPUT:
%tempt： Target window (query)
%search： Search window (database)

%OUTPUT:
%match： Best matching window from the search window

% Copyright (C) GCC Group
%--------------------------------------------------------------------------
% Initialize the correlation coefficient array
coeffi=zeros(size(search,1)-size(tempt,1),1);
% Compute the correlation coefficient for each window in the search space
for i=1:size(coeffi,1)
    search_win=search(i:i+29,1);
    %Calculation coefficient
    X=tempt(:,1); 
    Y=search_win;
    
    DX = sum((X - mean(X)).^2) / length(X);  
    DY = sum((Y - mean(Y)).^2) / length(Y);  
    COV_XY = sum((X - mean(X)) .* (Y - mean(Y))) / length(X);     
    coeffi(i) = COV_XY / (sqrt(DX) * sqrt(DY));  
end
% Find the window with the highest correlation coefficient
[~,i]=max(coeffi);
% Extract the best matching window
match=search(i:i+29,:);
end
%% --------------------------Sunfunction----------------------------
function [a,b]=Fun_least(tempt,match)
%Compute affine transformation coefficients using least squares

%INPUT:
%tempt： Target window (query)
%matc: Best matching window from the search window

%OUTPUT:
%a: Scaling coefficient
%b: Offset coefficient

% Copyright (C) GCC Group
%--------------------------------------------------------------------------
% Define the Gaussian weight matrix for smoothing
P = exp(-(repmat((1:size(tempt, 1))', 1, size(tempt, 1)) - ...
    repmat(1:size(tempt, 1), size(tempt, 1), 1)).^2 / ...
    (2 * (size(tempt, 1) / 2)^2));

% Define the design matrix and observation vector
B=[match(:,1),ones(size(match,1),1)]; 
L=tempt(:,1); 
X=(pinv(B'*P*B)) * (B'*P*L);
a=X(1); % Scaling coefficient
b=X(2); % Offset coefficient
end