{ config, pkgs, ... }:
let
  # Profile OBS actually loads. Keep the name in sync with the GUI profile,
  # otherwise these files are written for a profile nothing selects.
  profile = "Untitled";

  # Index of the NVIDIA GPU to use. 0 unless you have more than one NVIDIA
  # card in the system (an iGPU doesn't count here — NVENC only runs on the
  # discrete NVIDIA part, there's no cross-vendor equivalent to renderD129).
  gpu = 0;

  recordDir = "${config.home.homeDirectory}/Videos/records";

  # Constant quantizer for the recording. Lower cqp = better picture and
  # bigger file; 20 is visually clean, 23 is noticeably smaller, 16 is
  # near-transparent. NVENC's "cqp" behaves like x264's -qp, not like the
  # "CQ"/VBR quality slider some GUIs expose.
  cqp = 20;

  # Streaming is bandwidth-bound, so it uses CBR at a number the uplink can
  # hold. YouTube wants 4500-9000 for 1080p60. Budget ~1.5x in real upload
  # headroom on top of this.
  streamBitrate = 8000;
in
{
  programs.obs-studio = {
    enable = true;

    # obs-vaapi is AMD/Intel-only and dropped. NVENC ships inside OBS itself
    # (the obs-nvenc plugin) as long as the proprietary NVIDIA driver is
    # present in the system config — nothing extra to add here for encoding.
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-gstreamer
      obs-vkcapture
      droidcam-obs
    ];
    package = pkgs.obs-studio.override {
      cudaSupport = true;
    };
  };

  # OBS rewrites its profile on exit, so it will clobber these symlinks with
  # plain files. force = true lets the next rebuild take ownership back, which
  # also means GUI changes to the Output panel do not survive a rebuild.
  # Quit OBS before rebuilding or the running instance wins on shutdown.
  xdg.configFile = {
    "obs-studio/basic/profiles/${profile}/basic.ini" = {
      force = true;
      text = ''
        [General]
        Name=${profile}

        [Output]
        Mode=Advanced
        FilenameFormatting=%CCYY-%MM-%DD %hh-%mm-%ss
        DelayEnable=false
        DelaySec=20
        DelayPreserve=true
        Reconnect=true
        RetryDelay=2
        MaxRetries=25
        BindIP=default
        IPFamily=IPv4+IPv6
        NewSocketLoopEnable=false
        LowLatencyEnable=false

        [Stream1]
        IgnoreRecommended=false
        MultitrackVideoMaximumAggregateBitrateAuto=true
        MultitrackVideoMaximumVideoTracksAuto=true
        EnableMultitrackVideo=false

        [AdvOut]
        ApplyServiceSettings=true
        # NVENC on Turing-or-newer (GTX 16-series / RTX 20-series and up) is
        # close to x264's quality at a fraction of the CPU cost, and it runs
        # on a dedicated encoder chip that doesn't steal CUDA/shader cycles
        # from the concurrent 1440p recording below. Two simultaneous NVENC
        # sessions (stream + record) are fine on any driver from the last
        # few years — Nvidia removed the old consumer session cap.
        # If your card predates Turing (GTX 10-series or older), OBS
        # silently falls back to the legacy nvenc path with different
        # preset names ("hq"/"hp" instead of "p1"-"p7") — say so if that's
        # your case and this needs adjusting.
        Encoder=obs_nvenc_h264_tex
        AudioEncoder=ffmpeg_aac
        TrackIndex=1
        VodTrackIndex=2
        FLVTrack=1
        StreamMultiTrackAudioMixes=1
        # Stream at 1080p even though the canvas is 1440p. 4 = OBS_SCALE_LANCZOS;
        # without a filter here the resolution below is ignored entirely.
        UseRescale=true
        RescaleRes=1920x1080
        RescaleFilter=4

        RecType=Standard
        RecFilePath=${recordDir}
        RecFormat2=hybrid_mp4
        RecEncoder=obs_nvenc_h264_tex
        RecAudioEncoder=ffmpeg_aac
        RecTracks=1
        RecUseRescale=false
        RecFileNameWithoutSpace=true
        RecRescaleFilter=0

        Track1Bitrate=160
        Track2Bitrate=160
        Track3Bitrate=160
        Track4Bitrate=160
        Track5Bitrate=160
        Track6Bitrate=160

        RecSplitFileType=Time
        RecSplitFileTime=15
        RecSplitFileSize=2048
        RecRB=false
        RecRBTime=20
        RecRBSize=512

        [Video]
        # Native panel size. Any mismatch here resamples every glyph and is
        # what makes recorded text look soft, no matter how good the encoder is.
        BaseCX=2560
        BaseCY=1440
        OutputCX=2560
        OutputCY=1440
        FPSType=0
        FPSCommon=60
        FPSInt=30
        FPSNum=30
        FPSDen=1
        ScaleType=lanczos
        ColorFormat=NV12
        ColorSpace=709
        ColorRange=Partial
        SdrWhiteLevel=300
        HdrNominalPeakLevel=1000

        [Audio]
        MonitoringDeviceId=default
        MonitoringDeviceName=Default
        SampleRate=48000
        ChannelSetup=Stereo
        MeterDecayRate=23.53
        PeakMeterType=0
      '';
    };

    # Settings for RecEncoder above: constant-quality recording, no bitrate cap.
    "obs-studio/basic/profiles/${profile}/recordEncoder.json" = {
      force = true;
      text = builtins.toJSON {
        rate_control = "CQP";
        inherit cqp;
        keyint_sec = 2;
        preset2 = "p5"; # p1 fastest/lowest quality .. p7 slowest/best quality
        tuning = "hq"; # "hq" | "ll" (low latency) | "ull" | "lossless"
        multipass = "qres"; # two-pass lookahead at quarter res; "disabled" if you need max fps
        profile = "high";
        psycho_aq = true;
        lookahead = true;
        bf = 2; # B-frames; some players/scene detectors dislike B-frames in recordings, set 0 if so
        inherit gpu;
      };
    };

    # Settings for Encoder above. keyint_sec 2 is a YouTube requirement, not a
    # preference; auto does not reliably land there.
    "obs-studio/basic/profiles/${profile}/streamEncoder.json" = {
      force = true;
      text = builtins.toJSON {
        rate_control = "CBR";
        bitrate = streamBitrate;
        keyint_sec = 2;
        preset2 = "p5";
        tuning = "ll"; # low-latency tuning suits live streaming better than "hq"
        multipass = "disabled"; # CBR + lookahead multipass fights itself; keep off for streaming
        profile = "high";
        psycho_aq = true;
        lookahead = false;
        bf = 2;
        inherit gpu;
      };
    };
  };

  # service.json is deliberately absent. It holds the YouTube stream key, and
  # the nix store is world-readable and this config is a git repo. Leave it
  # mutable, or reach for sops/agenix.
}
