provide-module yummy_std_config %{
	require-module yummy

	# in each window we set up the faces so that
	# yummy_client_server_face and yummy_mode_face
	# are equal. This will create the chaning color
	# efect as yummy_mode_face changes
	hook global  WinCreate .* %{
		face window yummy_client_server_face yummy_mode_face
	}

	# format strings
	set global yummy_fmt_left             "$mode $bufname$modified "
	set global yummy_fmt_right            " $selection $clock $client_server"

	# client_server string format. Just addes a
	#  space on each side, appart from that it's
	#  just like the standard
	set global yummy_client_server_format " $kak_client@[$kak_session] "
}

# this is the config i'm using :)
provide-module yummy_devs_config %{
	require-module yummy_std_config

	# format strings
	set  global yummy_fmt_left             "$mode $bufname$modified$git "
	set  global yummy_fmt_right            "$lsp_error$lsp_warn$lsp_info$lsp_hint $selection $client_server"
	set  global yummy_client_server_format " $kak_client@$kak_session "

	# get rid of the coloring on the seleetion module
	face global yummy_selection_face       StatusLine
	# make the modified indicator stand out more using
	# a odd color and a longer text then the standard
	face global yummy_modified_face        StatusLineValue
	set  global yummy_modified_text        " [modif.]"
	set  global yummy_lsp_error_format %{$([ "$kak_opt_lsp_diagnostic_error_count" != "0" ] && printf %s " $kak_opt_lsp_diagnostic_error_count")}
	set  global yummy_lsp_warn_format %{$([ "$kak_opt_lsp_diagnostic_warning_count" != "0" ] && printf %s " $kak_opt_lsp_diagnostic_warning_count")}
	set  global yummy_lsp_info_format %{$([ "$kak_opt_lsp_diagnostic_info_count" != "0" ] && printf %s " $kak_opt_lsp_diagnostic_info_count")}
	set  global yummy_lsp_hint_format %{$([ "$kak_opt_lsp_diagnostic_hint_count" != "0" ] && printf %s " $kak_opt_lsp_diagnostic_hint_count")}

	# this is gruvbox colors. Mabey i shouldn't put it here but whatever,
	# this is my config. Or at least it's kind gruvbox. The real thing i3
	# #282828 but i want it to look sligthly diffrent from the background
	# so i use #303030
	# it just makes the filler sligthly darker then the rest of the bar
	face global yummy_bar_space_color default,rgb:303030
	face global StatusLine           default,rgb:3C3836
}

provide-module yummy_the_rigth_config %{
	require-module yummy

	# se std_config for this snippet
	hook global  WinCreate .* %{
		face window yummy_client_server_face +ba@yummy_mode_face
	}
	# format string. We leve the left side blank, then it (and
	#  the central filler) won't be renderd
	set global yummy_fmt_right     " $selection in $bufname$modified $clock $client_server $mode"

	# use a sligthly smaller and more stylish modification indicator
	set global yummy_modified_text "+"
}

provide-module yummy_powerline_config %{
	require-module yummy

	# se std_config for this snippet
	hook global  WinCreate .* %{
		face window yummy_client_server_face +ba@yummy_mode_face
		# we also want the selection to change color with the rest
		# of the bar
		face window yummy_selection_face     +ba@yummy_mode_face

	}
	# format string. Here you can se that we put free text
	# (dividers) in the format string. They will use the
	# StatusLine face.
	set  global yummy_fmt_right            " $git$selection in $bufname$modified$lsp_error$lsp_warn$lsp_info$lsp_hint  $clock  $client_server$mode"
	# client_server format. Notice the divider at the end.
	# It is there so that it will be colord with the
	# yummy_client_server_face and change color with the
	# mode indicator.
	set  global yummy_client_server_format "$kak_client@[$kak_session] "

	# small modification indicator
	set  global yummy_modified_text        "+"

	# don't underline the buffer name
	face global yummy_bufname_face         +id@StatusLine

	# add arrow if the git symbol is displayd
	set global yummy_git_format %{$([ -n "$kak_opt_yummy_git_branch" ] && printf %s " $kak_opt_yummy_git_branch  ")}	
}

# this is the same thing as powerline_config but from
# left to rigth
provide-module yummy_powerline_left_config %{
	require-module yummy_powerline_config

	# clear the rigth side and setup the left side
	# this is just the same thing as the powerline_config
	set global yummy_fmt_right             ""
	set global yummy_fmt_left              "$mode$client_server  $clock  $selection in $bufname$modified$lsp_error$lsp_warn$lsp_info$lsp_hint$git"
	#more stuff that's wery much like the powerline_config
	set global yummy_modified_text         "+"
	set global yummy_client_server_format  " $kak_client@[$kak_session]"
	set global yummy_git_format %{$([ -n "$kak_opt_yummy_git_branch" ] && printf %s "   $kak_opt_yummy_git_branch")}
}
