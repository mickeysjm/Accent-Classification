function [result,cep2] = feature_extractor1(d,sr)
%%Calculation
% Calculate basic RASTA-PLP cepstra and spectra
[cep1, spec1] = rastaplp(d, sr);
% Calculate 12th order PLP features with RASTA
[cep2, spec2] = rastaplp(d, sr, 1, 12);
% Append deltas and double-deltas onto the cepstral vectors
del = deltas(cep2);
% Double deltas are deltas applied twice with a shorter window
ddel = deltas(deltas(cep2,5),5);
% Composite, 39-element feature vector, just like we use for speech recognition
cepDpDD = [cep2;del;ddel];
result = cepDpDD;

%% Visualization
% imagesc(cep2)
% axis xy
% title('RASTA-PLP cepstra')
% %Look at its regular spectrogram
% subplot(221)
% imagesc(cep1)
% axis xy
% %plot basic RASTA-PLP spectra
% subplot(222)
% imagesc(10*log10(spec1)); % Power spectrum, so dB is 10log10
% axis xy
% %plot basic RASTA-PLP cepstra
% subplot(223)
% imagesc(cep2)
% axis xy
% %plot 12th order PLP features with RASTA
% subplot(224)
% imagesc(10*log10(spec2));
% axis xy
 
end

