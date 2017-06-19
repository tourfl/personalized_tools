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
	end
end