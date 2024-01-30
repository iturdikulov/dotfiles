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
    ];

    env = {
      STARDICT_DATA_DIR = "$HOME/Reference/dictionary";
    };

    home.file.".sdcv_ordering" = {
      text = ''
        Wiktionary (En-Ru)
        LingvoUniversal (En-Ru)
        Abbrev
        LingvoComputer (En-Ru)
        New Oxford American Dictionary. Angus Stevenson and Christine A. Lindberg (En-En)
        WordNet
        LingvoComputer (Ru-En)
        LingvoUniversal (Ru-En)
        TechAbrreviations (Ru-Ru)
        Словарь русского языка. Unknown (Ru-Ru)
        Большой словарь иностранных слов (Ru-Ru)
        Новый словарь русского языка. Толково-словообразовательный. Ефремова Т.Ф. (Ru-Ru)
        Толковый словарь русского языка. С.И.Ожегов и Н.Ю.Шведова (Ru-Ru)
        Толковый словарь русского языка. Д. Н. Ушаков (Ru-Ru)
        Этимологический Словарь. Семенов А.В (Ru-Ru)
        Этимологический словарь русского языка. М. Фасмер (Ru-Ru)
        Толковый словарь живого великорусского языка. В. Даль (Ru-Ru)
        Wiktionary (Ru-Ru)
        Wiktionary (Ru-En)
        '';
    };
  };
}