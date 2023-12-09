
<!-- README.md is generated from README.Rmd. Please edit that file -->

# CourseRec

<!-- badges: start -->
<!-- badges: end -->

The main goal of CourseRec is to help the user find a fourth class to
take in a given semester at Smith College, according to user inputted
criteria.

## Installation

You can install the development version of CourseRec from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("rlong711/CourseRec")
```

## Scraping a courses data set

The user would first scrap their own data set from the Smith College
course search website (‘<https://www.smith.edu/apps/course_search/>’)
for specified semesters to be used with all the package functions:

``` r
library(CourseRec)

course_data <- scrap_course_data(2022, 'SPRING')
```

## Basic course recommender

Given 3 classes the user already plans to take, the course_recommend
function returns all courses that do not have a time conflict:

``` r
test_input <- c('AFR11701', 'AFR15501', 'AFR202am01')

classes <- course_recommend(test_input, course_data)
classes # wrong here, it's recommending AFR202am01
#>   [1] "AFR202am01"  "AFR24501"    "AFR31001"    "AFR33301"    "AMS20101"   
#>   [6] "AMS23401"    "AMS23501"    "AMS26701"    "AMS30201"    "AMS340cc01" 
#>  [11] "AMS35501"    "ANT13002"    "ANT22101"    "ANT22601"    "ANT22901"   
#>  [16] "ANT23301"    "ANT27301"    "ANT33301"    "ARH11001"    "ARH11002"   
#>  [21] "ARH11003"    "ARH25001"    "ARH27801"    "ARH280cv01"  "ARH280mc01" 
#>  [26] "ARH280ss01"  "ARH291ra01"  "ARH352gt01"  "ARS16202"    "ARS16301"   
#>  [31] "ARS16303"    "ARS17201"    "ARS27501"    "ARS36101"    "ARS36201"   
#>  [36] "ARS384lv01"  "ARS39901"    "ARX14101"    "ARX34001"    "AST10201"   
#>  [41] "AST102L01"   "AST11301"    "AST20001"    "BCH25201"    "BCH25301"   
#>  [46] "BCH25302"    "BCH33501"    "BCH33601"    "BIO12301"    "BIO12302"   
#>  [51] "BIO12303"    "BIO13101"    "BIO13102"    "BIO13103"    "BIO13104"   
#>  [56] "BIO13201"    "BIO132D01"   "BIO132D02"   "BIO132D03"   "BIO132D04"  
#>  [61] "BIO13301"    "BIO13302"    "BIO13303"    "BIO20501"    "BIO20502"   
#>  [66] "BIO23001"    "BIO230D01"   "BIO230D02"   "BIO230D03"   "BIO23101"   
#>  [71] "BIO23102"    "BIO23103"    "BIO23104"    "BIO26001"    "BIO26101"   
#>  [76] "BIO26401"    "BIO26501"    "BIO27301"    "BIO30001"    "BIO30601"   
#>  [81] "BIO30701"    "BIO31001"    "BIO314ls01"  "BIO314se01"  "BIO314te01" 
#>  [86] "BIO33001"    "BIO33201"    "BIO33301"    "BIO350qg01"  "BIO37101"   
#>  [91] "BIO37301"    "BIO390cr01"  "BKX30001"    "CCX32001"    "CHM100ao01" 
#>  [96] "CHM10801"    "CHM22202"    "CHM222L01"   "CHM222L02"   "CHM222L03"  
#> [101] "CHM222L04"   "CHM222L05"   "CHM222L06"   "CHM222L07"   "CHM222L08"  
#> [106] "CHM222L09"   "CHM224L01"   "CHM224L03"   "CHM224L04"   "CHM32601"   
#> [111] "CHM326L01"   "CHM32801"    "CHM33201"    "CHM332L01"   "CHM336L01"  
#> [116] "GRK21501"    "LAT21401"    "LAT330om01"  "CSC11102"    "CSC11103"   
#> [121] "CSC11104"    "CSC15101"    "CSC20501"    "CSC22301"    "CSC23101"   
#> [126] "CSC25001"    "CSC26201"    "CSC29401"    "CSC32701"    "CSC37001"   
#> [131] "DAN11401"    "DAN12101"    "DAN13301"    "DAN142fl01"  "DAN142wa01" 
#> [136] "DAN15101"    "DAN15102"    "DAN20201"    "DAN21201"    "DAN22301"   
#> [141] "DAN23001"    "DAN24601"    "DAN31701"    "DAN32501"    "DAN33901"   
#> [146] "DAN377sa01"  "DAN39901"    "DAN500ms01"  "CHI11101"    "CHI111D01"  
#> [151] "CHI22101"    "CHI221D01"   "CHI30201"    "CHI35201"    "EAL23201"   
#> [156] "EAL23401"    "EAL24401"    "EAL25301"    "EAL253F01"   "EAL360rw01" 
#> [161] "JPN11101"    "JPN11103"    "JPN111D01"   "JPN111D03"   "JPN22101"   
#> [166] "JPN221D01"   "JPN30201"    "KOR10202"    "KOR10203"    "KOR30201"   
#> [171] "ECO12501"    "ECO15002"    "ECO15003"    "ECO15301"    "ECO15303"   
#> [176] "ECO20101"    "ECO22001"    "ECO220L01"   "ECO220L02"   "ECO220L03"  
#> [181] "ECO23801"    "ECO250D01"   "ECO250D02"   "ECO25301"    "ECO253D01"  
#> [186] "ECO253D02"   "ECO26001"    "ECO26101"    "ECO29501"    "ECO31401"   
#> [191] "ECO33101"    "ECO33801"    "EDC23101"    "EDC23801"    "EDC27801"   
#> [196] "EDC29901"    "EDC31101"    "EDC33101"    "EDC336rm01"  "EDC34001"   
#> [201] "EDC345D01"   "EDC34601"    "EDC39001"    "EDC55201"    "EGR100hh01" 
#> [206] "EGR100hhL01" "EGR100sw01"  "EGR100swL01" "EGR11002"    "EGR11003"   
#> [211] "EGR22002"    "EGR220L01"   "EGR220L02"   "EGR29001"    "EGR36301"   
#> [216] "EGR374L01"   "EGR374L02"   "EGR37601"    "EGR37701"    "EGR390ge01" 
#> [221] "EGR410D01"   "EGR422D01"   "ENG11001"    "ENG11201"    "ENG118lf01" 
#> [226] "ENG118lg01"  "ENG118ss01"  "ENG12501"    "ENG12502"    "ENG12504"   
#> [231] "ENG12505"    "ENG13601"    "ENG17001"    "ENG19902"    "ENG20001"   
#> [236] "ENG20301"    "ENG206ff01"  "ENG21601"    "ENG21901"    "ENG22101"   
#> [241] "ENG23001"    "ENG24101"    "ENG25601"    "ENG27101"    "ENG28201"   
#> [246] "ENG291us01"  "ENG296ps01"  "ENG30101"    "ENG333ca01"  "ENG33901"   
#> [251] "ENV10101"    "ENV10801"    "ENV20101"    "ENV20201"    "ENV22901"   
#> [256] "ENV31201"    "ENV32301"    "ENV32701"    "ESS11001"    "ESS13001"   
#> [261] "ESS21001"    "ESS22001"    "ESS25001"    "ESS26101"    "ESS261L02"  
#> [266] "ESS310L01"   "ESS505D01"   "ESS506D01"   "ESS57001"    "ESS57601"   
#> [271] "ESS901ab01"  "ESS901bg01"  "ESS920aa01"  "ESS925aa02"  "ESS940ar01" 
#> [276] "ESS940ra02"  "ESS940wc01"  "ESS940wk01"  "ESS945pa01"  "ESS945pa02" 
#> [281] "ESS945pb01"  "ESS945wt01"  "ESS945wt02"  "ESS975gy01"  "ESS975gy02" 
#> [286] "FMS232F01"   "FMS24201"    "FMS25101"    "FMS251F01"   "FMS28001"   
#> [291] "FMS280F01"   "FMS282ap01"  "FMS282apF01" "FMS29001"    "FMS34501"   
#> [296] "FMS345F01"   "FRN10301"    "FRN22002"    "FRN230cw01"  "FRN230fr01" 
#> [301] "FRN230tl01"  "FRN251fi01"  "FRN282md01"  "FRN29501"    "FRN392sc01" 
#> [306] "FYS10101"    "FYS10501"    "FYS12801"    "FYS13901"    "FYS18701"   
#> [311] "FYS19801"    "GEO10801"    "GEO108L01"   "GEO108L02"   "GEO20101"   
#> [316] "GEO222L01"   "GEO22301"    "GEO24101"    "GEO241L01"   "GEO25101"   
#> [321] "GEO251L01"   "GEO301L01"   "GER110Y02"   "GER25001"    "GER27101"   
#> [326] "GER369hc01"  "GOV10001"    "GOV10002"    "GOV20301"    "GOV203L01"  
#> [331] "GOV203L02"   "GOV20601"    "GOV21401"    "GOV22701"    "GOV22801"   
#> [336] "GOV23801"    "GOV24101"    "GOV24801"    "GOV25201"    "GOV25501"   
#> [341] "GOV26201"    "GOV27101"    "GOV27301"    "GOV345pd01"  "GOV348ca01" 
#> [346] "GOV367et01"  "GOV36901"    "HSC211pn01"  "HST15001"    "HST227mm01" 
#> [351] "HST23701"    "HST24001"    "HST259sp01"  "HST26701"    "HST28701"   
#> [356] "HST288mi01"  "HST30101"    "HST383dw01"  "IDP10601"    "IDP11801"   
#> [361] "IDP13201"    "IDP13202"    "IDP13203"    "IDP13205"    "IDP13206"   
#> [366] "IDP13207"    "IDP13501"    "IDP23201"    "IDP32501"    "SPE10001"   
#> [371] "ITL110Y02"   "ITL11101"    "ITL13501"    "ITL20001"    "ITL22001"   
#> [376] "ITL25001"    "ITL369hc01"  "JUD23001"    "JUD26001"    "LAS201gm01" 
#> [381] "LAS29101"    "LAS301ae01"  "LSS10001"    "LSS20001"    "LSS24501"   
#> [386] "LSS31501"    "ARA10102"    "ARA20101"    "ARA30101"    "MES21901"   
#> [391] "MES23701"    "MES24001"    "MTH11102"    "MTH11103"    "MTH11104"   
#> [396] "MTH11203"    "MTH11204"    "MTH11205"    "MTH15302"    "MTH20501"   
#> [401] "MTH21102"    "MTH21202"    "MTH25501"    "MTH270ss01"  "MTH30001"   
#> [406] "MTH301rs01"  "MTH333la01"  "MTH364pd01"  "MUS100fm01"  "MUS20201"   
#> [411] "MUS21001"    "MUS210L01"   "MUS21701"    "MUS23101"    "MUS24901"   
#> [416] "MUS26201"    "MUS32101"    "MUS32501"    "MUS90301"    "MUS90601"   
#> [421] "MUS95101"    "MUS95201"    "MUS95301"    "MUS95401"    "MUS95501"   
#> [426] "MUS95601"    "MUS95701"    "MUS95801"    "MUS95901"    "MUS96001"   
#> [431] "MUX30001"    "NSC13001"    "NSC21002"    "NSC23002"    "NSC230L01"  
#> [436] "NSC230L02"   "NSC32401"    "PHI10101"    "PHI12001"    "PHI125D02"  
#> [441] "PHI20001"    "PHI20401"    "PHI250ig01"  "PHI25201"    "PHI25501"   
#> [446] "PHI330sc01"  "PHI34501"    "PHY11702"    "PHY117D01"   "PHY117D02"  
#> [451] "PHY118D01"   "PHY21002"    "PHY21501"    "PHY242L01"   "PHY242L03"  
#> [456] "PHY30001"    "PHY31901"    "PHY350L01"   "PSY12001"    "PSY13001"   
#> [461] "PSY14001"    "PSY15001"    "PSY18001"    "PSY20201"    "PSY20203"   
#> [466] "PSY20204"    "PSY21601"    "PSY25301"    "PSY26401"    "PSY26501"   
#> [471] "PSY26901"    "PSY30401"    "PSY314cf01"  "PSY31701"    "PSY34301"   
#> [476] "PSY352pt01"  "PSY36402"    "PSY37401"    "PSY37601"    "PYX30101"   
#> [481] "REL16401"    "REL17101"    "REL20101"    "REL23801"    "REL24901"   
#> [486] "REL29301"    "REL30401"    "REL305ec01"  "RES100Y01"   "RES27501"   
#> [491] "SDS19201"    "SDS201L02"   "SDS22001"    "SDS22002"    "SDS220L02"  
#> [496] "SDS220L03"   "SDS220L04"   "SDS27001"    "SDS29101"    "SDS36402"   
#> [501] "SDS41001"    "SOC10101"    "SOC10102"    "SOC10103"    "SOC10104"   
#> [506] "SOC20301"    "SOC21201"    "SOC22401"    "SOC23001"    "SOC23201"   
#> [511] "SOC23701"    "SOC32501"    "SOC34001"    "POR12501"    "POR21201"   
#> [516] "POR21501"    "POR381fw01"  "SPN20001"    "SPN20002"    "SPN22001"   
#> [521] "SPN22002"    "SPN24101"    "SPN246jl01"  "SPN260dl01"  "SPN33701"   
#> [526] "SPN372sb01"  "SWG15001"    "SWG15003"    "SWG24101"    "SWG29001"   
#> [531] "SWG30301"    "SWG30501"    "SWG36001"    "THE10001"    "THE15401"   
#> [536] "THE19901"    "THE21201"    "THE21301"    "THE242im01"  "THE25301"   
#> [541] "THE312sp01"  "THE31901"    "THE319L01"   "THE36001"    "TSX33001"   
#> [546] "WLT15001"    "WLT20301"    "WLT21201"    "WLT23201"    "WLT24001"   
#> [551] "WLT27001"    "WLT33001"    "WLT34101"
```

## Adding criteria to course recommender

The user can choose to add more criteria than time to return more
specialized courses. For example, they can find all possible courses
based on time and a specific department:

``` r
classes_dept <- course_recommend_dept(test_input, 'MTH', course_data)
classes_dept
#>     course_id
#> 1    MTH11102
#> 2    MTH11103
#> 3    MTH11104
#> 4    MTH11203
#> 5    MTH11204
#> 6    MTH11205
#> 7    MTH15302
#> 8    MTH20501
#> 9    MTH21102
#> 10   MTH21202
#> 11   MTH25501
#> 12 MTH270ss01
#> 13   MTH30001
#> 14 MTH301rs01
#> 15 MTH333la01
#> 16 MTH364pd01
#>                                                                                                    course_name
#> 1                                                                        \n            Calculus I\n           
#> 2                                                                        \n            Calculus I\n           
#> 3                                                                        \n            Calculus I\n           
#> 4                                                                       \n            Calculus II\n           
#> 5                                                                       \n            Calculus II\n           
#> 6                                                                       \n            Calculus II\n           
#> 7                                              \n            Introduction to Discrete Mathematics\n           
#> 8                                                          \n            Modeling in the Sciences\n           
#> 9                                                                    \n            Linear Algebra\n           
#> 10                                                           \n            Multivariable Calculus\n           
#> 11                                                                     \n            Graph Theory\n           
#> 12                                            \n            Topics in Geometry-The Shape of Space\n           
#> 13                                          \n            Dialogues in Mathematics and Statistics\n           
#> 14                                          \n            Topics in Advanced Mathematics-Research\n           
#> 15                               \n            Topics in Abstract Algebra-Advanced Linear Algebra\n           
#> 16 \n            Advanced Topics in Continuous Applied Mathematics-Partial Differential Equations\n           
#>       course_instructor                                  meeting_time
#> 1         Candice Price Monday/Wednesday/Friday | 10:50 AM - 12:05 PM
#> 2     Daniel Schultheis   Monday/Wednesday/Friday | 1:20 PM - 2:35 PM
#> 3         Candice Price   Monday/Wednesday/Friday | 8:00 AM - 9:15 AM
#> 4     Jennifer Beichman   Monday/Wednesday/Friday | 2:45 PM - 4:00 PM
#> 5     Rebecca E Targove   Monday/Wednesday/Friday | 8:00 AM - 9:15 AM
#> 6     Jennifer Beichman Monday/Wednesday/Friday | 10:50 AM - 12:05 PM
#> 7       Christophe Golé   Monday/Wednesday/Friday | 2:45 PM - 4:00 PM
#> 8        Ileana Streinu   Monday/Wednesday/Friday | 1:20 PM - 2:35 PM
#> 9             Pau Atela        Tuesday/Thursday | 10:50 AM - 12:05 PM
#> 10     Geremias Polanco   Monday/Wednesday/Friday | 1:20 PM - 2:35 PM
#> 11    Theo Douvropoulos        Tuesday/Thursday | 10:50 AM - 12:05 PM
#> 12 Patricia Renate Cahn Monday/Wednesday/Friday | 10:50 AM - 12:05 PM
#> 13        Candice Price                  Thursday | 1:20 PM - 2:35 PM
#> 14        Candice Price                   Tuesday | 7:00 PM - 9:30 PM
#> 15 Julianna S. Tymoczko          Monday/Wednesday | 7:00 PM - 8:20 PM
#> 16         Luca Capogna          Tuesday/Thursday | 2:45 PM - 4:00 PM
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  description
#> 1                                                                                                                                                                                                                                                                                                                                                                                                                                          Rates of change, differentiation, applications of derivatives including differential equations and the fundamental theorem of the calculus. Written communication and applications to other sciences and social sciences motivate course content.
#> 2                                                                                                                                                                                                                                                                                                                                                                                                                                          Rates of change, differentiation, applications of derivatives including differential equations and the fundamental theorem of the calculus. Written communication and applications to other sciences and social sciences motivate course content.
#> 3                                                                                                                                                                                                                                                                                                                                                                                                                                          Rates of change, differentiation, applications of derivatives including differential equations and the fundamental theorem of the calculus. Written communication and applications to other sciences and social sciences motivate course content.
#> 4                                                                                                                                                                                                                                                                                                                                                                                     Techniques of integration, geometric applications of the integral, differential equations and modeling, infinite series and approximation of functions. Written communication and applications to other sciences and social sciences motivate course content. Prerequisite: MTH 111 or the equivalent.
#> 5                                                                                                                                                                                                                                                                                                                                                                                     Techniques of integration, geometric applications of the integral, differential equations and modeling, infinite series and approximation of functions. Written communication and applications to other sciences and social sciences motivate course content. Prerequisite: MTH 111 or the equivalent.
#> 6                                                                                                                                                                                                                                                                                                                                                                                     Techniques of integration, geometric applications of the integral, differential equations and modeling, infinite series and approximation of functions. Written communication and applications to other sciences and social sciences motivate course content. Prerequisite: MTH 111 or the equivalent.
#> 7                                                                                                                                                                                                                                                                                                                                                                                                                                   An introduction to discrete (finite) mathematics with emphasis on the study of algorithms and on applications to mathematical modeling and computer science. Topics include sets, logic, graph theory, induction, recursion, counting and combinatorics.
#> 8                                                                                   Offered CSC 205 and MTH 205. This course integrates the use of mathematics and computers for modeling various phenomena drawn from the natural and social sciences. Scientific topics, organized as case studies, span a wide range of systems at all scales, with special emphasis on the life sciences. Mathematical tools include data analysis, discrete and continuous dynamical systems and discrete geometry. This is a project-based course and provides elementary training in programming using Mathematica. Prerequisites: MTH 112 or MTH 114. CSC 111 recommended. Enrollment limited to 20.
#> 9                                                                                                                                                                                                                                                                                                          Systems of linear equations, matrices, linear transformations, vector spaces. Applications to be selected from differential equations, foundations of physics, geometry and other topics. Students may not receive credit for both MTH 211 and MTH 210. Prerequisite: MTH 112 or the equivalent, or MTH 111 and MTH 153; MTH 153 is suggested. Enrollment limited to 35 students.
#> 10                                                                                                                                                                                                                                                                                                  Theory and applications of limits, derivatives and integrals of functions of one, two and three variables. Curves in two-and three-dimensional space, vector functions, double and triple integrals, polar, cylindrical, spherical coordinates. Path integration and Green’s Theorem. Prerequisites: MTH 112. It is suggested that MTH 211 be taken before or concurrently with MTH 212.
#> 11                                                                                                                                                                                                                The course begins with the basic structure of graphs including connectivity, paths, cycles and planarity. e proceed to study independence, stability, matchings and colorings. Directed graphs and networks are considered. In particular, some optimization problems including maximum flow are covered. The material includes theory and mathematical proofs as well as algorithms and applications. Prerequisites: MTH 153 and MTH 211 or permission of the instructor.
#> 12                                                                                                                                                                                                                                                          This is a course in intuitive geometry and topology, with an emphasis on hands-on exploration and developing the visual imagination. Topics may include knots, geometry and topology of surfaces and the Gauss-Bonnet Theorem, symmetries, wallpaper patterns in Euclidean, spherical and hyperbolic geometries, and an introduction to 3-dimensional manifolds. Prerequisites: MTH 211 and 212 or permission of the instructor.
#> 13                                                                                                                                                 In this class we don’t do math as much as we talk about doing math and the culture of mathematics. The class includes lectures by students, faculty and visitors on a wide variety of topics, and opportunities to talk with mathematicians about their lives. This course is especially helpful for those considering graduate school in the mathematical sciences. Prerequisites: MTH 211, MTH 212 and two additional mathematics courses at the 200-level, or permission of the instructor. May be repeated once for credit. S/U only.
#> 14                                                                                                                                                                                                 In this course students work in small groups on original research projects. Students are expected to attend a brief presentation of projects at the start of the semester. Recent topics include interactions between algebra and graph theory, plant patterns, knot theory, and mathematical modeling. This course is open to all students interested in gaining research experience in mathematics. Prerequisites vary depending on the project, but normally 153 and 211 are required.
#> 15                                                                                                                                                                                                                                                                                                                       This is a second course in linear algebra that explores the structure of matrices. Topics may include characteristic and minimal polynomials, diagonalization and canonical forms of matrices, the spectral theorem, the singular value decomposition theorem, an introduction to modules, and applications to problems in optimization, Markov chains, and others.
#> 16 Partial differential equations allow us to track how quantities change over multiple variables, e.g. space and time. This course provides an introduction to techniques for analyzing and solving partial differential equations and surveys applications from the sciences and engineering. Specific topics include Fourier series, separation of variables, heat, wave and Laplace’s equations, finite difference numerical methods, and introduction to pattern formations. Prerequisite: MTH 211, MTH 212, and MTH 264 strongly recommended) or MTH 280/281, or permission of the instructor. Prior exposure to computing (using Matlab, Mathematica, Python, etc.) will be helpful.
```

## Learning about information to specific courses

The user can also retrieve specific information about a certain course
they are interested in, such as the meeting time of that course:

``` r
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
course_meeting_time('SDS27001', course_data)
#>                             meeting_time
#> 1 Tuesday/Thursday | 10:50 AM - 12:05 PM
```
