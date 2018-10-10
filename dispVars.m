%-------------------------------------------------------------------------------
% dispVars: write to command line
%
% Syntax: [] = dispVars(varargin)
%
% Inputs: 
%     varargin - 
%
% Outputs: 
%     [] - 
%
% Example:
%     
%

% John M. O' Toole, University College Cork
% Started: 10-10-2018
%
% last update: Time-stamp: <2018-10-10 18:19:10 (otoolej)>
%-------------------------------------------------------------------------------
function [] = dispVars(varargin)

str = '';
for i=1:nargin
    if( iscell(varargin{i}) )
        for j=1:length(varargin{i})
            str = [ str ' |' char(inputname(i)) '(' num2str(j) ') =' ...
                    num2str(varargin{i}{j}) ];
        end
    else
        str = strcat(str,' |',char(inputname(i)),'=',num2str(varargin{i}));
    end
    
end

disp(str);
