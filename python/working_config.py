from __future__ import print_function
import math
import datetime

class RobotConstants(object):

    def __init__(self ):

        # Link indexes
        self.TORSO_LINK_INDEX = 5
        self.f_r_active_dofs = [7, 8, 9, 10, 11, 12, 13]
        self.f_l_active_dofs = [31, 32, 33, 34, 35, 36, 37]
        self.b_r_active_dofs = [15,16,17,18,19,20,21]
        self.b_l_active_dofs = [23,24,25,26,27,28,29]

        # robot states
        self.FORWARD = "FORWARD"
        self.BACKWARD = "BACKWARD"
        self.LEFT = "LEFT"
        self.RIGHT = "RIGHT"
        self.BASE_STATE = "BASE_STATE"

        self.F_R_FOOT = "F_R_FOOT"
        self.F_L_FOOT = "F_L_FOOT"
        self.B_R_FOOT = "B_R_FOOT"
        self.B_L_FOOT = "B_L_FOOT"

        self.allowed_states = [self.FORWARD,self.BACKWARD, self.BASE_STATE, self.LEFT, self.RIGHT]

        self.left_feet     = [self.F_L_FOOT, self.B_L_FOOT ]
        self.right_feet    = [self.F_R_FOOT, self.B_R_FOOT ]
        self.end_effectors = [self.F_R_FOOT, self.F_L_FOOT, self.B_R_FOOT, self.B_L_FOOT]

        self.STARTING_CONFIG = [ 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0.02028, -1.13693, -0.22264, 1.78471, 0.11556, -2.20593, 0.26108, 0.00000, -0.00732, 1.13588, 0.20703, -1.72748, -0.10369, 2.15177, -0.22789, 0.00000, 0.01378, -1.13643, -0.20282, 1.72874, 0.10156, -2.15292, 0.22655, 0.00000, -0.01379, 1.13639, 0.20250, -1.72791, -0.10137, 2.15216, -0.22608]
        self.FR_STARTING_CONFIG = self.STARTING_CONFIG[7:7 + (7)]
        self.BR_STARTING_CONFIG = self.STARTING_CONFIG[15:15 + (7)]
        self.BL_STARTING_CONFIG = self.STARTING_CONFIG[23:23 + (7)]
        self.FL_STARTING_CONFIG = self.STARTING_CONFIG[31:31 + (7)]

        # App Wide states
        self.PROGRAM_RUNNING                     = True
        self.EMERGENCY_STOP = False

        # Gamepad input
        self.GAMEPAD_LEAST_SIGNIFICANT_INPUT     = .01

        # Debugging
        self.OBJ_PLANNER_DEBUGGING_ENABLED                = False
        self.USER_INPUT_DEBUGGING_ENABLED                 = False
        self.HIGH_LEVEL_MOTION_PLANNER_DEBUGGING_ENABLED  = True
        self.HIGH_LEVEL_MOTION_PLANNER_STEP_TIMES_PRINTED = False
        self.CONTROL_LOOP_DELAY_PRINTER_ENABLED           = False
        self.VELOCITY_LIMIT_DEBUGGING_ENABLED             = False
        self.TORQUE_LIMIT_DEBUGGING_ENABLED               = False

        # Delay Constants
        self.CONTROLLER_DT                       = .01
        self.GAMEPAD_UPDATE_DELAY                = .1
        self.OBJECTIVE_PLANNER_UPDATE_DELAY      = .05

        # Global IK constants
        self.IK_MAX_DEVIATION                    = .115
        self.TORSO_SHIFT_IK_MAX_DEVIATION        = .1

        # support shape safety margins
        self.END_RANGE_MULTIPLIER                = .965    # scale end effector range. .96: maximum range without ik failure
        self.SUPPORT_TRIANGLE_SAFETY_MARGIN      = .045   # scale support triangles. 0: no triangle margin, .07: maximum before stability failures

        # Starting Configuration
        self.BASE_STATE_X_DELTA                  = .3
        self.BASE_STATE_Y_DELTA                  = .3
        self.BASE_STATE_Z_DELTA                  = -.5 # This value is the delta z from the torso to the ground (/end effectors center point)

        # Robot Measurements
        self.SHOULDER_X                          = .293260631869
        self.SHOULDER_Y                          = .206456211
        self.SHOULDER_Z                          = -0.2085299999988
        self.LEG_LENGTH                          = .775
        self.SHOULDER_TORSO_XY_EUCLIDEAN_DIF     = 0.3603472707
        self.DELTA_Z_SHOULDER_END_AFFECTOR       = 0.980182 * (self.BASE_STATE_Z_DELTA) + .20965
        self.END_AFFECTOR_RADIUS_TO_SHOULDER     = math.sqrt(self.LEG_LENGTH**2 - self.DELTA_Z_SHOULDER_END_AFFECTOR**2)
        self.SHOULDER_TORSO_PSI_RADS             = .620089205322
        self.FORWARD_BACK_LEGS_EUCLIDEAN_DIST    = 2 * (self.SHOULDER_X + self.BASE_STATE_X_DELTA)
        self.LEFT_RIGHT_LEGS_EUCLIDEAN_DIST      = 2 * (self.SHOULDER_Y + self.BASE_STATE_Y_DELTA)

        # Visualization - determines if _2DSupport Objects are shown
        self.RESET_VISUALIZATION_ENABLED         = True
        self.FORWARD_STEP_VISUALIZATION_ENABLED  = True
        self.TURNING_VISUALIZATION_ENABLED       = True
        self.RANGE_CIRCLE_VISUALIZATION_ENABLED  = True
        self.SUPPORT_TRIANGLE_VISUALIZATION_ENABLED  = True
        self.COM_VISUALIZATION_ENABLED           = True

        # Visualization setup
        self.PLANNING_WORLD_VIS_NAME            = "planning world visualizer"
        self.PLANNING_WORLD_VIS_ID              = -1
        self.PLANNING_WORLD_VIS_TITLE           = "Planning World Vis. Window"

        # Reset Constants
        self.MINIMUM_DIST_TO_CAUSE_RESET         = .005 # If dist(xyz, xyz_desired) > this, end effector resets

        # Turn Constants
        self.TORSO_YAW_ROTATE_ANGLE_DEG          = 12

        # Step Constants
        self.STEP_Z_MAX_HIEGHT                   =  .1
        self.TORSO_SHIFT_DELTA                   =  .15    # TODO: This should be optimized or calculated.

        # Simulation constants
        self.SIMULATION_ENABLED                  = True
        self.INCLUDE_TERRAIN                     = True
        self.ODE_PHYSICS_ENABLED                 = False
        self.DUKE_MOTION_API_ENABLED             = True

        # Movement timing constants
        if self.ODE_PHYSICS_ENABLED:
            self.INITIALIZATION_STEP_TIME            = .75
            self.RESET_LEG_STEP_TIME                 = 3
            self.TURN_GAIT_STEP_TIME                 = 3
            self.RESET_TORSO_SHIFT_TIME              = 3
            self.TORSO_SHIFT_TIME                    = 6
            self.STEP_TIME                           = 3
            self.TORSO_YAW_ROTATE_TIME               = 3

            self.TURNING_MIDSTEP_SLEEP_T = 1
            self.RESET_MIDSTEP_SLEEP_T = 1
            self.FORWARD_GAIT_SLEEP_T = 1

        elif self.DUKE_MOTION_API_ENABLED:
            self.INITIALIZATION_STEP_TIME            = 1
            self.RESET_LEG_STEP_TIME                 = 1.5
            self.TURN_GAIT_STEP_TIME                 = 1.5
            self.RESET_TORSO_SHIFT_TIME              = 1.5
            self.TORSO_SHIFT_TIME                    = 1.5
            self.STEP_TIME                           = 3
            self.TORSO_YAW_ROTATE_TIME               = 2
            self.TURNING_MIDSTEP_SLEEP_T = .75
            self.RESET_MIDSTEP_SLEEP_T = .75
            self.FORWARD_GAIT_SLEEP_T = .75

        else:
            self.INITIALIZATION_STEP_TIME            = .25
            self.RESET_LEG_STEP_TIME                 = 1
            self.TURN_GAIT_STEP_TIME                 = .5
            self.RESET_TORSO_SHIFT_TIME              = 1.5
            self.TORSO_SHIFT_TIME                    = .25
            self.STEP_TIME                           = .25
            self.TORSO_YAW_ROTATE_TIME               = .25
            self.TURNING_MIDSTEP_SLEEP_T             = .25
            self.RESET_MIDSTEP_SLEEP_T               = .25
            self.FORWARD_GAIT_SLEEP_T                = .25

        # Automated User Input
        self.AUTOMATED_USER_INPUT                         = False
        self.AUTOMATED_GAITS                              = [self.FORWARD, self.LEFT, self.RIGHT]
        self.AUTOMATED_GAIT_PROBIBILITY_DIST              = [1,1,1]                                 # higher the number relative to others, higher the prob. of this with the associated action being taken
        self.AVERAGE_COMPLETE_CYCLES                      = 2.5

        # Save mid motion configurations to a specified file
        self.SAVE_CONFIGS = False
        self.SAVE_CONFIG_FILE = "./Resources/gait_configurations/"+self.get_file_save_name()
        self.SAVE_CONFIG_IK_FAILURE_KEY = "IK FAILURE"
        self.SAVE_CONFIG_RESET_KEY = "RESET"
        self.SAVE_CONFIG_SELF_COLLISION_ERR_KEY = "SELF COLLISION"

    def get_file_save_name(self):
        now = datetime.datetime.now()
        return now.strftime("%m-%d-%Y_%H:%M")