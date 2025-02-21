function RES_series=resSeriesBDS(RES)
%Function to process BDS residual data and organize it into a cell array

%INPUT: 
%RES: a matrix containing BDS residual data

%OUTPUT: 
%RES_series: a cell array for storing residual data by satellite number

% Copyright (C) GCC Group
%--------------------------------------------------------------------------
% Check if the input matrix RES is empty
if isempty(RES)
   fprintf('!!!BDS residual matrix is empty!!!'); 
   RES_series=[];
else
   % Initialize a cell array with 32 cells to store the processed data
   RES_series=cell(63,1);

   % Extract unique values from the satellite IDs of RES
   unique_values = unique(RES(:, 3));

   % Loop through each unique value
   for i = 1:length(unique_values)
       k=unique_values(i);
       idx = RES(:, 3) == unique_values(i);

       % Extract the sub-matrix corresponding to the current unique value
       sub_matrix = RES(idx, :);
      if size(sub_matrix,2)<=10
           sub_matrix=sub_matrix(:,[2,3,7,8]); 
       else
           sub_matrix=sub_matrix(:,[2,3,7,8,11,12]); 
       end
       RES_series{k} = sub_matrix;
   end
end
end


