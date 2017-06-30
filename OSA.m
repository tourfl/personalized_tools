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



		function run(obj, params)
			% call the C++ binary
			numeric_params = [obj.sigmamu; obj.sigmamub; obj.peso; obj.pesob; params];

			run@VCE(obj, numeric_params);
		end
	end

end