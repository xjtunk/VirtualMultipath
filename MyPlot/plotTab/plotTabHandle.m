function tg = plotTabHandle(title)
%PLOTTABHANDLE Summary of this function goes here
%   Detailed explanation goes here
   
    figure('Name', title, 'Visible', 'off', 'Unit', 'norm', 'Position', [.1, .1, .9, .8], 'WindowScrollWheelFcn',@figScroll);

    hc = uiflowcontainer('v0', 'Units','norm');
    set(hc,'FlowDirection','TopDown');
    tg = uitabgroup(hc, 'SelectionChangedFcn', @tg_cb);
    
    ph = uipanel('Parent',hc);
    set(ph, 'HeightLimits', [25, 30]);
    
    phh = uiflowcontainer('v0', 'Parent', ph, 'Margin', 5);       
    btn1 = uicontrol(phh, 'Style', 'togglebutton', 'String', 'Go');
    txt1 = uicontrol(phh, 'String', 'from', 'Style', 'text');
    edt1 = uicontrol(phh, 'Style', 'edit', 'String', '0.1');
    sld1 = uicontrol(phh, 'Style', 'slider','SliderStep',[0.01 0.1]);
    txt2 = uicontrol(phh, 'String', 'window size', 'Style', 'text');
    edt2 = uicontrol(phh, 'Style', 'edit', 'String', '20');
    chk1 = uicontrol(phh, 'Style', 'checkbox', 'String', 'auto');

    set(btn1, 'WidthLimits', [30, 40]);
    set(txt1, 'WidthLimits', [30, 40]);
    set(txt2, 'WidthLimits', [70, 80]);
    set(edt1, 'WidthLimits', [50, 60]);
    set(edt2, 'WidthLimits', [50, 60]);
    set(chk1, 'WidthLimits', [50, 60]);

    set(btn1, 'callback', @go_cb);
    set(edt1, 'callback', @edtstart_cb);
    set(edt2, 'callback', @edtwinsize_cb);
    set(chk1, 'callback', @check_cb);
    
    hListener = addlistener(sld1,'ContinuousValueChange',@slider_cb);
    setappdata(sld1,'sliderListener',hListener); 
    
    maxx = 0;
    ax = 0;
    tab = tg.SelectedTab;
    axes = 0;
    
    samp_rate=evalin('base','samp_rate');
    
    t = timer;
    t.TimerFcn = @timer_cb;
    t.Period = 0.05;
    t.ExecutionMode = 'fixedRate';
    
    function tg_cb( h, ~)
        tab = h.SelectedTab;
        axes = tab.UserData;
        ax = size(axes,2);
        %{
        if getappdata(axes(1), 'nparam') == 1
            colormap hot;
        else
            colormap jet;
        end
        %}
        %plotVCursor( tab );
        x = zeros(ax, 1);
        for i=1:ax
            x(i) = getappdata(axes(i), 'maxx');
            if isempty(x(i))
                x(i) = 0;
            end
        end
        maxx = max(x);
        while maxx < str2double(edt2.String)
            edt2.String = num2str(str2double(edt2.String)/2);
        end
        if maxx - str2double(edt2.String) < 1
            edt2.String = num2str(str2double(edt2.String)/2);
        end
        maxs = maxx - str2double(edt2.String);
        if sld1.Value > maxs || sld1.Value < 0.01
            edt1.String = '1';
            sld1.Value = 0.01;
            chk1.Value = 1;
        end
        sld1.Min = 0;
        sld1.Max = maxs;      
        sld1.SliderStep = [1 10]/maxs;
%            sld1.SliderStep=[0.5 0.8]
        if ~chk1.Value
            scale_axis();
        end
    end

    function go_cb( h, ~ )
        if h.Value      % go button pressed
            start(t);         
        else
            stop(t);
        end
    end

    function check_cb( h, ~ )
        if h.Value
            for i = 1:ax
                tab.UserData(i).XLimMode = 'auto';
            end
        else
            for i = 1:ax
                tab.UserData(i).XLimMode = 'manual';
            end
            scale_axis();
        end
    end

    function slider_cb( h, ~)
        edt1.String = num2str(h.Value);
        scale_axis();
    end

    function edtstart_cb( h, ~ )
        sld1.Value = str2double(h.String);
        scale_axis();
    end

    function edtwinsize_cb( h, ~ )
        window = str2double(h.String);
        sx = maxx - window;
        if sld1.Value > sx
            sld1.Value = sx;
        end
        sld1.Max = sx;
        scale_axis();
    end

    function timer_cb( ~, ~ )
        if sld1.Value < sld1.Max - t.Period
            sld1.Value = sld1.Value + t.Period;
            edt1.String = num2str(sld1.Value);
            scale_axis();
        else
            btn1.Value = 0;
            stop(t);
        end
    end

    function scale_axis()
        %colormap jet;
        x = sld1.Value;
        chk1.Value = 0;
        window = str2double(edt2.String);
        if chk1.Value
            k = 1:maxx;
        else
            k = int16(x*samp_rate):int16((x+window)*samp_rate);
        end
        for i = 1:ax
            d = getappdata(axes(i), 'data');
            cb = getappdata(axes(i), 'cb');
            if isa(cb, 'function_handle')
                subplot(axes(i));
                scale = getappdata(axes(i), 'scale');
                if scale > 1 && ~chk1.Value
                    k = int16(x*samp_rate/scale+1):int16((x+window)*samp_rate/scale);
                end
                if k(1) == 0
                    k = k(2:end);
                end
                np = getappdata(axes(i), 'nparam');
                switch np
                    case 1
                        cb(d(k,:));
                    case 2
                        cb(d(k,:), window);
                    case 3
                        temp1 = d{1};
                        temp3 = d{3};
                        cb(temp1(1,k),d{2},temp3(k,:));
                    case 4
                        cb(d(k,1), [], [], samp_rate);
                    case 22
                        temp1  = d{1};
                        temp2  = d{2};
                        cb(temp1(:,k), temp2(:,k));
                end
            elseif getappdata(axes(i), 'len') > 100
                tab.UserData(i).XLim = [x, x+window];
            end
        end

    end

    function figScroll(~, evnt)
        h = sld1;
        s = evnt.VerticalScrollCount;
        step = s * 0.05 * str2double(edt2.String);
        disp('');
        k = h.Value + step;
        if k < h.Min
            k = h.Min;
        elseif k > h.Max
            k = h.Max;
        end
        h.Value = k;
        edt1.String = num2str(h.Value);
        scale_axis();
    end


end
