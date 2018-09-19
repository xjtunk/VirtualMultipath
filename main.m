function main()

clear;

directory   = [pwd,'\data\'];
fname       = 'respiration.mat';
Rxpath      = [directory, fname];
samp_rate   = load([Rxpath(1:end-4),'.txt']);
rxNum       = 1;
mSub        = 17;
ws          = floor(3*samp_rate);
smScale     = 0.45;

m_dealAssignin(directory, fname, samp_rate, rxNum, mSub, ws, smScale);

csi         = load(Rxpath);
rxCSI       = csi.rxCSI;
time        = (1:size(rxCSI,3))/samp_rate;
pc          = cell(1,rxNum);
for i=1:rxNum
    pc{1,i} = squeeze([rxCSI([35:64],2,:);rxCSI([2:31],2,:)])';
end

%% CSI plot 
plotVirtualMultipath(time, pc);

end

