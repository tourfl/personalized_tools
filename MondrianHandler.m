classdef MondrianHandler < handle
%MONDRIANHANDLER base class to work with Mondrian Images
%	This is an abstract class (owns abstract methods).
% See VceTester or MondrianBuilder for more sense.

	properties(Constant)
  end

  properties(SetAccess = protected)
    experiment
    space
    solution
	end

   properties

    filenames  % something like filenames.raw_input, filenames.output, filenames.algo_input

    Iexperimental
    Iperceptual

    Ipres  % see Presenter for more info
    titlePres

    % I/O stuff
		readImage
		writeImage
	end

	methods

		function obj = MondrianHandler(space, solution, experiment)
			% Constructor for Mondrian Building

			% check existence of parameters. Order is important when calling it!
			if ~exist('experiment', 'var'), experiment = 'None'; end

			obj.filenames = MondrianNamer(space, solution, experiment);

			obj.space = space;
			obj.solution = solution;
			obj.experiment = experiment;


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

		function showInputs(obj)
			id = obj.simpleHash(obj.experiment)
			titleBase = [obj.experiment, 'exp, solution', num2str(obj.solution), ', ', obj.space ', ']

			I1 = obj.Iexperimental;
			I2 = obj.Iperceptual;

			figure(id), imshow(I1./max(I1(:))), title([titleBase 'illuminated']), pause(.1);
			figure(id+1), imshow(I2./max(I2(:))), title([titleBase 'percepted']); pause(.1);
		end

		function showPres(obj)
			% show the presentation image constructed by buildPres

			if(~obj.buildPres)
				return
			end

			id = obj.simpleHash(obj.experiment)+100;
			figure(id), set(id, 'Position', [800 100 1700 500]), imshow(obj.Ipres), pause(0.1), title([obj.titlePres ' - ' obj.experiment 'exp'])
		end

		%% saveCurrentPres: save the image build with buildPres
		function savePres(obj)
			if(~obj.buildPres)
				return
			end

			obj.writeOutput(obj.Ipres, 'presentation');
		end

		%% Setters (some properties are dangerous)

		function set.experiment(obj, experiment)
			% DANGER: need to modify the filenames

			obj.experiment = experiment;

    	obj.filenames.buildFilenames(obj.space, obj.solution, experiment);
		end
	end

	methods(Abstract)
		loadExisting(obj);
		buildPres(obj);
	end

	methods(Static)
		% create a numeric identifiant from the given string, useful for figure id!
		function hash = simpleHash(experiment)
			numExp = double(experiment);

			hash = (numExp(1) + numExp(end)) * 2;
		end
	end
end

