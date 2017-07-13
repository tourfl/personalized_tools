classdef MondrianNamer < handle
	%MONDRIANNAMER helps to build filenames according to the exp

	properties(Constant)
		HDRext = '.pfm';
		RGBext = '.png';  % including LMS space images

		algo_input = '../results/intermediate/algo_input';
		algo_output = '../results/intermediate/algo_output.png';
	end

	properties(Access = private)
		base
		raw_input
		perceptual
		basename

		% pathes that dont depend on experiment and runId
		inPath = '~/Code/mondrian_exp/images/';
		outDir = '~/Code/mondrian_exp/results/';

		outPath

		inExt
	end

	properties

		% for building

		% filenames
		best_output
	end
	methods
		%% MondrianNamer: constructor
		function obj = MondrianNamer(space, solution, experiment, runId)
			if space == 'HDR'
				obj.inExt = obj.HDRext;
			else
				obj.inExt = obj.RGBext;
			end

			% building directories
			obj.inPath = [obj.inPath space '/solution' num2str(solution) '/'];
			obj.outDir = [obj.outDir space '/'];

			% building pathes, if possible
			if (nargin == 4 && ~strcmp(experiment, 'None'))
				obj.buildFilenames(space, solution, experiment, runId);
			end
		end

		function makeDirs(obj)
		end

		%% Builders, i.e. custom setting

		function filename = buildInFilename(obj, specific)
			% build input filename, with the specific string - always images
			if nargin < 2, specific = ''; end

			filename = obj.buildFilename(obj.inPath, obj.basename, obj.inExt, specific);
		end

		function filename = buildBaseFilename(obj, space, solution, specific)
			if nargin < 4, specific = ''; end

			% build gray exp filename
			mybasename = ['grayexp_s' num2str(solution) '_' space];

			filename = obj.buildFilename(obj.inPath, mybasename, obj.inExt, specific);
		end

		function filename = buildOutFilename(obj, specific, extension)
			% build input filename, with specific string and extension
			if(~exist('specific', 'var')), specific=''; end
			if(~exist('extension', 'var')), extension='.png'; end

			filename = obj.buildFilename(obj.outPath, obj.basename, extension, specific);
		end

		%% buildOutPath: based on obj.outDir, solution, experiment and runId
		function buildOutPath(obj, solution, experiment, runId)
				if runId == 0
					obj.outPath = [obj.outDir 'solution' num2str(solution) '/'];
				else
					obj.outPath = [obj.outDir experiment 'exp/run' num2str(runId) '_s' num2str(solution) '/'];
				end

		end

		function buildFilenames(obj, space, solution, experiment, runId)
			if(~exist('runId', 'var')), runId=0; end

			obj.basename = [experiment 'exp_s' num2str(solution) '_' space];

			obj.base = obj.buildBaseFilename(space, solution);
			obj.raw_input = obj.buildInFilename();
			obj.perceptual = obj.buildInFilename('percepted');

			obj.buildOutPath(solution, experiment, runId);
			obj.best_output = obj.buildOutFilename();
		end

		%% Getters and Setters for dangerous properties

		function name = getBase(obj), name = obj.base; end
		function name = getRaw_input(obj), name = obj.raw_input; end
		function name = getPerceptual(obj), name = obj.perceptual; end
		function name = getAlgo_input(obj), name = [obj.algo_input obj.inExt]; end
		function name = getAlgo_output(obj), name = obj.algo_output; end

		%% setOutDir: setter for outDir
		function setOutDir(obj, mypath), obj.outDir = mypath; end

		function pth = getOutDir(obj), pth = obj.outDir; end

		function pth = getInPath(obj), pth = obj.inPath; end
		function pth = getOutPath(obj), pth = obj.outPath; end
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