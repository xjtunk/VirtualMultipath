function plotVirtualMultipath(time, rx)

directory= evalin('base','directory');
fname    = evalin('base','fname');
rxNum    = evalin('base','rxNum');
mSub     = evalin('base','mSub');
samp_rate= evalin('base','samp_rate');
smScale  = evalin('base','smScale');

c        = 1:size(rx{1,1}, 2);  % all 60 sub-carrier index

pcAmp    = cellfun( @abs, rx, 'UniformOutput', false );      
pc       = m_smoothing (  pcAmp, 10, samp_rate*smScale);         % 10 times for S-G denoise

g = plotTabHandle([' == plotPC ==  ', fname]);

%% === selected sub-carrier CSI's Amp and Phase Line ===
for i = 1 : rxNum          % 2 antennas
    [sp] = plotAddTab1( g, 'Raw data');
    subplot(sp(1));
    plotLine(time, abs(rx{1,i}(:,mSub)), 'Amplitude', ['Amp-rx_',num2str(i)]);
    hold on;
    plotLineB(time, abs(pc{1,i}(:,mSub)), 'Amplitude', ['Amp-rx_',num2str(i)]);
end

%% === selected sub-carrier CSI's Revised Amp and Phase ===
for k = 1:12
    phase = k*1/6*pi;
    for i = 1 : rxNum          % 2 antennas
        [sp] = plotAddTab1( g, [num2str(k*30),' degree']);
        subplot(sp(1));
        sAmp = mean(rx{1,i}(:,mSub));
        mPath= 2*sin(phase/2)*sAmp.*exp(-1i*(pi/2+phase/2));
        plotLine(time, abs(rx{1,i}(:,mSub)+mPath), 'Amplitude', ['Amp-rx_',num2str(i)]);
        hold on;
        for l = 1 : 10
           sPc = m_denoise(abs(rx{1,i}(:,mSub)+mPath),samp_rate*smScale);
        end
        plotLineB(time, sPc, 'Amplitude', ['Amp-rx_',num2str(i)]);
    end
end

%% === for audio record ===
aufile  = [directory, fname(1:end-4), '.m4a'];
if exist(aufile, 'file')
    [y, Fs] = audioread(aufile);
    auTime  = (1:length(y))/Fs;
    [sp] = plotAddTab1( g, 'Audio');
    subplot(sp(1));
    plotLine(auTime, y, 'Amplitude', 'Audio');
end

%% end
cb = get(g, 'SelectionChangedFcn');
cb(g, 0);
set(gcf, 'Visible', 'on');

disp('plot ok.');
end
