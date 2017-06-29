classdef MondrianHandler < handle
%MONDRIANHANDLER base class to work with my Mondrian Images

	properties(Constant)
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
	    experiment
	    runId
	    corrFunc


	    % I/O stuff
		readImage
		writeImage
	end

	methods

		function obj = MondrianHandler(space, solution, experiment, corrFunc, runId)

			obj.space = space;
			obj.solution = solution;
			obj.experiment = experiment;
			obj.corrFunc = corrFunc;
			obj.runId = runId;


			% I/O stuff depending on the space
			if strcmp(space, 'HDR')
				readImage = @read_pfm;
				obj.writeImage= @write_pfm;
			else
				readImage = @imread;
				obj.writeImage= @imwrite;
			end

			obj.readImage = @(x) im2double(readImage(x));  % /!\ Not sure it will work

			filenames = Filenamer(space, solution, experiment, runId);

			obj.filenames = filenames;

			% Load existing images

			obj.Ibase = obj.readImage(filenames.base);
			obj.Iinput_raw = obj.readImage(filenames.raw_input);
			obj.Iperceptual = obj.readImage(filenames.perceptual);

			% Apply correction to the raw input image and save it under the algo_input filename

			obj.Iinput_corrected = corrFunc(obj.Iinput_raw);
			obj.writeImage(obj.Iinput_corrected, filenames.algo_input);
		end

		function writeInput(obj, I, specific)
			if nargin < 3, specific = ''; end

			mkdir(obj.filenamer.inPath);

			filename = obj.filenamer.buildInFilename(specific);

			obj.writeImage(I, filename);
		end

		function writeOutput(obj, I, specific)
			if nargin < 3, specific = ''; end

			mkdir(obj.filenamer.outPath);

			filename = obj.filenamer.buildOutFilename(specific);

			imwrite(I, filename);
		end

		%% Plotting functions

		function show()
			% TODO
		end
	end
end

