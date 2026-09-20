-- NVIDIA 

hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GL_VRR_ALLOWED", "1")
hl.env("__GL_SYNC_TO_VBLANK", "1")

hl.monitor({
    output = "",
    mode = "2560x1600@165",
    position = "auto",
    scale = 1.25,
})

-- WLR_NO_HARDWARE_CURSORS
hl.config({
    cursor = {
        no_hardware_cursors = true,
    }
})

