#!/usr/bin/env python
import matplotlib.pyplot as plt
import numpy as np

def label_line(line, label, x, y, color='0.5', size=12):
    """Add a label to a line, at the proper angle.

    Arguments
    ---------
    line : matplotlib.lines.Line2D object,
    label : str
    x : float
        x-position to place center of text (in data coordinated
    y : float
        y-position to place center of text (in data coordinates)
    color : str
    size : float
    """
    xdata, ydata = line.get_data()
    x1 = xdata[0]
    x2 = xdata[-1]
    y1 = ydata[0]
    y2 = ydata[-1]

    ax = line.axes
    text = ax.annotate(label, xy=(x, y), xytext=(-10, 0),
                       textcoords='offset points',
                       size=size, color=color,
                       horizontalalignment='left',
                       verticalalignment='bottom')

    sp1 = ax.transData.transform_point((x1, y1))
    sp2 = ax.transData.transform_point((x2, y2))

    rise = (sp2[1] - sp1[1])
    run = (sp2[0] - sp1[0])

    slope_degrees = np.degrees(np.arctan2(rise, run))
    text.set_rotation(slope_degrees)
    return text

def main():
    plt.xlabel('Arithmetic intensity (FLOP/byte)',fontsize=20)
    plt.ylabel('Performance (GFLOPS)',fontsize=20)
    plt.xticks(fontsize=14)
    plt.yticks(fontsize=14)
    plt.loglog()

    xmin = 1.0e-2
    xmax = 1000
    ymin = 1.0e-2
    ymax = 1.0e3

    # ridge
    # 2nd x point is where label is placed
    x_bw = [xmin, 1.0e-3, 10]

    # Flat mode
    
    # DRAM
    BW = 22.6
    y_bw = [BW * x_bw[0], BW * x_bw[1], BW * x_bw[2]]
    plt.plot(x_bw, y_bw, color='r', linestyle='-', label='_DRAM: 22.6 GB/s')

# cannot detect
#    # L3
#    BW = 26.5
#    y_bw = [BW * x_bw[0], BW * x_bw[1], BW * x_bw[2]]
#    plt.plot(x_bw, y_bw, color='y', linestyle='-', label='_L3: 26.5 GB/s')
#
#    # L2
#    BW = 226.1
#    y_bw = [BW * x_bw[0], BW * x_bw[1], BW * x_bw[2]]
#    plt.plot(x_bw, y_bw, color='g', linestyle='-', label='_L2: 226.1 GB/s')
#
#    # L1
#    BW = 362.2
#    y_bw = [BW * x_bw[0], BW * x_bw[1], BW * x_bw[2]]
#    plt.plot(x_bw, y_bw, color='b', linestyle='-', label='_L1: 362.2 GB/s')

    # roof
    x_compute = [1.0e-2,15,xmax]

    # Scalar add peak
    y_compute = [5.8, 5.8, 5.8]
    plt.plot(x_compute, y_compute, color='r', linestyle='-',
             label='_Scalar add: 5.8 GF/s')

    # DP Vector add peak
    y_compute = [11.6, 11.6, 11.6]
    plt.plot(x_compute, y_compute, color='y', linestyle='-',
             label='_DP vector add: 11.6 GF/s')

    # DP Vector FMA peak
    y_compute = [23.2, 23.2, 23.2]
    plt.plot(x_compute, y_compute, color='g', linestyle='-',
             label='_DP vector FMA: 23.2 GF/s')#, SP vector add')

#    # SP Vector add peak
#    y_compute = [23.2, 23.2, 23.2]
#    plt.plot(x_compute, y_compute, color='c', linestyle='-',
#             label='SP vector add')

    # SP Vector FMA peak
    y_compute = [46.3, 46.3, 46.3]
    plt.plot(x_compute, y_compute, color='b', linestyle='-',
             label='_SP vector FMA: 46.3 GF/s')

    # plot the labels
    lines = plt.gca().get_lines()
    for line in lines:
        label_line(line, line.get_label(),
                   line.get_xdata()[1], line.get_ydata()[1])

    # Scale
    AI = 0.062
    GFS = 1.29
    plt.plot(AI,GFS,'o',ms=10,color='r',label='Scale')
    plt.plot([AI,AI], [ymin,ymax], color='k', linestyle='--', lw=0.2)
    plt.plot([xmin,xmax], [GFS,GFS], color='k', linestyle='--', lw=0.2)

    # Add
    AI = 0.042
    GFS = 0.92
    plt.plot(AI,GFS,'o',ms=10,color='g',label='Add')
    plt.plot([AI,AI], [ymin,ymax], color='k', linestyle='--', lw=0.2)
    plt.plot([xmin,xmax], [GFS,GFS], color='k', linestyle='--', lw=0.2)

    # Triad
    AI = 0.083
    GFS = 1.79
    plt.plot(AI,GFS,'o',ms=10,color='b',label='Triad')
    plt.plot([AI,AI], [ymin,ymax], color='k', linestyle='--', lw=0.2)
    plt.plot([xmin,xmax], [GFS,GFS], color='k', linestyle='--', lw=0.2)

    plt.legend(loc='lower right')
    plt.show()

if __name__ == "__main__":
    main()
