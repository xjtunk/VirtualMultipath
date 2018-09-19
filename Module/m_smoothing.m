function [ pc ] = m_smoothing ( pc, numOfTimes, varargin)  
    
    if nargin == 2
        for i = 1 : numOfTimes
            pc = cellfun(@m_denoise,pc,'UniformOutput', false ); 
        end
    elseif nargin == 3
        fLen    = cell(size(pc));
        fLen(:) = {varargin{1}};
        
        for i = 1 : numOfTimes
            pc = cellfun(@m_denoise,pc,fLen,'UniformOutput', false ); 
        end
    end

end
