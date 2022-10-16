import json
import logging
import sys
import time
import traceback

class JSONFormatter:
    """A formatter for the standard logging module that converts a LogRecord into JSON
    Output matches JSONLayout from https://github.com/kdgregory/log4j-aws-appenders. Any
    keyword arguments supplied to the constructor are output in a "tags" sub-object.
    """

    def __init__(self):
        pass
    def format(self, record):
        result = {
            'timestamp':    time.strftime("%Y-%m-%dT%H:%M:%S", time.gmtime(record.created)) +
                            (".%03dZ" % (1000 * (record.created % 1))),
            'level':        record.levelname,
            'logger':       record.name,
            'module':     record.module,
        }

        msg = json.loads(str(record.msg))
        result.update(msg)
        if (record.exc_info):
            result['exception'] = traceback.format_exception(record.exc_info[0], record.exc_info[1], record.exc_info[2])

        return json.dumps(result)

# Reference: https://docs.python.org/3/howto/logging-cookbook.html#implementing-structured-logging
class StructuredMessage:
    def __init__(self, message, /, **kwargs):
        self.message = message
        self.kwargs = kwargs

    def __str__(self):
        record = {
            'message': self.message
        }
        record.update(self.kwargs)
        return json.dumps(record)

def configure_logging():
    print("+++++++++++++++1")
    logger = logging.getLogger()
    handler = logging.StreamHandler(sys.stderr)
    handler.setFormatter(JSONFormatter()) 
    logger.addHandler(handler)

    #logging.basicConfig(level=logging.DEBUG, handlers=[handler])
