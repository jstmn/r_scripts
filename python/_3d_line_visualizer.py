import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import numpy as np
from matplotlib.widgets import Slider
from sympy import sin, cos, Matrix
from sympy.abc import phi, chi, psi

thetas = np.deg2rad(np.array([0, 90, 90]))    # Degrees

L1 = 5
L2 = 6
L3 = 4.0


def get_soa():

    def sin(x):
        return np.sin(x)
    def cos(x):
        return np.cos(x)
    def sqrt(x):
        return np.sqrt(x)

    r0 = np.array([0,0,0])
    r1 = np.array([0,0,L1])

    r2x = L2*cos(thetas[0])*sin(thetas[1])
    r2y = L2*sin(thetas[0])*sin(thetas[1]) 
    r2z = L1 - L2*cos(thetas[1])
    r2 = np.array( [r2x, r2y, r2z  ])

    alpha = -(thetas[1] -(thetas[2]-np.pi)  )
    r3_dxy = L3 * sin(-alpha)
    r3x = r2x + r3_dxy*cos(thetas[0])
    r3y = r2y + r3_dxy*sin(thetas[0])
    r3z = r2z - L3*cos(-alpha)
    r3 = np.array([r3x, r3y, r3z])

    soa = np.array([ np.concatenate([r0,r1-r0]), 
                     np.concatenate([r1,r2-r1]), 
                     np.concatenate([r2,r3-r2])
                     ])

    # phi = theta0
    # chi = theta1
    # psi = theta2

    #Matrix([L2*cos(thetas[0])*sin(thetas[1])+L3*sin(-alpha)*, rho*sin(phi), rho**2])
    #print "beta (deg):",np.rad2deg(beta),"\t, dxy:",r3_dxy
    #print "L3:",L3," measured:",np.sqrt(   (r3-r2)[0]**2 + (r3-r2)[1]**2 + (r3-r2)[2]**2)
    #print "L3:",L3," measured:",np.sqrt(   (r3-r2)[0]**2 + (r3-r2)[1]**2 + (r3-r2)[2]**2),"\t, beta (deg):",np.rad2deg(beta),"\t, dxy:",r3_dxy
    #print "l2:",L2," measured:",np.sqrt(   (r2-r1)[0]**2 + (r2-r1)[1]**2 + (r2-r1)[2]**2)
    return soa

def update1(val):
    thetas[0] = np.deg2rad(theta1_slider.val)
    update_plot()

def update2(val):
    thetas[1] = np.deg2rad(theta2_slider.val)
    update_plot()

def update3(val):
    thetas[2] = np.deg2rad(theta3_slider.val)
    update_plot()   

def update_plot():
    soa = get_soa()
    X, Y, Z, U, V, W = zip(*soa)
    ax.clear()
    update_ax_u1()
    ax.quiver(X, Y, Z, U, V, W)

    fig.canvas.draw_idle()

def update_ax_u1():
    ax.set_xlim([-10, 10])
    ax.set_ylim([-10, 10])
    ax.set_zlim([-10,10])
    ax.set_xlabel("x")
    ax.set_ylabel("y")
    ax.set_zlabel("z")
    set_aspect_equal_3d(ax)

def set_aspect_equal_3d(ax):
    """Fix equal aspect bug for 3D plots."""

    xlim = ax.get_xlim3d()
    ylim = ax.get_ylim3d()
    zlim = ax.get_zlim3d()

    from numpy import mean
    xmean = mean(xlim)
    ymean = mean(ylim)
    zmean = mean(zlim)

    plot_radius = max([abs(lim - mean_)
                       for lims, mean_ in ((xlim, xmean),
                                           (ylim, ymean),
                                           (zlim, zmean))
                       for lim in lims])

    ax.set_xlim3d([xmean - plot_radius, xmean + plot_radius])
    ax.set_ylim3d([ymean - plot_radius, ymean + plot_radius])
    ax.set_zlim3d([zmean - plot_radius, zmean + plot_radius])


fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
update_plot()
plt.subplots_adjust(left=0.0, bottom=0.25)

axamp1 = plt.axes([0.25, 0.15, 0.65, 0.03], facecolor='lightgoldenrodyellow')
axamp2 = plt.axes([0.25, 0.10, 0.65, 0.03], facecolor='lightgoldenrodyellow')
axamp3 = plt.axes([0.25, 0.05, 0.65, 0.03], facecolor='lightgoldenrodyellow')
theta1_slider = Slider(axamp1, 'theta1', 0, 360.0, valinit=thetas[0])
theta2_slider = Slider(axamp2, 'theta2', 0, 360.0, valinit=thetas[1])
theta3_slider = Slider(axamp3, 'theta3', 0, 360.0, valinit=thetas[2])
theta1_slider.set_val(np.rad2deg(thetas[0]))
theta2_slider.set_val(np.rad2deg(thetas[1]))
theta3_slider.set_val(np.rad2deg(thetas[2]))
theta1_slider.on_changed(update1)
theta2_slider.on_changed(update2)
theta3_slider.on_changed(update3)

update_ax_u1()




plt.show()