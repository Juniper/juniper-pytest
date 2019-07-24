import time


def inc(x):
    return x + 1


# All methods named "test_*" will be executed.
def test_answer():
    assert inc(3) == 4


# # This test is expected to fail.
# @pytest.mark.xfail(strict=True)
# def test_answer():
#     assert inc(3) == 5


def test_sleep():
    time.sleep(1)
