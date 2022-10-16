
from mypy.mypy_logging import StructuredMessage
import logging

_ = StructuredMessage
logger = logging.getLogger(__name__)


def foo1() -> bool:
    logger.info(_("foo1 called", param=123, name='aws'))
    return True