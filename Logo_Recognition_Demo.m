function Logo_Recognition_Demo( fname )
    
    if nargin < 1
        fname_h = 'honda_01.jpg';
        fname_t = 'toyota_01.jpg';
        fname = fname_h;    % testing for honda        
%         fname = fname_t;    % testing for toyota
    end
    
    % currently we can detect only two manufacturers (Honda, Toyota)
    nLogos = 2;
    doc = zeros( nLogos, 1 );   
    
    % testing whether its a Honda or Toyota make
    doc(1) = find_deg_of_confidence( fname, 'Honda' );   % run script to test using logo template of Honda
    doc(2) = find_deg_of_confidence( fname, 'Toyota' );  % run script to test using logo template of Toyota
    
    % read and display the input image
    im = imread(fname);
    figure;
    imshow(im);
    
    % find greater degree of confidence among the two
    if doc(1) > doc(2)
       title('Make: Honda');
    else
       title('Make: Toyota');        
    end
    
end