import pylibspot as ps # new name of the python3 package
import pandas as pd
import matplotlib.pyplot as plt

# loading data
MAWI_17 = pd.read_csv("mawi_170812_50_50.csv", index_col=[0])
MAWI_18 = pd.read_csv("mawi_180812_50_50.csv", index_col=[0])

# we keep only the ratio of SYN packets
rSYN_17 = MAWI_17['rSYN']
rSYN_18 = MAWI_18['rSYN']

# initialization of the Spot object
q = 5e-4
n_init = 2000
spot = ps.Spot(q, n_init, up=True, down=False)


## CALIBRATION
for r in rSYN_17[-n_init:]:
	spot.step(r)


## ANOMALY DETECTION

# we init some structure to log what flags the algorithm
up_threshold = [0.0] * len(rSYN_18)
anomalies_x = []
anomalies_y = []
i = 0
for r in rSYN_18:
	event = spot.step(r)
	
	if event == 1: # anomaly case
		anomalies_x.append(i)
		anomalies_y.append(r)
		
	up_threshold[i] = spot.get_upper_threshold()
	i = i+1

# Plotting stuff 
plt.plot(rSYN_18, lw=2, color="#1B4B5A")
f1, = plt.plot(up_threshold, ls='dashed', color="#AE81FF", lw=2)
f2 = plt.scatter(anomalies_x, anomalies_y, color="#F55449")
plt.legend([f1, f2], ['Threshold', 'Anomalies'])


plt.xticks(range(0,18001,3000), range(0,901,150)) # we change the ticks to make it corresponds to the true time : 1 it = 50 ms
plt.xlabel('Time (s)')
plt.ylabel('Ratio of SYN packets')

