classdef MondrianHandler < handle
%MONDRIANHANDLER base class to work with Mondrian Images
%	it is not an abstract class, but it has not a lot of 
%	interest by itself. See VceTester or MondrianBuilder
%	for more sense.

	properties(Constant)
    end

    properties(Access = private)
	    experiment
		runId
	end

    properties

	    filenames  % something like filenames.raw_input, filenames.output, filenames.algo_input

	    Ibase
	    Iinput_raw
	    Iinput_corrected  % /!\ input of the algo
	    Ioutput
	    Iperceptual

	    space
	    solution


	    % I/O stuff
		readImage
		writeImage
	end

	methods

		function obj = MondrianHandler(space, solution, experiment, runId)
			% Constructor for Mondrian Building

			if ~exist('experiment', 'var'), experiment = 'None'; end
			if ~exist('runId', 'var'), runId = 0; end

			obj.space = space;
			obj.solution = solution;
			obj.experiment = experiment;
			obj.runId = runId;

			obj.filenames = Filenamer(space, solution, experiment, runId);

			% I/O stuff depending on the space
			if strcmp(space, 'HDR')
				readImage = @read_pfm;
				obj.writeImage= @write_pfm;
			else
				readImage = @imread;
				obj.writeImage= @imwrite;
			end

			obj.readImage = @(x) im2double(readImage(x));
		end

		function writeInput(obj, I, specific)
			if nargin < 3, specific = ''; end

			mkdir(obj.filenames.getInPath());

			filename = obj.filenames.buildInFilename(specific);

			obj.writeImage(I, filename);
		end

		function writeOutput(obj, I, specific)
			if nargin < 3, specific = ''; end

			mkdir(obj.filenames.getOutPath());

			filename = obj.filenames.buildOutFilename(specific);

			imwrite(I, filename);
		end

		%% Plotting functions

		function show()
			% TODO
		end

		%% Getters and Setters for dangerous properties

		function exp = getExperiment(obj), exp = obj.experiment; end
		function runId = getRunId(obj), runId = obj.runId; end

		function setExperiment(obj, experiment)
			% DANGER: need to modify the filenames

			obj.experiment = experiment;

			obj.filenames.setFilenames(experiment, obj.runId);
		end


		function setRunId(obj, runId)
			% DANGER: need to modify the filenames

			obj.runId = runId;

			obj.filenames.setFilenames(obj.experiment, runId);
		end
	end
end

