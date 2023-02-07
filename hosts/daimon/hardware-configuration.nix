{ config, lib, pkgs, ... }:

{

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/c1423f61-d466-4d9b-9439-1e0dedd0db22";
    fsType = "btrfs";
    options = [ "defaults" "noatime" "_netdev" "compress=zstd" ];
  };

  fileSystems."/mnt/pass" = {
    device = "/dev/disk/by-uuid/c1423f61-d466-4d9b-9439-1e0dedd0db22";
    fsType = "btrfs";
    options = [ "defaults" "noatime" "_netdev" "compress=zstd" "subvol=@pass"];
  };

  fileSystems."/mnt/nextcloud" = {
    device = "/dev/disk/by-uuid/c1423f61-d466-4d9b-9439-1e0dedd0db22";
    fsType = "btrfs";
    options = [ "defaults" "noatime" "_netdev" "compress=zstd" "subvol=@nextcloud"];
  };
  
  #fileSystems."/mnt/nginx" = {
  #  device = "/dev/disk/by-uuid/c1423f61-d466-4d9b-9439-1e0dedd0db22";
  #  fsType = "btrfs";
  #  options = [ "defaults" "noatime" "_netdev" "compress=zstd" "subvol=@nginx"];
  #};

  fileSystems."/mnt/synapse" = {
    device = "/dev/disk/by-uuid/c1423f61-d466-4d9b-9439-1e0dedd0db22";
    fsType = "btrfs";
    options = [ "defaults" "noatime" "_netdev" "compress=zstd" "subvol=@synapse"];
  };

  fileSystems."/mnt/jellyfin" = {
    device = "/dev/disk/by-uuid/c1423f61-d466-4d9b-9439-1e0dedd0db22";
    fsType = "btrfs";
    options = [ "defaults" "noatime" "_netdev" "compress=zstd" "subvol=@jellyfin"];
  };

}
