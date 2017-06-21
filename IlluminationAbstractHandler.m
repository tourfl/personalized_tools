classdef (Abstract) IlluminationAbstractHandler < handle
	%ILLUMINATIONHANDLER helps use illuminants

	properties(Access = protected)
		solution
		space
		Magnituds
		scalingCoef

		filename
	end

	methods
		function obj = IlluminationAbstractHandler(solution, space)
			% Construct an object with existing values

			obj.solution = solution;
			obj.space = space;

			obj.filename = ['data/illum/illum' num2str(solution)];

			if solution == 1
				obj.filename = [obj.filename '_' space];
			end

			obj.filename = [obj.filename '.mat'];
		end

		function magnituds = getScaledMagnituds(obj, experiment)
			% Return a triplet of values (630 530 450 nm illuminant energy)

			magnituds = obj.scalingCoef * obj.Magnituds(experiment);
		end
	end
end