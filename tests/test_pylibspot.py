from pylibspot import __version__, Spot
import numpy as np
import scipy.stats as ss
import pytest

testdata = [
    ("normal", ss.norm(0, 1)),
    ("exponential", ss.expon(1)),
    ("uniform", ss.uniform()),
]


def test_version():
    assert __version__ in ["1.1.3", "dev"]


@pytest.mark.parametrize("name, dist", testdata)
def test_quantile(name: str, dist: ss.rv_continuous):
    Nexp = 10
    q = 1e-5
    n_init = 100000
    quantiles = np.zeros(Nexp)
    for k in range(Nexp):
        s = Spot(q=q, level=0.999, n_init=n_init, down=False, up=True)
        for x in dist.rvs(size=n_init):
            s.step(x)
        quantiles[k] = s.get_upper_threshold()

    th = dist.ppf(1 - q)
    zq = np.mean(quantiles)
    err = abs(th - zq) / th

    print(f"Truth: {th:.2f}, got {zq:.2f} ({100*err:.2f}%)")
    assert err < 0.05

    # print(
    #     f"Average relative error: "
    #     f"{(100 * np.abs( (quantiles - dist.ppf(1 - q)) / dist.ppf(1 - q))).mean():.2f}%"
    # )
