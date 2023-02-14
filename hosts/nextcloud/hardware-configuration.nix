{ config, lib, pkgs, ... }:

{
  
  swapDevices = [ {
    device = "/swapfile";
    size = 2*1024;
  } ];

  #fileSystems."/mnt/data" = {
  #  device = "/dev/disk/by-uuid/c1423f61-d466-4d9b-9439-1e0dedd0db22";
  #  fsType = "btrfs";
  #  options = [ "defaults" "noatime" "_netdev" "compress=zstd" ];
  #};

}
