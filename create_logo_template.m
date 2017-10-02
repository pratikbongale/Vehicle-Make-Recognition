function create_logo_template( fn, brand )
    
    if nargin < 1
        test_img = 'Honda_logo_template.jpg'; 
        brand = 'Honda';
    end
    
    % read image and resize it to 500x500
    inp_image = pre_processing_image( test_img );

    % select the logo region from the image
    imshow(inp_image, []);
    title('select logo region');
    [x, y] = ginput(2);
    x = round(x);
    y = round(y);
    im_cropped_logo = inp_image(y(1):y(2), x(1):x(2));
    imshow(im_cropped_logo, []);        
    title('Logo to match');

    % contrast adjustment by adaptive histogram equalization
    im_cropped_logo = imadjust(im_cropped_logo); 
    im_cropped_logo = fix_uneven_illumination(im_cropped_logo);
    figure;
    imshow(im_cropped_logo);
    title('Logo after contrast adjustment');

    % save the cropped logo template to a file
    file_name = sprintf('logo_template_%s.mat', brand);
    save( file_name, 'im_cropped_logo' );
end

function I = pre_processing_image(im) % im is the file name
    
    im_test_rgb = im2double(imread(im));    
    I = rgb2gray(im_test_rgb);
    
    im_rows = 500;
    im_cols = 500;
    
    % resize the image
    I = imresize(I, [im_rows im_cols]);

    % filter image using a guassian filter
    g_filter = fspecial('Gaussian', 30, 1);
    I = imfilter(I, g_filter, 'same', 'replicate');
    
    
end