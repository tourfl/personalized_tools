classdef MondrianNamer2 < handle
	%MONDRIANNAMER interface to build filenames according to the exp

	properties(Access = private)
		% pathes that dont depend on experiment and runId
		inDir = '~/Code/mondrian_exp/images/';
		outDir = '~/Code/mondrian_exp/results/';

		% full pathes
		inPath
		outPath

		% extensions
		inExt
		outExt
	end

	methods
		%% MondrianNamer2: constructor
		function obj = MondrianNamer2(space, solution, experiment, runId)

			% building directories
			obj.inDir = [obj.inDir space '/solution' num2str(solution) '/'];
			obj.outDir= [obj.outDir space '/'];

			% building pathes, if possible
			if (nargin == 4 && ~strcmp(experiment, 'None') && runId ~= 0)
				obj.buildOutPath(solution, experiment, runId);
			end
		end

		%% buildOutPath: based on obj.outDir, solution, experiment and runId
		function buildOutPath(obj, solution, experiment, runId)
				obj.outPath = [obj.outDir experiment 'exp/run' num2str(runId) '_s' num2str(solution) '/'];
		end

		function filename = buildFilename(obj, mypath, filename)
			if isempty(mypath)
				fprintf('Impossible to build filename: path is void. Could be missing experiment or runid\n');
				return;
			end
		end

		%% setOutDir: setter for outDir
		function setOutDir(obj, mypath), obj.outDir = mypath; end

		function pth = getInDir(obj), pth = obj.inDir; end
		function pth = getOutDir(obj), pth = obj.outDir; end

		function pth = getInPath(obj), pth = obj.inPath; end
		function pth = getOutPath(obj), pth = obj.outPath; end
	end
end
