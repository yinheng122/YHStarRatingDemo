# YHStarRatingDemo
More convenient ratingStar
YHStarRating use of the manual: - - - - - - - - - - - - - - - - - - - - - - - - - - - -
YHStarRating.h and YHStarRating.m files are introduced
1. add the YHStarRating.h header file to your Controller
2. choose how you layout: use AutoLayout in the layout of the constraints or pure bounds layout (the default use of pure code bounds layout) - (void) chooseWayYouUse: (wayYouUse) way
Enum typedef {
UseCode = 0,
UseAutoLayout
}wayYouUse;
3. Adding in the place you want to control the view used to add a review of the controls, the size of the view, depends on the size of your rating star controls 
4.to create a initWithFrame:view.bounds [YHStarRating - alloc] view 
If you want to modify the star control for other operations . Modify several of his properties:
(1) ShowStar has just come out to show the number of stars
(2) FontSize is used to fill in the size of the star you want to fill in the fontSize of the size of the View width 1/5. Use this property to be used with chooseWayYouUse: (wayYouUse) way and way using UseAutoLayout
(3) Bool isSelect type selection yes said to be able to slide the score, no said the score controls only do show
(4) The color of the place where the emptyColor is not rated
(5) The color of the place shown in the fullColor
(6) The block and the proxy are the rating stars returned after sliding. Useing the block need to turn on the switch.


If you have a better suggestion, welcome to send suggestions to:
                                   yinheng122@163.com

