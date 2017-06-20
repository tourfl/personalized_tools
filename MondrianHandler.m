classdef (Abstract) MondrianHandler < handle
%MONDRIANHANDLER base class to work with Mondrian

	properties(Constant)
		no_correction = @(I) 1;
		gamma_correction = @(I) I.^1.0/2.2;
	end
	properties
		space
		solution
		experiment
		funcCorrection
	end

	methods
		function obj = MondrianHandler(space, solution)
			% Constructor

			obj.space = space;
			obj.solution = solution;

			if strcmp(space, 'HDR')
				% input images need not to be corrected
				obj.funcCorrection = obj.no_correction;
			else
				obj.funcCorrection = obj.gamma_correction;
			end
		end
	end
end