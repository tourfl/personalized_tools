classdef Filenamer < handle
	%FILE_NAMER helps to build filenames according to the exp

	properties(Constant)
		HDRext = '.pfm';
		RGBext = '.png';  % including LMS space images
	end

	properties
		% exp
		solution
		space

		% paths
		inPath
		outPath

		% for building
		inExt
		basename

		% filenames
		base
		raw_input
		perceptual
		algo_input = '../results/intermediate/algo_input.png';
		algo_output = '../results/intermediate/algo_output.png';
		best_output
	end
	methods
		function obj = Filenamer(space, solution, experiment, runId)
			% build an object containing proper filenames

			obj.solution = solution;
			obj.space = space;

			obj.inPath = ['~/Code/mondrian_exp/images/' space '/solution' num2str(solution) '/'];
			obj.outPath= ['~/Code/mondrian_exp/results/' space '/' experiment 'exp/run' num2str(runId) '_s' num2str(solution) '/'];

			if space == 'HDR'
				obj.inExt = obj.HDRext;
			else
				obj.inExt = obj.RGBext;
			end

			obj.basename = [experiment 'exp_s' num2str(solution) '_' space];

			obj.base = obj.buildBaseFilename();
			obj.raw_input = obj.buildInFilename();
			obj.perceptual = obj.buildInFilename('percepted');
			obj.best_output = obj.buildOutFilename();
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