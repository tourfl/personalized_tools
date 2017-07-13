classdef VCE < handle
	%VCE wrapper of VCE algorithm developed in C++

	properties(Abstract=true)
		cmd_path
	end

	properties(Constant)
	end

	properties
		filename_input
		filename_output
	end

	methods
		function obj = VCE(filename_input, filename_output)
			obj.filename_input = filename_input;
			obj.filename_output = filename_output;
		end

		function run(obj, params)
			% call the C++ binary

			cmd = [obj.cmd_path ' ' obj.filename_input ' ' obj.filename_output];

			cmd = [cmd ' "'];
			for n=params'
				cmd = [cmd ' ' num2str(n)];
			end
			cmd = [cmd '"'];

			[status output] = system(cmd);
		end
	end
end