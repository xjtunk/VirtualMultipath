function plotLine(x, y, y_lable, caption, varargin)
%PLOTLINE plot line graphs, x,y are vectors
    fname1=evalin('base','fname1');
    
    if size(y,2) > 4
        c = hot(size(y,2));
        set(gca,'NextPlot','replacechildren');
        set(gca,'ColorOrder',c);
        set(gca,'color', [.667, .667, 1]);
    end
    
    plot(x(:), y);
    xlim([0 max(x)]);
    grid on;
    set(gca,'xminortick', 'on');
    set(gca,'xminorgrid', 'on');
    set(gca,'yminortick', 'on');
    setappdata(gca, 'len', length(x));
    setappdata(gca, 'maxx', max(x));
    setappdata(gca, 'maxy', max(y));
    setappdata(gca, 'scale', 1);
    
    xlabel('Time(s)');
    ylabel(y_lable);
    if ~isempty(fname1)
        caption = [caption,'   fileName: ',fname1];
    end
    title(caption); 
end
