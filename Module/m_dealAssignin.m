function m_dealAssignin( varargin )
%M_DEALA Summary of this function goes here
%   Detailed explanation goes here

for i = 1 : nargin
    assignin('base',inputname(i),varargin{i});
end 

end

