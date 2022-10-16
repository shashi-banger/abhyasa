
# Example python workspace

An example python workspace with logging, pytes and packagin support.

## Create virtual environment

```
python -m venv .venv
```


## Running pytest 

Setup pytest in virtual env

```
source .venv/bin/activate
pip install pytest
deactivate
source .venv/bin/activate
```

For local source code test run the following
```
python -m pytest -s
```

For testing installed package
```
pytest -s 
```

## References

1. https://blog.ionelmc.ro/2014/05/25/python-packaging/#the-structure%3E
2. https://docs.pytest.org/en/7.1.x/explanation/goodpractices.html#tests-outside-application-code
