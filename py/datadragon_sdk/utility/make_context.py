# DataDragon SDK utility: make_context

from datadragon_sdk.core.context import DataDragonContext


def make_context_util(ctxmap, basectx):
    return DataDragonContext(ctxmap, basectx)
