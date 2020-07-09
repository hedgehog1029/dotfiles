"""MultiMC albert launcher"""

from albertv0 import *
from datetime import datetime, timedelta
from ago import human
import os
import json

with open(os.getenv("HOME") + "/.config/albert_modules.json") as fd:
    gcfg = json.load(fd)

MULTIMC_HOME = gcfg["multimc_home"]

__iid__ = "PythonInterface/v0.2"
__prettyname__ = "MultiMC Launcher"
__version__ = "1.0"
__trigger__ = "mmc "
__author__ = "offbeatwitch"
__dependencies__ = ["multimc5"]

default_icon = MULTIMC_HOME + "/multimc.png"

def read_cfg(path: str):
    config = {}

    with open(path + "/instance.cfg") as fd:
        for line in fd:
            kv = line.split("=")

            if len(kv) == 2:
                key, value = kv
                config[key] = value.strip()

    return config

class Instance:
    def __init__(self, instance_name: str):
        self.name = instance_name
        self.path = MULTIMC_HOME + "/instances/" + instance_name
        self.config = read_cfg(self.path)
        self.last_launch_time = datetime.fromtimestamp(int(self.config["lastLaunchTime"]) / 1000)

    def find_icon(self):
        if os.path.exists(self.path + "/minecraft"):
            return self.path + "/minecraft/icon.png"
        elif os.path.exists(self.path + "/.minecraft"):
            return self.path + "/.minecraft/icon.png"
        else:
            return default_icon

    def format_item(self):
        delta = datetime.utcnow() - self.last_launch_time
        icon = self.find_icon()
        action = ProcAction("Run Instance", [MULTIMC_HOME + "/MultiMC", "-l", self.name])

        item = Item(id=f"multimc.instance:{self.name}", text=self.name, subtext=f"Last launched: {human(delta)}", completion=self.name, icon=icon)
        item.addAction(action)
        return item

    def sort_key(self):
        return self.last_launch_time.timestamp()

def filter_instances(query: str, instances: list):
    names = filter(lambda n: n.startswith(query), instances)
    instance_l = map(lambda n: Instance(n), names)
    instance_l = sorted(instance_l, key=Instance.sort_key, reverse=True)

    # print(list(map(lambda i: i.name, instance_l)))

    return map(Instance.format_item, instance_l)

def handleQuery(query):
    if query.isTriggered:
        instances = os.listdir(MULTIMC_HOME + "/instances")
        instances.remove("_MMC_TEMP")
        instances.remove("instgroups.json")

        items = filter_instances(query.string, instances)

        return list(items)
