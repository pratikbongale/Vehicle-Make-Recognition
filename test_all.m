function test_all()
    

    addpath( [ 'Dataset_Logo_Recognition' filesep() 'Honda_Test_Set' filesep() ] );
    addpath( [ 'Dataset_Logo_Recognition' filesep() 'Toyota_Test_Set' filesep() ] );
    addpath( [ 'Demo_Dataset' filesep() ] );

%     imagefiles = dir('Dataset_Logo_Recognition\Honda_Test_Set\*.jpg');      
%     imagefiles = dir('Dataset_Logo_Recognition\Toyota_Test_Set\*.jpg');     
    imagefiles = dir('Demo_Dataset\*.jpg');      
    
%     nfiles = length(imagefiles);    % Number of files found

    % limiting the files for this demo
    nfiles = 4;
    
    for f_index = 1 : nfiles
       fname = imagefiles(f_index).name;
       fprintf('Processing file %d: %s', f_index, fname);
       Logo_Recognition_Demo(fname);
%        pause(2);
    end

end