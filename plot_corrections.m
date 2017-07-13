% self-explanatory file name!

close all

%% building the data for each correction function
Iin= 0:0.1:10;

Ig = CorrectionProvider.gammaCorrection(Iin);
Inr= CorrectionProvider.nakaRushton(Iin);

Itm_tmp = repmat(Iin, [101 1 3]);  % must be a true 3-channel image
Itm_tmp = CorrectionProvider.toneMapping(Itm_tmp);
Itm = Itm_tmp(1, :, 1);

%% plotting
figure(44)
plot(Iin, Ig, 'k'); hold on
plot(Iin, Inr, 'g');
plot(Iin, Itm, 'b');
title('corrections function')
xlabel('value input'), ylabel('value output')
legend('gamma', 'Naka-Rushton', 'Tone Mapping from Sira' ,'Location', 'SouthEast')