
import mypy    
import sys
import logging

from mypy.mypy_logging import configure_logging, StructuredMessage

configure_logging()

_ = StructuredMessage
print("*************")
logger = logging.getLogger(__name__)

def test_foo():
    
    logger.info(_("calling foo1"))
    r = mypy.foo1()
    print("finished")
    assert r