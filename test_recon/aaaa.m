% Example usage
image1 = imread('./data_1/a1-188.png');
image2 = imread('./data_1/a0-188.png');
fused_image = fuse_images(image1, image2);
imshow(fused_image);

function fused_image = fuse_images(image1, image2)
    % Convert the input images to grayscale
    % Compute the histogram of the input images
    hist1 = imhist(image1);
    hist2 = imhist(image2);
    
    % Normalize the histograms
    hist1 = hist1 / sum(hist1);
    hist2 = hist2 / sum(hist2);
    
    % Compute the Jensen-Rényi divergence
    divergence = compute_jensen_renyi_divergence(hist1, hist2);
    
    % Compute the fusion weights based on the divergence
    weight1 = 0.5 * (1 + divergence);
    weight2 = 0.5 * (1 - divergence);
    imshow([weight1 weight2],[]);
    % Perform pixel-wise fusion
    fused_image = weight1 * double(image1) + weight2 * double(image2);
    fused_image = uint8(fused_image);
end

function divergence = compute_jensen_renyi_divergence(hist1, hist2)
    % Ensure that the histograms have the same length
    assert(length(hist1) == length(hist2), 'Histogram lengths should be the same');

    % Add a small epsilon value to avoid division by zero
    epsilon = 1e-10;

    % Compute the normalized histograms
    hist1 = hist1 / sum(hist1);
    hist2 = hist2 / sum(hist2);

    % Compute the Jensen-Rényi divergence
    divergence = sum(hist1 .* log((hist1 + epsilon) ./ (hist2 + epsilon))) + sum(hist2 .* log((hist2 + epsilon) ./ (hist1 + epsilon)));
end

