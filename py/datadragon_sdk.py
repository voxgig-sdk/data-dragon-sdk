# DataDragon SDK

from utility.voxgig_struct import voxgig_struct as vs
from core.utility_type import DataDragonUtility
from core.spec import DataDragonSpec
from core import helpers

# Load utility registration (populates Utility._registrar)
from utility import register

# Load features
from feature.base_feature import DataDragonBaseFeature
from features import _make_feature


class DataDragonSDK:

    def __init__(self, options=None):
        self.mode = "live"
        self.features = []
        self.options = None

        utility = DataDragonUtility()
        self._utility = utility

        from config import make_config
        config = make_config()

        self._rootctx = utility.make_context({
            "client": self,
            "utility": utility,
            "config": config,
            "options": options if options is not None else {},
            "shared": {},
        }, None)

        self.options = utility.make_options(self._rootctx)

        if vs.getpath(self.options, "feature.test.active") is True:
            self.mode = "test"

        self._rootctx.options = self.options

        # Add features from config.
        feature_opts = helpers.to_map(vs.getprop(self.options, "feature"))
        if feature_opts is not None:
            feature_items = vs.items(feature_opts)
            if feature_items is not None:
                for item in feature_items:
                    fname = item[0]
                    fopts = helpers.to_map(item[1])
                    if fopts is not None and fopts.get("active") is True:
                        utility.feature_add(self._rootctx, _make_feature(fname))

        # Add extension features.
        extend = vs.getprop(self.options, "extend")
        if isinstance(extend, list):
            for f in extend:
                if isinstance(f, dict) or (hasattr(f, "get_name") and callable(f.get_name)):
                    utility.feature_add(self._rootctx, f)

        # Initialize features.
        for f in self.features:
            utility.feature_init(self._rootctx, f)

        utility.feature_hook(self._rootctx, "PostConstruct")

        # #BuildFeatures

    def options_map(self):
        out = vs.clone(self.options)
        if isinstance(out, dict):
            return out
        return {}

    def get_utility(self):
        return DataDragonUtility.copy(self._utility)

    def get_root_ctx(self):
        return self._rootctx

    def prepare(self, fetchargs=None):
        utility = self._utility

        if fetchargs is None:
            fetchargs = {}

        ctrl = helpers.to_map(vs.getprop(fetchargs, "ctrl"))
        if ctrl is None:
            ctrl = {}

        ctx = utility.make_context({
            "opname": "prepare",
            "ctrl": ctrl,
        }, self._rootctx)

        options = self.options

        path = vs.getprop(fetchargs, "path") or ""
        if not isinstance(path, str):
            path = ""

        method = vs.getprop(fetchargs, "method") or "GET"
        if not isinstance(method, str):
            method = "GET"

        params = helpers.to_map(vs.getprop(fetchargs, "params"))
        if params is None:
            params = {}
        query = helpers.to_map(vs.getprop(fetchargs, "query"))
        if query is None:
            query = {}

        headers = utility.prepare_headers(ctx)

        base = vs.getprop(options, "base") or ""
        if not isinstance(base, str):
            base = ""
        prefix = vs.getprop(options, "prefix") or ""
        if not isinstance(prefix, str):
            prefix = ""
        suffix = vs.getprop(options, "suffix") or ""
        if not isinstance(suffix, str):
            suffix = ""

        ctx.spec = DataDragonSpec({
            "base": base,
            "prefix": prefix,
            "suffix": suffix,
            "path": path,
            "method": method,
            "params": params,
            "query": query,
            "headers": headers,
            "body": vs.getprop(fetchargs, "body"),
            "step": "start",
        })

        # Merge user-provided headers.
        uh = vs.getprop(fetchargs, "headers")
        if isinstance(uh, dict):
            for k, v in uh.items():
                ctx.spec.headers[k] = v

        _, err = utility.prepare_auth(ctx)
        if err is not None:
            raise err

        fetchdef, err = utility.make_fetch_def(ctx)
        if err is not None:
            raise err

        return fetchdef

    def direct(self, fetchargs=None):
        utility = self._utility

        try:
            fetchdef = self.prepare(fetchargs)
        except Exception as err:
            # direct() is the raw-HTTP escape hatch: it never raises, it
            # returns a result object callers branch on via result["ok"].
            return {"ok": False, "err": err}

        if fetchargs is None:
            fetchargs = {}
        ctrl = helpers.to_map(vs.getprop(fetchargs, "ctrl"))
        if ctrl is None:
            ctrl = {}

        ctx = utility.make_context({
            "opname": "direct",
            "ctrl": ctrl,
        }, self._rootctx)

        url = fetchdef.get("url", "")
        fetched, fetch_err = utility.fetcher(ctx, url, fetchdef)

        if fetch_err is not None:
            return {"ok": False, "err": fetch_err}

        if fetched is None:
            return {
                "ok": False,
                "err": ctx.make_error("direct_no_response", "response: undefined"),
            }

        if isinstance(fetched, dict):
            status = helpers.to_int(vs.getprop(fetched, "status"))
            headers = vs.getprop(fetched, "headers") or {}

            # No-body responses (204, 304) and explicit zero content-length
            # must skip JSON parsing — calling json() on an empty body raises.
            content_length = None
            if isinstance(headers, dict):
                content_length = headers.get("content-length")
            no_body = status in (204, 304) or str(content_length) == "0"

            json_data = None
            if not no_body:
                jf = vs.getprop(fetched, "json")
                if callable(jf):
                    try:
                        json_data = jf()
                    except Exception:
                        # Non-JSON body (e.g. text/plain, text/html). Surface
                        # status + headers but leave data as None.
                        json_data = None

            return {
                "ok": status >= 200 and status < 300,
                "status": status,
                "headers": headers,
                "data": json_data,
            }

        return {
            "ok": False,
            "err": ctx.make_error("direct_invalid", "invalid response type"),
        }


    @property
    def champion(self):
        """Idiomatic facade: client.champion.list() / client.champion.load({"id": ...})."""
        from entity.champion_entity import ChampionEntity
        cached = getattr(self, "_champion", None)
        if cached is None:
            cached = ChampionEntity(self, None)
            self._champion = cached
        return cached

    def Champion(self, data=None):
        # Deprecated: use client.champion instead.
        from entity.champion_entity import ChampionEntity
        return ChampionEntity(self, data)


    @property
    def data_champion(self):
        """Idiomatic facade: client.data_champion.list() / client.data_champion.load({"id": ...})."""
        from entity.data_champion_entity import DataChampionEntity
        cached = getattr(self, "_data_champion", None)
        if cached is None:
            cached = DataChampionEntity(self, None)
            self._data_champion = cached
        return cached

    def DataChampion(self, data=None):
        # Deprecated: use client.data_champion instead.
        from entity.data_champion_entity import DataChampionEntity
        return DataChampionEntity(self, data)


    @property
    def data_item(self):
        """Idiomatic facade: client.data_item.list() / client.data_item.load({"id": ...})."""
        from entity.data_item_entity import DataItemEntity
        cached = getattr(self, "_data_item", None)
        if cached is None:
            cached = DataItemEntity(self, None)
            self._data_item = cached
        return cached

    def DataItem(self, data=None):
        # Deprecated: use client.data_item instead.
        from entity.data_item_entity import DataItemEntity
        return DataItemEntity(self, data)


    @property
    def data_rune(self):
        """Idiomatic facade: client.data_rune.list() / client.data_rune.load({"id": ...})."""
        from entity.data_rune_entity import DataRuneEntity
        cached = getattr(self, "_data_rune", None)
        if cached is None:
            cached = DataRuneEntity(self, None)
            self._data_rune = cached
        return cached

    def DataRune(self, data=None):
        # Deprecated: use client.data_rune instead.
        from entity.data_rune_entity import DataRuneEntity
        return DataRuneEntity(self, data)


    @property
    def dragontail_versiontgz(self):
        """Idiomatic facade: client.dragontail_versiontgz.list() / client.dragontail_versiontgz.load({"id": ...})."""
        from entity.dragontail_versiontgz_entity import DragontailVersiontgzEntity
        cached = getattr(self, "_dragontail_versiontgz", None)
        if cached is None:
            cached = DragontailVersiontgzEntity(self, None)
            self._dragontail_versiontgz = cached
        return cached

    def DragontailVersiontgz(self, data=None):
        # Deprecated: use client.dragontail_versiontgz instead.
        from entity.dragontail_versiontgz_entity import DragontailVersiontgzEntity
        return DragontailVersiontgzEntity(self, data)


    @property
    def item(self):
        """Idiomatic facade: client.item.list() / client.item.load({"id": ...})."""
        from entity.item_entity import ItemEntity
        cached = getattr(self, "_item", None)
        if cached is None:
            cached = ItemEntity(self, None)
            self._item = cached
        return cached

    def Item(self, data=None):
        # Deprecated: use client.item instead.
        from entity.item_entity import ItemEntity
        return ItemEntity(self, data)


    @property
    def region(self):
        """Idiomatic facade: client.region.list() / client.region.load({"id": ...})."""
        from entity.region_entity import RegionEntity
        cached = getattr(self, "_region", None)
        if cached is None:
            cached = RegionEntity(self, None)
            self._region = cached
        return cached

    def Region(self, data=None):
        # Deprecated: use client.region instead.
        from entity.region_entity import RegionEntity
        return RegionEntity(self, data)


    @property
    def version(self):
        """Idiomatic facade: client.version.list() / client.version.load({"id": ...})."""
        from entity.version_entity import VersionEntity
        cached = getattr(self, "_version", None)
        if cached is None:
            cached = VersionEntity(self, None)
            self._version = cached
        return cached

    def Version(self, data=None):
        # Deprecated: use client.version instead.
        from entity.version_entity import VersionEntity
        return VersionEntity(self, data)



    @classmethod
    def test(cls, testopts=None, sdkopts=None):
        if sdkopts is None:
            sdkopts = {}
        sdkopts = vs.clone(sdkopts)
        if not isinstance(sdkopts, dict):
            sdkopts = {}

        if testopts is None:
            testopts = {}
        testopts = vs.clone(testopts)
        if not isinstance(testopts, dict):
            testopts = {}
        testopts["active"] = True

        vs.setpath(sdkopts, "feature.test", testopts)

        sdk = cls(sdkopts)
        sdk.mode = "test"

        return sdk
