function binned = binner(MATRIX, BIN_COL, BIN_INC, varargin);
%
% ============================================================================
% $RCSfile$
% $Source$
% $Revision$
% $Date$
% $Author$
% $Name$
%
% USAGE: binned = binner(MATRIX, BIN_COLUMN, BIN_SIZE );
% DESCRIPTION: bins MATRIX by the column contained in BIN_COLUMN and returns
% the corresponding matrix binned to BIN_SIZE bins.
% ============================================================================
%

if ~isempty(varargin)
    t0 = clock;
end;

binned = [];

if nargin < 3;
    error('3 arguments are required (Type help for an explanation).');
    return;
end;

if ~isempty(MATRIX)
	data        = MATRIX(:,BIN_COL);    % Column to bin by
	COLS        = 1:size(MATRIX,2);     % Size of the MATRIX

	min_value   = floor(min(data));     % Min bin value
    max_value   = ceil(max(data));      % Max bin value
   
    % Evenly spaced bin array
	bins        = (min_value - BIN_INC:BIN_INC:max_value + BIN_INC)';
   
	for x = 2:size(bins,1);
        ind = find(data > bins(x-1)-(BIN_INC/2) & data <= bins(x)-(BIN_INC/2));
        if ~isempty(ind);
            binned = [binned; bins(x-1) mean(MATRIX(ind,COLS),1)];
        end;
        clear ind;
	end;
	clear sensor bins
     
    if ~isempty(binned)
		binned(:,BIN_COL+1) = binned(:,1);
		binned(:,1) = [];
    else
        binned = [];
    end
   
end;

if ~isempty(varargin)
    t1 = clock;
    disp(['Binned in: ' num2str(etime(t1,t0), '%0.4f') ' seconds.']);
end;
