classdef (Abstract) MondrianHandler < handle
%MONDRIANHANDLER base class to work with Mondrian

	properties(Constant)
    	filenameTemp = '../results/intermediate/mondrian';

		no_correction = @(I) I;
		gamma_correction = @(I) I.^1.0/2.2;
	end
	properties
		space
		solution
		experiment
		funcCorrection
	end

	methods
		function obj = MondrianHandler(space, solution)
			% Constructor

			obj.space = space;
			obj.solution = solution;

			if strcmp(space, 'HDR')
				% input images need not to be corrected
				obj.funcCorrection = @MondrianHandler.toneMapping;
			else
				obj.funcCorrection = obj.gamma_correction;
			end
		end
	end

	methods(Static)
		function Iout = toneMapping(Iin)
			% Do tone-mapping using the tm + osa C++ algo - not very clean

			fileIn = [MondrianHandler.filenameTemp '.pfm'];
			fileOut= [MondrianHandler.filenameTemp '.png'];

			write_pfm(Iin, fileIn);

			vce = TMVCE(fileIn, MondrianHandler.filenameTemp);  % constructed images will erase the input
			vce.tm_only();

			Iout = im2double(imread(fileOut));
		end
	end
end