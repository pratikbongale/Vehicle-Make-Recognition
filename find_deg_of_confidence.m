function degree_of_confidence = find_deg_of_confidence( fn, template_to_use )
    
    %% load the template to be used for correlation with the querry image
    if strcmp( template_to_use, 'Honda' )
        load( 'logo_template_Honda.mat' );
    else    % if template to be used = 'Toyota'
        load( 'logo_template_Toyota.mat' );
    end
    
    %% Create a scale space from current logo to accomodate different scales
    
    im_rows = 70;   % largest template rows
    im_cols = 80;   % largest template columns
    template = imresize(im_cropped_logo, [im_rows im_cols]);
    
    ss_size = 10;    % number of scales/sizes created and considered
    scale_space = create_scale_space(template, ss_size);    
    
    %% Read the query image and perform necessary preprocessing
    if nargin < 1
        fn = 'Honda_01.jpg';     
    end
    test_img = fn;
    
    % setting default values for final image to display 
    im_output = im2double(imread(fn));
    im_output = imresize(im_output, [500 500]);
    
    im_cropped_image = pre_processing_image(test_img);      % get a 500x500 image
    
    % fix illumination changes in the scene
    im_cropped_image = fix_uneven_illumination(im_cropped_image);
    
    std = 0.75;                     % define standard deviation for the filter used on query image in corr2
    std_increment = 0.10;
    doc = zeros( ss_size, 1 );      % define the degree of confidence vector
    
    disp_image = cell(1, ss_size);
    
    %% Perform cross - correlation of query image with each template from the scale space
    
    for scaled_template = 1 : ss_size    % try cross- correlation with each image of scale space
       
       im_template = scale_space{scaled_template};  % template to be used in this iteration
       test_match = cross_corelation( im_cropped_image, im_template );       
       
       % draw a rectangle around the region in a temporary image and save it
       temp = im_output;
       [~, max_ind] = max(test_match(:));
       [max_r, max_c] = ind2sub(size(test_match), max_ind);
       box = [max_c - 30, max_r - 30, 60, 60 ]; % minx, miny, width, height
       im_to_save = insertShape(temp, 'rectangle', box, 'Color', 'green', 'LineWidth', 4);
       
       % save image in a cell array
       disp_image{scaled_template} = im_to_save;
       
       % find the corelation of the selected region with the template once again
       corr_template = im_template;
       t_size = size(im_template);  % size of correlation template
       
       % select a rectangular region to crop of the same size as the template
       crop_region = [ floor(max_c - t_size(2)/2), floor(max_r - t_size(1)/2), t_size(2)-1, t_size(1)-1];
       corr_query = imcrop(im_cropped_image, crop_region);
       
       % successively smooth the regions to match with the smoothness of template in scale space
       filter = fspecial('gaussian', 11, std);
       corr_query = imfilter( corr_query, filter, 'same', 'replicate');
       std = std + std_increment;
       
       % calculating the correlation coefficient of cropped region with the template.
       if all( size(corr_query) == size(corr_template) ) % to handle boundary conditions
          corr_coef = corr2(corr_query, corr_template);
          doc( scaled_template ) = corr_coef;   % degree of confidence of current template
       else
          doc( scaled_template ) = 0;
       end

    end         

    %% find and display the image with maximum degree of confidence(corr-coefficient)
    [max_doc, max_ind] = max(doc(:));   
    figure; 
    imagesc( disp_image{max_ind} );
    title( sprintf('Degree of Confidence for template (%s) : %4.4f', template_to_use, max_doc) );
    axis image;
    
    degree_of_confidence = max_doc; % return the degree of confidence

end

%% Helper Functions

function I = fix_uneven_illumination(img) 
    % calculate local average, gaus very large sigma
    g_filter = fspecial('Gaussian', 15, 8);
    im_blur = imfilter(img, g_filter, 'same', 'replicate');
    
    global_avg = mean(img(:));
    % subtract from value - local avg + global average
    I = img - im_blur + global_avg;
    
end


function cc_out_image = cross_corelation( img, template )   % original image, logo template 
        
    im_cropped_image = img; 
    im_cropped_logo = template;
    
    % find the mean of logo and normalize (pi - mean(p))/std(p)
    mean_logo = mean( im_cropped_logo(:) );
    std_logo = std( im_cropped_logo(:) );   % normalize by standard deviation
    logo_filter_wo_mean = (im_cropped_logo - mean_logo)/std_logo;
    
    %  Create a local average filter, the same size as the logo filter:
    local_avg_filter = ones( size(im_cropped_logo) ) / numel(im_cropped_logo);
    
    % apply this filter on the test image cropped region to find the qi-mean(q)
    
    % 1. smooth the image (calculate local mean)
    local_avg_resp          = imfilter( im_cropped_image, local_avg_filter, 'same', 'repl' ); 
    
    % 2. Normalize with standard deviation (qi - mean(q))/std(q)
    std_image = std(im_cropped_image(:));
    img_wo_local_mean       = (im_cropped_image - local_avg_resp) / std_image;
    
    % 3. local corelation (E ( (pi - mean(p))/std(p) )( (qi - mean(q))/std(q) )
    computed_local_corr     = imfilter( img_wo_local_mean, logo_filter_wo_mean, 'same', 'repl' );

    cc_out_image = computed_local_corr;
    
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

function I = pre_processing_logo(im) % im is the file name
    
    %
    % dont resize the logo like we did with the image
    %
    im_test_rgb = im2double(imread(im));    
    I = rgb2gray(im_test_rgb);

    g_filter = fspecial('Gaussian', 30, 1);
    I = imfilter(I, g_filter, 'same', 'replicate');    
    
end

function scale_space = create_scale_space(im, ss_size) 
        
    filter = fspecial('gaussian', 11, 0.75); % define a guassian filter
    scale_space = cell(1, ss_size);  % create a cell array with scale size specified

    tp_rows = size( im, 1 );
    tp_cols = size( im, 2 );
    diff = 5;
    
%     figure;
    for scale = 1 : ss_size
        
        % scale the image and test
        im = imfilter(im, filter, 'same', 'replicate' );
        im = imresize(im, [tp_rows tp_cols]);
        
        tp_rows = tp_rows - diff;
        tp_cols = tp_cols - diff;
        
        scale_space{scale} = im;

    end
end