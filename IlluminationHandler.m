classdef IlluminationHandler < IlluminationAbstractHandler
	%ILLUMINATIONHANDLER helps use illuminants

	properties(Access = private)
	end

	methods
		function obj = IlluminationHandler(solution, space)
			% Construct an object with existing values
			obj = obj@IlluminationAbstractHandler(solution, space);

			load(obj.filename);

			obj.Magnituds = Magnituds;

			if strcmp(space, 'HDR')
				% input images need not to be scaled
				obj.scalingCoef = 1;
			elseif solution == 1
				obj.scalingCoef = rescale_illum;
			else
				obj.scalingCoef = scaling_coef(space);
			end

			fprintf(1, 'scalingCoef = %i\n', obj.scalingCoef);
		end
	end
end