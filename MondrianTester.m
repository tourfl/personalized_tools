classdef MondrianTester < MondrianHandler
%MONDRIANTESTER super class of VCETester and wbTester

	properties (SetAccess = protected)
		Iexperimental_corrected
		Iperceptual_corrected
		Ioutput
		Idiff

		corrFunc
		costFunc
	end

	methods
		%% MondrianTester: constructor
		function obj = MondrianTester(space, solution, corrFunc, costFunc, experiment)
			% check existence of parameters. Order is important when calling it!
			if ~exist('experiment', 'var'), experiment = 'None'; end
			if ~exist('costFunc', 'var'), costFunc = 'None'; end

			% superclass constructor call
			obj = obj@MondrianHandler(space, solution, experiment);

			obj.corrFunc = corrFunc;
			obj.costFunc = costFunc;
		end

		%% Plotting methods

		%% Plot Differences between images
		function obj = plotDiff(obj)
			obj.buildDiff;

			I = Presenter.build(obj.Idiff./max(obj.Idiff(:)), -obj.Idiff./max(-obj.Idiff(:)));

			figure(10), set(10, 'Position', [300 800 800 500]), imshow(I), pause(.1), title('Perceptual - Output and Output - Perceptual')
		end

		%% Saving methods

		%% save rendered image
		function save_output(obj)

			obj.writeOutput(obj.Ioutput);
		end

		%% Save Differences between images
		function saveDiff(obj)
			obj.buildDiff;

			I = Presenter.build(obj.Idiff./max(obj.Idiff(:)), -obj.Idiff./max(-obj.Idiff(:)));

			obj.writeOutput(I, 'diff');
		end

		%% buildPres: build Ipres, see Presenter
		function achieved = buildPres(obj)

			Iin = obj.Iexperimental_corrected;
			Iout= obj.Ioutput;
			Ipcp= obj.Iperceptual_corrected;

			if (isempty(Iin) || isempty(Ipcp))
				achieved = false;
				return
			end

			Iin = Iin./max(Iin(:));

			if (isempty(Iout))
				obj.Ipres = Presenter.build(Iin, Ipcp);
				obj.titlePres = 'input, perceptual';
			else
				obj.Ipres = Presenter.build(Iin, Iout, Ipcp);
				obj.titlePres = 'input, output, perceptual';
			end

			achieved = true;
		end

		%% allCosts: compute and display all costs
		function allCosts(obj)
			Iout= obj.Ioutput;
			Ipcp= obj.Iperceptual_corrected;

			disp('ALL COSTS')
			fprintf('\t%+20s: %-2.5f\n', func2str(obj.costFunc), obj.costFunc(Iout, Ipcp))
			fprintf('\t%+20s: %-2.5f\n', 'MSE on hue', CostProvider.hueCost(Iout, Ipcp))
			fprintf('\t%+20s: %-2.5f\n', 'MSE on saturation', CostProvider.saturationCost(Iout, Ipcp))
			fprintf('\t%+20s: %-2.5f\n', 'MSE on value', CostProvider.valueCost(Iout, Ipcp))
		end
	end

	methods(Access = private)

		%% buildDiff: construct Difference of Images
		function buildDiff(obj)
			obj.Idiff = obj.Ioutput - obj.Iperceptual_corrected;
		end
	end
end