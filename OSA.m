classdef OSA < VCE
	%OSA wrapper of OSA

	properties(Constant)
		% Bypassed properties
		sigmamu = 30;
		sigmamub= 30;  % narrow neighborhood width for mean kernel
		peso	= 10;  % weight for wide mean kernel
		pesob	=  1;  % weight for narrow mean kernel
	end

	properties
		cmd_path = '../vce/bin/osa';
	end

	methods
		function obj = OSA(filename_input, filename_output)
			obj = obj@VCE(filename_input, filename_output);
		end

		%% call the C++ binary
		function run(obj, params)
			switch size(params, 1)
				case 3
					params = [params; params; params];
				case 9
					params = params;
				otherwise
					error('bad number of params: should be 3 or 9.');
			end

			run@VCE(obj, params);
		end
	end

end