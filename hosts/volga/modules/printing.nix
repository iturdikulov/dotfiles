{ options, config, pkgs, ... }:

{
  services.printing = {
    enable = true;
    drivers = [ pkgs.cups-kyocera ];
  };

  hardware.printers = {
    ensurePrinters = [
      {
        name = "Kyocera_FS-1040";
        location = "Home";
        deviceUri = "usb://Kyocera/FS-1040?serial=NW83108748";
        model = "Kyocera/Kyocera_FS-1040GDI.ppd";
        ppdOptions = {
          PageSize = "A4";
        };
      }
    ];
  };
}
