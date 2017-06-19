classdef Presenter < handle
	%PRESENTER build presentation of multiples images

	properties(Static)
		sep_size = 100;
	end

	methods(Static)
		function Iout = build(varargin)
			% return a presentation, try to see how it looks
			% /!\ supposed that argin are images of same size

			size_in = size(varargin{1}); size_im = size_in
			size_im(2) = size_im(2) * nargin + (nargin - 1) * Presenter.sep_size

			Iout=zeros(size_im);

			for i=0:nargin-1
				Iout(:, 1 + i*(size_in + Presenter.sep_size):size_in + i*(size_in + Presenter.sep_size), :) = varargin{1};
			end

			Iout = Iout./max(Iout(:));
		end
	end
end