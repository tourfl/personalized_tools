classdef MondrianHandler < handle
%MONDRIANHANDLER base class to work with Mondrian Images
%	it is not an abstract class, but it has not a lot of 
%	interest by itself. See VceTester or MondrianBuilder
%	for more sense.

	properties(Constant)
    end

  properties(Access = private)
    experiment
    space
    solution
		runId
	end

   properties

	    filenames  % something like filenames.raw_input, filenames.output, filenames.algo_input

	    Ibase
	    Iinput_raw
	    Iinput_corrected  % /!\ input of the algo
	    Ioutput
	    Iperceptual_raw
	    Iperceptual_corrected

	    Ipres  % see Presenter for more info

	    corrFunc
	    % I/O stuff
		readImage
		writeImage
	end

	methods

		function obj = MondrianHandler(space, solution, corrFunc, experiment, runId)
			% Constructor for Mondrian Building

			% check existence of parameters. Order is important when calling it!
			if ~exist('corrFunc', 'var'), corrFunc = @CorrectionProvider.noCorrection; end
			if ~exist('experiment', 'var'), experiment = 'None'; end
			if ~exist('runId', 'var'), runId = 0; end

			obj.space = space;
			obj.solution = solution;
			obj.corrFunc = corrFunc;
			obj.experiment = experiment;
			obj.runId = runId;

			obj.filenames = MondrianNamer(space, solution, experiment, runId);

			% I/O stuff depending on the space
			if strcmp(space, 'HDR')
				readImage = @read_pfm;
				obj.writeImage= @write_pfm;
			else
				readImage = @imread;
				obj.writeImage= @imwrite;
			end

			obj.readImage = @(x) im2double(readImage(x));

			% Load existing images
			obj.loadExisting;
		end

		function loadExisting(obj)
			% load existing files

			if strcmp(obj.experiment, 'None'), return, end

			obj.Ibase = obj.readImage(obj.filenames.getBase);
			obj.Iinput_raw = obj.readImage(obj.filenames.getRaw_input);
			obj.Iperceptual_raw = obj.readImage(obj.filenames.getPerceptual);

			if obj.runId == 0, return, end

			obj.Ioutput = obj.readImage(obj.filenames.best_output);
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

		function showOutput(obj)
			id = obj.simpleHash(obj.experiment)
			titleBase = [obj.experiment, 'exp, solution', num2str(obj.solution), ', ', obj.space ', ']

			figure(id), imshow(obj.Iinput_raw), title([titleBase 'illuminated']), pause(.1);
			figure(id+1), imshow(obj.Iperceptual_raw), title([titleBase 'percepted']); pause(.1);
		end

		function showPres(obj)
			% show the presentation image constructed by buildPres

			if(~obj.buildPres)
				return
			end

			if (isempty(obj.Ioutput))
				myTitle = 'input, perceptual';
			else
				myTitle = 'input, output, perceptual';
			end

			id = obj.simpleHash(obj.experiment)+100;
			figure(id), set(id, 'Position', [800 100 1700 500]), imshow(obj.Ipres), pause(0.1), title([myTitle ' - ' obj.experiment 'exp'])
		end

		%% saveCurrentPres: save the image build with buildPres
		function saveCurrentPres(obj)
			if(~obj.buildPres)
				return
			end

			obj.writeOutput(obj.Ipres, 'presentation');
		end

		%% Getters and Setters (some properties are dangerous)

		function space = getSpace(obj), space = obj.space; end
		function exp = getExperiment(obj), exp = obj.experiment; end
		function runId = getRunId(obj), runId = obj.runId; end

		function setExperiment(obj, experiment)
			% DANGER: need to modify the filenames

			obj.experiment = experiment;

    	obj.filenames.buildFilenames(obj.space, obj.solution, experiment, obj.runId);
		end


		function setRunId(obj, runId)
			% DANGER: need to modify the filenames

			obj.runId = runId;

    	obj.filenames.buildFilenames(obj.space, obj.solution, obj.experiment, runId);
		end
	end

	methods(Access = private)
		%% buildPres: build Ipres, see Presenter
		function achieved = buildPres(obj)

			Iin = obj.Iinput_corrected;
			Iout= obj.Ioutput;
			Ipcp= obj.Iperceptual_corrected;

			if (isempty(Iin) || isempty(Ipcp))
				achieved = false;
				return
			end

			if (isempty(Iout))
				obj.Ipres = Presenter.build(Iin, Ipcp);
			else
				obj.Ipres = Presenter.build(Iin, Iout, Ipcp);
			end

			achieved = true;
		end
		
	end

	methods(Static)
		% create a numeric identifiant from the given string, useful for figure id!
		function hash = simpleHash(experiment)
			numExp = double(experiment);

			hash = (numExp(1) + numExp(end)) * 2;
		end
	end
end

