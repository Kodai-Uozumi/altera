
#################################################
#
# Basic SDC for a DE2 Board
#
#################################################

# Create a base clock for each of the pins driven by cristals
create_clock -period "50MHz" CLOCK_50
create_clock -period "27MHz" CLOCK_27