provide-module yummy %{
	# big flashy text with INSERT or NORMAL depending on the mode

	declare-option -docstring "text to be displayd on the mode module when in insert mode"\
		str yummy_insert_mode_text " INSERT "
	declare-option -docstring "text to be displayed on the mode module when in normal mode"\
		str yummy_normal_mode_text " NORMAL "

	# faces for use when in insert/normal mode
	face global yummy_normal_mode_face +rb@StatusLineInfo
	face global yummy_insert_mode_face +rb@StatusLineMode
	# the currently active face
	face global yummy_mode_face yummy_normal_mode_face

	# variable to keap track of the current mode
	declare-option -hidden bool yummy_is_insert false
	# change the variable and current face while in
	# insert/normal mode
	hook global InsertIdle .* %{
		set window yummy_is_insert true
		face window yummy_mode_face yummy_insert_mode_face
	}
	hook global NormalIdle .* %{
		set window yummy_is_insert false
		face window yummy_mode_face yummy_normal_mode_face
	}
	
	# There should be no reason to edit this as were alredy supplying
	# options for the text displayd and the font used
	declare-option -hidden str yummy_mode_format %{$([ "$kak_opt_yummy_is_insert" = "true" ] && printf "$kak_opt_yummy_insert_mode_text"; [ "$kak_opt_yummy_is_insert" = "false" ] && printf "$kak_opt_yummy_normal_mode_text")}
	echo -debug "[yummy]: loaded yummy module mode"

	# bufname
	face global yummy_bufname_face +diu@StatusLine
	declare-option -docstring "SH string used for bufname display"\
		str yummy_bufname_format %{$kak_bufname} 
	echo -debug "[yummy]: loaded yummy module bufname"

	# modified buffer icon
	face global yummy_modified_face StatusLine
	declare-option -docstring "text icon displayd while the buffer is modified and not writen"\
		str yummy_modified_text " [+]"
	declare-option -docstring "SH string for modified text icon display. You should not nead to change it"\
		str yummy_modified_format %{$([ "$kak_modified" = "true"  ] && printf "$kak_opt_yummy_modified_text")}
	echo -debug "[yummy]: loaded yummy module modified"

	# a clock
	face global yummy_clock_face StatusLine
	# the time format string is alredy exposed so this can be hidden
	declare-option -hidden str yummy_clock_format %{$(date $kak_opt_yummy_clock_timefmt)}
	declare-option -docstring "time format pased to the date command for the clock module"\
		str yummy_clock_timefmt %{+%H:%M}
	echo -debug "[yummy]: loaded yummy module clock"

	# displays thing like client0@[server0]
	declare-option -docstring "SH format string for the client_server module."\
		str yummy_client_server_format "$kak_client@[$kak_session]"
	face global yummy_client_server_face StatusLineValue
	echo -debug "[yummy]: loaded yummy module client_server"

	# selection count and position
	declare-option -docstring "SH format string for the selection and position module."\
		str yummy_selection_format "$kak_selection_count sel(s); $kak_cursor_line:$kak_cursor_column"
	face global yummy_selection_face StatusLineInfo
	echo -debug "[yummy]: loaded yummy module selection"

	# git branch
	declare-option -docstring "name of the git branch holding the current buffer" \
		str yummy_git_branch
	hook global WinCreate .* %{
		hook window NormalIdle .* %{ evaluate-commands %sh{
			branch=$(cd "$(dirname "${kak_buffile}")" && git rev-parse --abbrev-ref HEAD 2>/dev/null)
			printf 'set window yummy_git_branch %%{%s}' "${branch}"
		} }
	}
	declare-option -docstring "SH string for git module rendering."\
		str yummy_git_format %{$([ -n "$kak_opt_yummy_git_branch" ] && printf %s "  $kak_opt_yummy_git_branch")}
	face global yummy_git_face StatusLine

	# lsp_error
	declare-option -docstring "SH string for lsp_error module"\
		str yummy_lsp_error_format %{$([ "$kak_opt_lsp_diagnostic_error_count" != "0" ] && printf %s "  $kak_opt_lsp_diagnostic_error_count")}
	face global yummy_lsp_error_face StatusLineValue
	# lsp_warn
	declare-option -docstring "SH string for lsp_warn module"\
		str yummy_lsp_warn_format %{$([ "$kak_opt_lsp_diagnostic_warning_count" != "0" ] && printf %s "  $kak_opt_lsp_diagnostic_warning_count")}
	face global yummy_lsp_warn_face StatusLineValue
	# lsp_info
	declare-option -docstring "SH string for lsp_info module"\
		str yummy_lsp_info_format %{$([ "$kak_opt_lsp_diagnostic_info_count" != "0" ] && printf %s "  $kak_opt_lsp_diagnostic_info_count")}
	face global yummy_lsp_info_face StatusLineValue
	# lsp_hint
	declare-option -docstring "SH string for lsp_hint module"\
		str yummy_lsp_hint_format %{$([ "$kak_opt_lsp_diagnostic_hint_count" != "0" ] && printf %s "  $kak_opt_lsp_diagnostic_hint_count")}
	face global yummy_lsp_hint_face StatusLineValue

	#################
	## driver code ##
	#################

	# Here we declare the two options exposed to the user
	declare-option -docstring "yummy format string for the left side of the bar"\
		str yummy_fmt_left ""
	declare-option -docstring "yummy format string for the rigth side of the bar"\
		str yummy_fmt_right ""

	# Options declared here are used in the generation of
	# the bar. Those do not have to be exposed to the user
	# as they are auto generated from yummy_fmt_* declared
	# above.
	declare-option -hidden str yummy_shellfmt_left  ""
	declare-option -hidden str yummy_kakfmt_left    ""
	declare-option -hidden str yummy_shellfmt_right ""
	declare-option -hidden str yummy_kakfmt_right   ""

	# face used for the central filler
	face global yummy_bar_space_color StatusLine

	# construct the bar. To be interacted with using yummy_enable
	# and others
	define-command -hidden yummy-start %{
	# build the bar format strings
		eval %sh{
			# for kakoune to export any kak_ variabels to us we have
			# to type out the name of the variable in the sh block.
			# I'll do it here but this means that we can't have user
			# defined modules as they have to be listed here. A potenstial
			# fix would be to store this SH block in a variable and let the
			# users append their modules to it
			# kak_opt_yummy_clock_format
			# kak_opt_yummy_mode_format
			# kak_opt_yummy_bufname_format
			# kak_opt_yummy_modified_format
			# kak_opt_yummy_client_server_format
			# kak_opt_yummy_selection_format
			# kak_opt_yummy_git_format
			# kak_opt_yummy_lsp_error_format
			# kak_opt_yummy_lsp_warn_format
			# kak_opt_yummy_lsp_info_format
			# kak_opt_yummy_lsp_hint_format
			
			
			# here we build the format strings for use in SH when
			# doing the length claculations.
			printf "%s\n" "set global yummy_shellfmt_left  %{$(
				eval printf %s "\"$(
					printf "$kak_opt_yummy_fmt_left"  |
					sed 's/\$\(\w*\)/$kak_opt_yummy_\1_format/g'
				)\"")}"
			printf "%s\n" "set global yummy_shellfmt_right %{$(
				eval printf %s "\"$(
					printf "$kak_opt_yummy_fmt_right" |
					sed 's/\$\(\w*\)/$kak_opt_yummy_\1_format/g'
				)\"")}"

			# this is the kakoune format string that's
			# placed in modelinefmt
			printf "%s\n" "set global yummy_kakfmt_left   %{$(
				eval printf %s "\"$(
					printf "$kak_opt_yummy_fmt_left" |
					sed 's/\$\(\w*\)/{yummy_\1_face}%sh{printf \\"$kak_opt_yummy_\1_format\\"}{StatusLine}/g'
				)\"")}"
			printf "%s\n" "set global yummy_kakfmt_right  %{$(
				eval printf %s "\"$(
					printf "$kak_opt_yummy_fmt_right" |
					sed 's/\$\(\w*\)/{yummy_\1_face}%sh{printf \\"$kak_opt_yummy_\1_format\\"}{StatusLine}/g'
				)\"")}"
		}
		echo -debug [yummy]: modeline internals build


		# here we set up the modelinefmt with all the values we colected
		set global modelinefmt %sh{
			# if there is nothing on the left side we can skip
			# all of the steps with filling the background and
			# displaying the left side. We could also have skiped
			# the generation phase above but idk
			if [ -n "$kak_opt_yummy_fmt_left" ]; then
				# left side display
				printf "%s" "$kak_opt_yummy_kakfmt_left"

				# the empty space in the center. We use yummy_shellfmt_* to
				# calculate the width of the difrent parts and subtract that
				# from the width of the window.
				# Sadly we also have to subtract one as the character on the
				# wery left can't be filled by the modeline
				printf "%s" "{yummy_bar_space_color}"
				printf "%s" "%sh{
					printf %\$((
						\$kak_window_width
						- \$(printf \"$kak_opt_yummy_shellfmt_left\"  | wc -m)
						- \$(printf \"$kak_opt_yummy_shellfmt_right\" | wc -m)
						- 1
					))s
				}"
				printf "%s" "{StatusLine}"
			fi

			# rigth side display
			printf "%s" "$kak_opt_yummy_kakfmt_right"
		}
		echo -debug [yummy]: modelinefmt set
	}

	# options to know if yummy is enabled and what the previus modelinefmt
	# was if yummy is to be disabeld. Set when yummy is enabled
	declare-option -hidden bool yummy_bar_enabled     false
	declare-option -hidden str  yummy_pre_modelinefmt ""

	# commands to enable/disable/toggle yummy. This is the commands that
	# are exposed to the user
	define-command -docstring "enable the yummy bar" yummy-enable %{
		eval %sh{
			if [ "$kak_opt_yummy_bar_enabled" = "false" ]; then
				printf "%s\n" "set global yummy_bar_enabled true"
				printf "%s\n" "set global yummy_pre_modelinefmt %opt{modelinefmt}"
				printf "%s\n" "yummy-start"
			else
				printf "%s\n" "echo -markup {Error}yummy is alredy enabled"
			fi
		}
	}
	define-command -docstring "disable the yummy bar" yummy-disable %{
		eval %sh{
			if [ "$kak_opt_yummy_bar_enabled" = "true" ]; then
				printf "%s\n" "set global yummy_bar_enabled false"
				printf "%s\n" "set global modelinefmt %opt{yummy_pre_modelinefmt}"
			else
				printf "%s\n" "echo -markup {Error}yummy is alredy disabled"
			fi
		}
	}
	define-command -docstring "toggle the yummy bar" yummy-toggle %{
		eval %sh{
			if [ "$kak_opt_yummy_bar_enabled" = "true" ]; then
				printf "%s\n" "yummy-disable"
			else
				printf "%s\n" "yummy-enable"
			fi
		}
	}
}
