################## Introduction to VMR ######################
Vehicle Manufacturer Recognition(VMR) is a popular vision-based system widely used in secure access, vehicle verification and traffic monitoring applications. This paper proposes an investigation into recognizing the make of a car from its brand logo. Recognizing an automobile’s make is a challenging task due to lack of discriminative features and close appearance of automobile logos. This paper presents a relatively simple algorithm using cross-correlation to detect the logo location and recognize the make of car in the given image. This algorithm is assessed on a set of 300 test images(self-created dataset) and has resulted in promising accuracy for logo detection as well as recognition.

################### Literature Survey #####################
Refer https://github.com/pratikbongale/Vehicle-Make-Recognition/blob/master/Project_Report_Bongale_Pratik.pdf

################### Quick Overview ##########################
Refer https://github.com/pratikbongale/Vehicle-Make-Recognition/blob/master/Logo_Detection_Recognition.pptx

################### To Run the Demo Code ####################
Test_all.m:
To test all demo pics.


Logo_Recognition_Demo.m:
Demo program to recognize the make of car in the input image. 

Input parameters:
1. File name of query image


find_deg_of_confidence.m:
Finds the degree of confidence obtained from correlation between a brand's template and input image.

Input parameters:
1. fn: File name of query image.
2. template_to_use: template of brand to find correlation with.


create_logo_template.m

Input parameters:
1. fn: file name to extract logo from
2. brand: the make of the template to be extracted.

******Note: In order to run the demo program, you can simply run the script Logo_Recognition_Demo.m without any parameters.********
