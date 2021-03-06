classdef ImageHandler < handle
	%IMAGEHANDLER allows to read, write images with formatted titles

	properties
		filenamer
		readImage
		writeImage
	end

	methods
		function obj = ImageHandler(space, solution, experiment, runId)

			obj.filenamer = Filenamer(space, solution, experiment, runId);

			if strcmp(space, 'HDR')
				obj.readImage = @read_pfm;
				obj.writeImage= @write_pfm;
			else
				obj.readImage = @imread;
				obj.writeImage= @imwrite;
			end
		end

		function I = readBase(obj)
			filename = obj.filenamer.buildBaseFilename();

			I = im2double(obj.readImage(filename));
		end

		function I = readInput(obj, specific)
			if nargin < 2, specific = ''; end

			filename = obj.filenamer.buildInFilename(specific);

			I = im2double(obj.readImage(filename));
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

		function plotInput(obj, specific, option)
			% plot an input image, accept a scaled option

			if ~exist('specific','var'), specific = ''; end
			if ~exist('option','var'), option = ''; end

				I = obj.readInput(specific);

			if strcmp(option, 'scaled') || strcmp(option, 'rescaled')
				I = I./max(I(:));
			end

				figure, imshow(im2double(I));
		end
	end
end