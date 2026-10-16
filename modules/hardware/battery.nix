{
  config,
  pkgs,
  ...
}: {
  services.tlp = {
    enable = true;
    settings = {
      # CPU governor / turbo / Intel HWP
      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      # ACPI platform profile (no-op if the firmware doesn't expose one)
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      # PCIe / runtime power management
      PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "powersave";
      RUNTIME_PM_ON_AC = "auto";
      RUNTIME_PM_ON_BAT = "auto";

      # Storage
      DISK_IDLE_SECS_ON_AC = 0;
      DISK_IDLE_SECS_ON_BAT = 2;
      DISK_APM_LEVEL_ON_AC = "254 254";
      DISK_APM_LEVEL_ON_BAT = "128 128";
      SATA_LINKPWR_ON_AC = "med_power_with_dipm";
      SATA_LINKPWR_ON_BAT = "med_power_with_dipm";

      # USB / radios / audio
      USB_AUTOSUSPEND = 1;
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;
      SOUND_POWER_SAVE_CONTROLLER = "Y";

      # Scheduler / kernel
      SCHED_POWERSAVE_ON_AC = 0;
      SCHED_POWERSAVE_ON_BAT = 1;
      NMI_WATCHDOG = 0;
    };
  };
  services.upower.enable = true;
  services.power-profiles-daemon.enable = false;

  # Coalesce disk writebacks (powertop recommendation) to cut idle disk wakeups.
  boot.kernel.sysctl."vm.dirty_writeback_centisecs" = 1500;

  systemd.services.force-s2idle-suspend = {
    description = "Prefer s2idle over deep suspend";
    wantedBy = ["multi-user.target"];
    before = ["sleep.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      grep -qw s2idle /sys/power/mem_sleep && echo s2idle > /sys/power/mem_sleep || true
    '';
  };

  systemd.services.poweroff-ethernet-on-battery = {
    description = "Sync wired Ethernet power with AC/battery";
    wantedBy = ["multi-user.target"];
    path = [pkgs.iproute2];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      if [ -d /sys/class/net/enp3s0 ]; then
        if [ "$(cat /sys/class/power_supply/ADP1/online 2>/dev/null || echo 1)" = "0" ]; then
          ip link set enp3s0 down
        else
          ip link set enp3s0 up
        fi
      fi
    '';
  };
  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", KERNEL=="ADP1", RUN+="${config.systemd.package}/bin/systemctl start poweroff-ethernet-on-battery.service"
  '';
}
