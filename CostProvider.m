classdef CostProvider < handle
	%COSTPROVIDER owe some cost functions

	methods(Static)

		function cost = meanDiff(Ref, B)
			% sum of squared dif of each channel mean

			% mean of images, channel by channel
			mRef = mean(mean(Ref));
			mB	 = mean(mean(B));

			% sum of squared differences
			cost = sum((mRef - mB).^2);
		end

		function [ err ] = delta_e( Ref, B )
			%DELTA_E error based on cie00de

			% DANGER: images need to be corrected

		  [err,~,~] = compute_errors_dehazing(Ref, B);

		end

		%% Same as before but for a single channel
		function err = delta_e_single(Ref, B, channel)
			if(~exist('channel', 'var'))
				channel = 1; end

			Ref = repmat(Ref(:,:, channel), [1 1 3]);
			B = repmat(B(:,:, channel), [1 1 3]);

			err = CostProvider.delta_e(Ref, B);
		end

		%% compute given cost on only one point per area
		function cost = onePerArea(Ref, B, areasCoordinates, atomicCostFunc)
			if(~exist('atomicCostFunc', 'var'))
				atomicCostFunc = @immse; end

			cost = 0;

			for coordinates=areasCoordinates
				refPoint = Ref(coordinates(1), coordinates(2), :);
				bPoint	 = B(coordinates(1), coordinates(2), :);
				cost = cost + atomicCostFunc(refPoint, bPoint);
			end
		end

		function cost = hueCost(Ref, B)
			% RGB to HSV
			Ref = rgb2hsv(Ref);
			B = rgb2hsv(B);

			% cost on hue
			cost = immse(Ref(:,:,1), B(:,:,1));
		end

		function cost = saturationCost(Ref, B)
			% RGB to HSV
			Ref = rgb2hsv(Ref);
			B = rgb2hsv(B);

			% cost on hue
			cost = immse(Ref(:,:,2), B(:,:,2));
		end

		function cost = valueCost(Ref, B)
			% RGB to HSV
			Ref = rgb2hsv(Ref);
			B = rgb2hsv(B);

			% cost on hue
			cost = immse(Ref(:,:,3), B(:,:,3));
		end
	end

end
