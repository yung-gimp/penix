{
  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usbhid"
      "hid-generic"
      "usb_storage"
      "sd_mod"
    ];
    kernelModules = ["kvm-amd"];
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
  };
}
