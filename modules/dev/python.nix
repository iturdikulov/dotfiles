# modules/dev/python.nix --- https://godotengine.org/
#
# Python's ecosystem repulses me. The list of environment "managers" exhausts
# me. The Py2->3 transition make trainwrecks jealous. But SciPy, NumPy, iPython
# and Jupyter can have my babies. Every single one.

{ config, options, lib, pkgs, my, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.python;
    configDir = config.dotfiles.configDir;
in {
  options.modules.dev.python = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
    pycharm.enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.pycharm.enable {
      user.packages = with pkgs; [
        # # Tools for refactoring and alternative code checking
        jetbrains.pycharm-community-bin
      ];
    })

    (mkIf cfg.enable {
      user.packages = with pkgs; [
        basedpyright

        # Some pre-installed python packages
        # to avoid pip installing them every time
        poetry
        (python3.withPackages(ps: with ps; [
          pip
          setuptools
          ipython

          pygame
          nuitka

          pandas

          scipy
          numpy
          matplotlib

          pynvim
          python-frontmatter
          libcst

          pydantic
          mypy

          requests
          sqlalchemy
        ]))
      ];

      environment.shellAliases = {
        py     = "python";
        py2    = "python2";
        py3    = "python3";
        ipy    = "ipython --no-banner";
        ipylab = "ipython --pylab=qt5 --no-banner";
      };
      home.configFile."python/pythonrc".source = "${configDir}/python/pythonrc";

      # NEXT: need to use config dir extraction
      # system.activationScripts."ipython-profile" = ''
      #   ${getExe' pkgs.python3Packages.ipython "ipython"} profile create default
      #   ${getExe' pkgs.coreutils-full "echo"} "c.TerminalInteractiveShell.editing_mode = 'vi'" >> "${configDir}/ipython/profile_default/ipython_config.py"
      #   ${getExe' pkgs.coreutils-full "echo"} "c.TerminalInteractiveShell.emacs_bindings_in_vi_insert_mode = False" >> "${configDir}/ipython/profile_default/ipython_config.py"
      # '';
    })

    (mkIf cfg.xdg.enable {
      env.IPYTHONDIR      = "$XDG_CONFIG_HOME/ipython";
      env.PIP_CONFIG_FILE = "$XDG_CONFIG_HOME/pip/pip.conf";
      env.PIP_LOG_FILE    = "$XDG_STATE_HOME/pip/log";
      env.PYLINTHOME      = "$XDG_DATA_HOME/pylint";
      env.PYLINTRC        = "$XDG_CONFIG_HOME/pylint/pylintrc";
      env.PYTHONSTARTUP   = "$XDG_CONFIG_HOME/python/pythonrc";
      env.PYTHON_EGG_CACHE = "$XDG_CACHE_HOME/python-eggs";
      env.JUPYTER_CONFIG_DIR = "$XDG_CONFIG_HOME/jupyter";
    })
  ];
}