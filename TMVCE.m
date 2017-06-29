classdef TMVCE < VCE
	%OSA wrapper of OSA

	properties(Constant)
		rho = 0;
	end

	properties
		cmd_path = '../sira_tmo/bin/tm';
	end

	methods
		function obj = TMVCE(filename_input, filename_output)
			obj = obj@VCE(filename_input, filename_output);
		end



		function run(obj, params)
			% call the C++ binary
			numeric_params = [obj.rho; params(1:end)];

			run@VCE(obj, numeric_params);
		end

		function tm_only(obj)
			% call the same algorithm but avoid the variational part
			params = obj.params_tm;

			obj.run(params);
		end
	end
end