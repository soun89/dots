#!/usr/bin/env bash
# #
# # Script to set colors generated by 'wal'
# # https://github.com/dylanaraps/wal
#  # Source generated colors.
# . "${HOME}/.cache/wal/colors.sh"

#  reload_dunst() {
#     pkill dunst
#     dunst \
# 	-frame_width 1 \
#         -lb "${color0}" \
#         -nb "${color0}" \
#         -nfr "${color1}" \
#         -cb "${color0}" \
#         -lf "${color7}" \
#         -bf "${color7}" \
#         -cf "${color7}" \
#         -nf "${color7}" &
# }

# reload_dunst

pkill dunst
dunst &
