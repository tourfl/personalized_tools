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


		%% call the C++ binary
		function run(obj, params)
			switch size(params, 1)
				case 3
					params = [obj.rho; params; params; params];
				case 4
					params = [params(1); params(2:4); params(2:4); params(2:4)];
				case 9
					params = [obj.rho; params];
				case 10
					params = params;
				otherwise
					error('bad number of params: should be 3, 4, 9 or 10.');
			end

			run@VCE(obj, params);
		end
	end
end