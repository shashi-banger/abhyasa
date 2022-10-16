
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
source venv/bin/activate
```

## Running pytest 

For local source code test run the following

```
pythons -m pytest
```

For testing installed package

```
pytest 
```

## References

1. https://blog.ionelmc.ro/2014/05/25/python-packaging/#the-structure%3E
2. https://docs.pytest.org/en/7.1.x/explanation/goodpractices.html#tests-outside-application-code
