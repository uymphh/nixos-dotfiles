{pkgs, ...}: {
  services.xserver.videoDrivers = ["nvidia"];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [intel-media-driver];
  };

  boot.kernelParams = ["nvidia-drm.fbdev=1"];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    powerManagement = {
      enable = true;
      finegrained = true;
    };
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

  # NixOS's finegrained PM only enables runtime PM on the GPU's VGA/3D
  # functions. The GPU's HDA audio function must also be allowed to
  # runtime-suspend, otherwise it keeps the dGPU from reaching D3cold (idle
  # draw). It wakes automatically when HDMI/DisplayPort audio is used.
  services.udev.extraRules = ''
    ACTION=="bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", TEST=="power/control", ATTR{power/control}="auto"
  '';
}
