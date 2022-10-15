{
  config,
  pkgs,
  lib,
  self,
  ...
}: {
  environment.systemPackages = [
    pkgs.dtc
    pkgs.v4l-utils
    pkgs.ustreamer
    pkgs.libcamera
    pkgs.ffmpeg_5
    pkgs.libcamera-apps
    pkgs.gdb
    # pkgs.rpi-videocore
  ];

  tl.services.tailscale-tls.enable = true;

  services.rtsp-simple-server = {
    enable = true;
    settings = {
      hlsAlwaysRemux = true;
      hlsVariant = "lowLatency";
      hlsSegmentDuration = "200ms";
      hlsPartDuration = "200ms";

      hlsEncryption = true;
      hlsServerKey = "${config.tl.services.tailscale-tls.target}/key.key";
      hlsServerCert = "${config.tl.services.tailscale-tls.target}/cert.crt";

      paths = {
        # cam = {
        #   runOnInit = "ffmpeg -f v4l2 -video_size 1280x720 -i /dev/video1 -input_format yuv420p -c:v h264_v4l2m2m -preset ultrafast -b:v 600k -max_muxing_queue_size 1024 -g 30 -f rtsp rtsp://localhost:$RTSP_PORT/$RTSP_PATH";
        #   # runOnInit = "ffmpeg -f v4l2 -i /dev/video1 -input_format yuv420p -framerate 30 -video_size 1280x720 -c:v h264_v4l2m2m -f mpegts rtmp://127.0.0.1:1935/cam"
        #   runOnInitRestart = true;
        # };
        cam = {
          source = "rpiCamera";
          rpiCameraWidth = 1920;
          rpiCameraHeight = 1080;
        };
      };
    };
    env = {
      LIBCAMERA_IPA_PROXY_PATH = "${pkgs.libcamera}/libexec/libcamera";
    };
  };

  users.groups.dma-heap = {};

  services.udev.extraRules = ''
    SUBSYSTEM=="dma_heap", GROUP="dma-heap", MODE="0660"
  '';

  systemd.services.rtsp-simple-server = {
    after = ["tailscale-tls.service"];
    partOf = ["tailscale-tls.service"];

    serviceConfig.SupplementaryGroups = lib.mkForce "video tailscale-tls dma-heap";
  };
}
