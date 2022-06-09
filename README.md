# python3-libspot

Python3 bindings to libspot (see https://asiffer.github.io/libspot/python/)

## Installation

First, you must ensure that [`libspot`](https://github.com/asiffer/libspot) is well installed on your machine.
Then you can download the bindings, either through `pip` or with the debian package.

```shell
pip3 install pylibspot
```

## Get started

The following example tracks extreme values on a gaussian stream

```python
import numpy as np
import pylibspot as ps

s = ps.Spot(q=1e-4, n_init=10000, level=0.998, up=True, down=False)
n_anomalies = 0
for x in np.random.normal(0, 1, 60000):
    if s.step(x) == 1:
        n_anomalies += 1
print(n_anomalies)
```
