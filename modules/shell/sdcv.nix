{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.sdcv;
in {
  options.modules.shell.sdcv = with types; {
    enable   = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      sdcv

      (writeScriptBin "d" ''
        #!/bin/sh
        sdcv -nc "$@"| sed 's/<[^>]*>//g' | sed 's/0m.*\w\+\.wav.*/0m/g' | bat
       '')
    ];

    env = {
      STARDICT_DATA_DIR = "$HOME/Computer/reference/dictionary";
    };

    home.file.".sdcv_ordering" = {
      text = ''
        LingvoComputer (En-Ru)
        LingvoComputer (Ru-En)
        LingvoUniversal (En-Ru)
        New Oxford American Dictionary. Angus Stevenson and Christine A. Lindberg (En-En)
        CollinsCobuild (En-En)
        Abbrev
        LingvoUniversal (Ru-En)
        TechAbrreviations (Ru-Ru)
        Oxford English Collocation Dictionary
        Словарь русского языка. Unknown (Ru-Ru)
        Большой словарь иностранных слов (Ru-Ru)
        Новый словарь русского языка. Толково-словообразовательный. Ефремова Т.Ф. (Ru-Ru)
        Толковый словарь русского языка. С.И.Ожегов и Н.Ю.Шведова (Ru-Ru)
        Толковый словарь русского языка. Д. Н. Ушаков (Ru-Ru)
        Этимологический Словарь. Семенов А.В (Ru-Ru)
        Этимологический словарь русского языка. М. Фасмер (Ru-Ru)
        Толковый словарь живого великорусского языка. В. Даль (Ru-Ru)
        '';
    };
  };
}