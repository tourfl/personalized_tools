classdef CorrectionProvider < handle
	%CORRECTIONPROVIDER owe some non-linear functions

	properties(Constant)
		g = 1.0/2.2;
		n = 0.74;
	end

	properties
	end

	methods
	end

	methods(Static)
		function Iout = nakaRushton(Iin, n)
			% allow to apply Naka-Rushton equation
			if(~exist('n', 'var')), n=CorrectionProvider.n; end

			mn = mean(Iin(:));
			md = median(Iin(:));

			Es = mn^.5*md^.5;

			Iout = Iin.^n ./ (Iin.^n + Es.^n);
		end


		% Could have used quick declaration but it is less readable


		function Iout = noCorrection(Iin, n)
			Iout = Iin;
		end

		function Iout = gammaCorrection(Iin, g)
			Iout = Iin.^CorrectionProvider.g;
		end

		function Iout = gamma_normalized(Iin, g)
			Iout = CorrectionProvider.gammaCorrection(Iin);
			Iout = Iout./max(Iout(:));
		end

		function Iout = whiteBalance(Iin, g)
			% transform achieved in camera, could be seen as a correction

			% estimate of the illuminant is 2*average
			ill = 2*mean(mean(Iin));

			Iout = Iin./ill;
		end

		%% toneMapping: achieve tone mapping though a Cpp executable
		function Iout = toneMapping(Iin, rho)
			if(~exist('rho', 'var')), rho=0; end

			nameIn = '/home/raph/Code/mondrian_exp/results/intermediate/tone_map_in.pfm';
			nameOut= '/home/raph/Code/mondrian_exp/results/intermediate/tone_map_out.png';

			write_pfm(Iin, nameIn);

			toneMapper = TMVCE(nameIn, nameOut);
			params = zeros(9, 1);

			toneMapper.run(params);
		
			Iout = im2double(imread(nameOut));
		end
	end
end