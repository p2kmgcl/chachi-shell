return {
  "sphamba/smear-cursor.nvim",
  enabled = false,
  opts = {
    smear_insert_mode = false,
    legacy_computing_symbols_support = true,

    hide_target_hack = true,
    never_draw_over_target = true,

    min_horizontal_distance_smear = 4,
    min_vertical_distance_smear = 10,

    damping = 1.0,
    stiffness = 0.6,
    trailing_stiffness = 0.4,
    matrix_pixel_threshold = 0.5,
  },
}
