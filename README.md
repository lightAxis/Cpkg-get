# Cpkg-get
Package management cli tool for my custom packages in Minecraft ComputerCraft mod. References : dpkg, apt-get, ROS cli

- ["--help"] = "use with : --help, refresh, list, version, info, run, update, upgradable, upgrade, install, uninstall, purge",
- ["refresh"] = "cpkg refresh : refresh the pkg & exec info to pkgs.json",
- ["list"] = "cpkg list <installed | server | exec> : show list of installed pkg | server pkg | execution at pkg",
- ["version"] = "cpkg version : show version of cpkg",
- ["info"] = "cpkg info <package_name> <exec_name> : show info of package or execuatble",
- ["run"] = "cpkg run <package_name> <exec_name> : run executable in package",
- ["update"] = "cpkg update : check newest pacakge version from cpkg server",
- ["upgradable"] = "cpkg upgradable : show packages that new version found from cpkg update",
- ["upgrade"] = "cpkg upgrade : download  & upgrade the upgradable packages from MCserver's cpkg server ",
- ["install"] = "cpkg install <package_name> : download package from cpkg server. Already newest version, than ignores",
- ["uninstall"] = "cpkg uninstall <package_name> : uninstall package at local repo. Leaving config behind",
- ["purge"] = "cpkg purge <package_name> : ",
Pkgs
---

- Class  
light classing lib for lua, by kikito

- EmLua
Template based code generation tool for lua. Inspired from empy python pkg