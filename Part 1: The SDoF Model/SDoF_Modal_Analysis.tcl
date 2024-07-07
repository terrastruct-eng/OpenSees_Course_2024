
################################################################################
### Your first OpenSees (tcl) model(s)
### TERRASTRUCT LTD
### terrastruct.co.uk
################################################################################

# Example SDoF_Modal_Analysis
# Units: kN, m, s

# Objective: to perform a modal analysis

# Remove any previous analyses
wipe

################################################################################
### GLOBAL GEOMETRY
################################################################################

# Set up the space dimensions and degrees of freedom
# model BasicBuilder -ndm $ndm <-ndf $ndf>                          
model  BasicBuilder  -ndm  1  -ndf  1 

################################################################################
### NODES
################################################################################

# Define nodes and their location
# node $nodeTag (ndm $coords) <-mass (ndf $massValues)>                             
node     1     0.0; 
node     2     0.0;  

# Define constraints
# fix $nodeTag (ndf $constrValues)                                              
fix      1     1;
   
################################################################################
### MATERIALS
################################################################################     

# Define a variable for the material name
set Elastic_mat1 1;

# Define material
# uniaxialMaterial Elastic $matTag $E <$eta> <$Eneg>
uniaxialMaterial Elastic $Elastic_mat1 5000; # kN/m
                        
################################################################################
### ELEMENT DEFINITIONS
################################################################################

# Define geometry and material for the elements
# element zeroLength $eleTag $iNode $jNode -mat $matTag1 $matTag2 -dir $dir1 $dir2
element  zeroLength 1 1 2  -mat  $Elastic_mat1  -dir  1 ;

################################################################################
### MASSES
################################################################################

# mass $nodeTag (ndf $massValues)
mass 2 10.0;

################################################################################
### RECORDERS
################################################################################

recorder  Node -file A_Eigen_vector.txt  -node 1 2  -dof 1  eigen1 

################################################################################
### MODAL ANALYSIS
################################################################################

# Define pi
set pi [expr acos(-1.0)] 

# Perform eigen analysis and store in lambda
# set lambda [eigen -genBandArpack 1] 
set lambda [eigen -fullGenLapack 1] 
# set lambda [eigen 1]  

# Create file to record modal properties
set eigFID [open A_Modal_properties.txt w]  
# Write into file   
puts $eigFID " lambda          omega           period          frequency" 
foreach lambda $lambda { 
    set omega [expr sqrt($lambda)] 
    set period [expr 2.0*$pi/$omega] 
    set frequ [expr 1.0/$period] 
    puts $eigFID [format " %+2.6e  %+2.6e  %+2.6e  %+2.6e" $lambda $omega $period $frequ] 
} 
# Close file
close $eigFID 

# Record eigenvectors 
record 

# Remove any previous analyses
wipe