classdef Filenamer < handle
	%FILE_NAMER helps to build filenames according to the exp

	properties(Constant)
		HDRext = '.pfm';
		RGBext = '.png';  % including LMS space images
	end

	properties(Access = private)
		base
		raw_input
		perceptual
		algo_input = '../results/intermediate/algo_input.png';
		algo_output = '../results/intermediate/algo_output.png';
		basename

		% paths
		inPath
		outPath
	end

	properties
		% exp
		solution
		space

		% for building
		inExt

		% filenames
		best_output
	end
	methods
		function obj = Filenamer(space, solution, experiment, runId)
			% build an object containing proper filenames

			obj.solution = solution;
			obj.space = space;

			if space == 'HDR'
				obj.inExt = obj.HDRext;
			else
				obj.inExt = obj.RGBext;
			end

			obj.setFilenames(experiment, runId);
		end

		function filename = buildInFilename(obj, specific)
			% build input filename, with the specific string - always images
			if nargin < 2, specific = ''; end

			filename = obj.buildFilename(obj.inPath, obj.basename, obj.inExt, specific);
		end

		function filename = buildBaseFilename(obj, specific)
			if nargin < 2, specific = ''; end

			% build gray exp filename
			basename = ['grayexp_s' num2str(obj.solution) '_' obj.space];

			filename = obj.buildFilename(obj.inPath, basename, obj.inExt, specific);
		end

		function filename = buildOutFilename(obj, specific, extension)
			% build input filename, with specific string and extension
			if(~exist('specific', 'var')), specific=''; end
			if(~exist('extension', 'var')), extension='.png'; end

			filename = obj.buildFilename(obj.outPath, obj.basename, extension, specific);
		end

		%% Getters and Setters for dangerous properties

		function pth = getInPath(obj), pth = obj.inPath; end
		function pth = getOutPath(obj), pth = obj.outPath; end
		function name = getBase(obj), name = obj.base; end
		function name = getRaw_input(obj), name = obj.raw_input; end
		function name = getPerceptual(obj), name = obj.perceptual; end
		function name = getAlgo_input(obj), name = obj.algo_input; end
		function name = getAlgo_output(obj), name = obj.algo_output; end



		function setFilenames(obj, experiment, runId)

			obj.inPath = ['~/Code/mondrian_exp/images/' obj.space '/solution' num2str(obj.solution) '/'];
			obj.outPath= ['~/Code/mondrian_exp/results/' obj.space '/' experiment 'exp/run' num2str(runId) '_s' num2str(obj.solution) '/'];

			obj.basename = [experiment 'exp_s' num2str(obj.solution) '_' obj.space];

			obj.base = obj.buildBaseFilename();
			obj.raw_input = obj.buildInFilename();
			obj.perceptual = obj.buildInFilename('percepted');
			obj.best_output = obj.buildOutFilename();
		end
	end

	methods(Static)
		function filename = buildFilename(mypath, basename, extension, specific)
			% construct Filename, with given arguments, specific could be void

			if nargin < 2 || strcmp(specific, '')
				specific = '';
			else
				specific = ['_' specific];
			end

			filename = [mypath basename specific extension];
		end
	end
end